import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../domain/entities/prayer_event.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/game_card.dart';
import '../../domain/services/milestone_service.dart';
import '../../domain/services/gamification_stats_service.dart';
import '../datasources/gamification_database.dart';

class LocalGamificationRepository implements GamificationRepository {
  static const String _profileKey = 'gamification_user_profile';
  static const String _cardsKey = 'gamification_cards';
  static const String _lastActivityKey = 'gamification_last_activity';

  // Fallback: SharedPreferences'den profil yükle
  Future<UserProfile> _getUserProfileFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_profileKey);
      if (jsonStr != null) {
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UserProfile.fromJson(data);
      }
    } catch (e) {
      debugPrint('Gamification Repository: _getUserProfileFromPrefs hata: $e');
    }
    return UserProfile(totalXp: 0.0, lastUpdated: DateTime.now(), seasonXp: 0);
  }

  // Fallback: SharedPreferences'e profil kaydet
  Future<void> _saveUserProfileToPrefs(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    } catch (e) {
      debugPrint('Gamification Repository: _saveUserProfileToPrefs hata: $e');
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final profile = await GamificationDatabase.getUserProfile();

      if (profile != null) {
        return profile;
      }

      // İlk kullanım - varsayılan profil
      final defaultProfile = UserProfile(
        totalXp: 0.0,
        lastUpdated: DateTime.now(),
        seasonXp: 0,
      );

      await updateUserProfile(defaultProfile);
      return defaultProfile;
    } catch (e) {
      debugPrint('Gamification Repository: Error loading profile: $e');

      // Fallback to SharedPreferences
      return await _getUserProfileFromPrefs();
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await GamificationDatabase.saveUserProfile(profile);
    } catch (e) {
      debugPrint('Gamification Repository: Error saving profile: $e');

      // Fallback to SharedPreferences
      await _saveUserProfileToPrefs(profile);
    }
  }

  @override
  Future<List<GameCard>> getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getString(_cardsKey);

    if (cardsJson != null) {
      final List<dynamic> cardsList = jsonDecode(cardsJson);
      return cardsList.map((json) => GameCard.fromJson(json)).toList();
    }

    // İlk kullanım - varsayılan kartları oluştur
    final defaultCards = await _createDefaultCards();
    debugPrint(
      'Gamification: ${defaultCards.length} varsayılan kart oluşturuldu',
    );
    await _saveCards(defaultCards);
    return defaultCards;
  }

  @override
  Future<List<GameCard>> getCardsByCategory(GameCardCategory category) async {
    final allCards = await getAllCards();
    return allCards.where((card) => card.category == category).toList();
  }

  @override
  Future<GameCard?> getCard(String cardId) async {
    final allCards = await getAllCards();
    try {
      return allCards.firstWhere((card) => card.id == cardId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateCard(GameCard card) async {
    final allCards = await getAllCards();
    final index = allCards.indexWhere((c) => c.id == card.id);

    if (index != -1) {
      allCards[index] = card;
      await _saveCards(allCards);
    }
  }

  @override
  Future<GamificationResult> processPrayerEvent(PrayerEvent event) async {
    final profile = await getUserProfile();
    final allCards = await getAllCards();

    double totalXpGained = 0.0;
    double totalRuGained = 0.0;
    final updatedCards = <GameCard>[];
    final newMilestones = <GameCard>[];

    // Base XP hesapla
    final baseXp = event.baseModeMultiplier * event.eventBonusMultiplier;

    // İlgili kartları bul ve güncelle
    final relevantCards = _findRelevantCards(allCards, event);

    for (final card in relevantCards) {
      final (updatedCard, xpGained, ruGained) = await _updateCardWithEvent(
        card,
        event,
        baseXp,
      );
      updatedCards.add(updatedCard);
      totalXpGained += xpGained;
      totalRuGained += ruGained;
    }

    // Profili güncelle
    final updatedProfile = profile.copyWith(
      totalXp: profile.totalXp + totalXpGained,
      lastUpdated: DateTime.now(),
    );

    // Kartları kaydet
    for (final card in updatedCards) {
      await updateCard(card);
    }

    await updateUserProfile(updatedProfile);

    // Persist applied event details so we can revert if user edits the record
    try {
      final eventKey = _eventKeyFor(event);
      // Record only the per-card delta contributions to allow accurate revert
      final cardDeltas = <Map<String, dynamic>>[];
      for (int i = 0; i < relevantCards.length; i++) {
        final r = relevantCards[i];
        final updated = updatedCards[i];
        final xpDelta = (updated.xpContributed - r.xpContributed).clamp(
          0.0,
          double.infinity,
        );
        final ruDelta = (updated.ruContributed - r.ruContributed).clamp(
          0.0,
          double.infinity,
        );
        if (xpDelta > 0 || ruDelta > 0) {
          cardDeltas.add({'id': r.id, 'xp': xpDelta, 'ru': ruDelta});
        }
      }

      final payload = jsonEncode({
        'xpGained': totalXpGained,
        'cardDeltas': cardDeltas,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await GamificationDatabase.saveAppliedEvent(eventKey, payload);
    } catch (e) {
      debugPrint('Gamification: failed to save applied event: $e');
    }

    // Milestone kontrolü
    final milestones = await checkMilestones();
    for (final milestone in milestones) {
      if (!allCards.any((c) => c.id == milestone.id)) {
        newMilestones.add(milestone);
        await updateCard(milestone);
      }
    }

    return GamificationResult(
      xpGained: totalXpGained,
      ruGained: totalRuGained,
      updatedCards: updatedCards,
      newMilestones: newMilestones,
      updatedProfile: updatedProfile,
    );
  }

  @override
  Future<void> revertPrayerEvent(PrayerEvent event) async {
    try {
      final eventKey = _eventKeyFor(event);
      final stored = await GamificationDatabase.getAppliedEvent(eventKey);
      if (stored == null) return; // nothing to revert

      final payload =
          jsonDecode(stored['payload'] as String) as Map<String, dynamic>;

      final xpGained = (payload['xpGained'] as num?)?.toDouble() ?? 0.0;
      final List<dynamic> cardDeltas =
          payload['cardDeltas'] as List<dynamic>? ?? [];

      // Load current cards and subtract recorded deltas
      final allCards = await getAllCards();
      for (final delta in cardDeltas) {
        final cardId = delta['id'] as String?;
        if (cardId == null) continue;
        final xpDelta = (delta['xp'] as num?)?.toDouble() ?? 0.0;
        final ruDelta = (delta['ru'] as num?)?.toDouble() ?? 0.0;

        final idx = allCards.indexWhere((c) => c.id == cardId);
        if (idx == -1) continue;

        final current = allCards[idx];
        final reverted = current.copyWith(
          xpContributed: (current.xpContributed - xpDelta).clamp(
            0,
            double.infinity,
          ),
          ruContributed: (current.ruContributed - ruDelta).clamp(
            0,
            double.infinity,
          ),
          // progress and lastUpdated left as-is; more sophisticated revert
          // could restore previous progress but we keep it minimal.
        );

        await updateCard(reverted);
      }

      // Update profile by subtracting xpGained
      final profile = await getUserProfile();
      final updatedProfile = profile.copyWith(
        totalXp: (profile.totalXp - xpGained).clamp(0, double.infinity),
        lastUpdated: DateTime.now(),
      );
      await updateUserProfile(updatedProfile);

      // Finally remove applied event record
      await GamificationDatabase.deleteAppliedEvent(eventKey);
    } catch (e) {
      debugPrint('Gamification revert failed: $e');
    }
  }

  String _eventKeyFor(PrayerEvent event) {
    // Use prayerType + date + mosqueId to build a key unique per-day per-prayer
    final dateKey =
        '${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}';
    return '${event.prayerType}::$dateKey::${event.mosqueId ?? 'home'}';
  }

  @override
  Future<void> resetDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastActivityKey, DateTime.now().toIso8601String());
  }

  @override
  Future<void> validateStreaks() async {
    // Bu method streak kontrolü yapacak - şimdilik boş
    // Gerçek uygulamada son aktivite tarihine göre streak'leri sıfırlayacak
  }

  @override
  Future<List<GameCard>> checkMilestones() async {
    try {
      final statsService = GamificationStatsService(this);
      final stats = await statsService.calculateStats();
      final existingCards = await getAllCards();

      final newMilestones = MilestoneService.checkMilestones(
        stats,
        existingCards,
      );

      // Yeni milestone kartları varsa kaydet
      if (newMilestones.isNotEmpty) {
        final allCards = [...existingCards];
        for (final milestone in newMilestones) {
          // Milestone kartını GameCard'a çevir
          final milestoneCard = _createMilestoneCard(milestone);
          allCards.add(milestoneCard);
        }
        await _saveCards(allCards);
      }

      return newMilestones;
    } catch (e) {
      return [];
    }
  }

  /// Milestone'ı GameCard'a çevir
  GameCard _createMilestoneCard(dynamic milestone) {
    return GameCard(
      id: milestone.id ?? 'milestone_${DateTime.now().millisecondsSinceEpoch}',
      title: milestone.title ?? 'Başarı',
      description: milestone.description ?? 'Yeni başarı kazandınız',
      type: GameCardType.milestone,
      category: GameCardCategory.milestone,
      rarity: milestone.rarity ?? Rarity.bronze,
      progress: 1, // Milestone tamamlandı
      xpContributed: milestone.baseXp?.toDouble() ?? 0.0,
      ruContributed: milestone.baseXp?.toDouble() ?? 0.0,
      lastUpdated: DateTime.now(),
      metadata: {
        'triggerType': milestone.triggerType?.toString(),
        'threshold': milestone.threshold,
      },
    );
  }

  Future<void> _saveCards(List<GameCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = jsonEncode(cards.map((card) => card.toJson()).toList());
    await prefs.setString(_cardsKey, cardsJson);
  }

  /// DEBUG: Tüm gamification verilerini sıfırla
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_cardsKey);
    await prefs.remove(_lastActivityKey);
  }

  List<GameCard> _findRelevantCards(
    List<GameCard> allCards,
    PrayerEvent event,
  ) {
    final relevant = <GameCard>[];

    // Prayer mode'a göre kartları bul
    switch (event.mode) {
      case PrayerMode.normal:
        // Evde kılınan normal namaz
        relevant.addAll(
          allCards.where(
            (c) =>
                c.id.contains('home_prayer_') &&
                c.category == GameCardCategory.daily,
          ),
        );
        break;
      case PrayerMode.congregation:
        relevant.addAll(
          allCards.where(
            (c) =>
                c.id.contains('congregation_') &&
                c.category == GameCardCategory.daily,
          ),
        );
        break;
      case PrayerMode.mosqueCongregation:
        relevant.addAll(
          allCards.where(
            (c) =>
                c.id.contains('mosque_congregation_') &&
                c.category == GameCardCategory.daily,
          ),
        );

        // Add mosque-related cards. Only award 'mosque_discovery' when
        // the event explicitly indicates a newly added mosque.
        relevant.addAll(
          allCards.where(
            (c) =>
                c.category == GameCardCategory.mosque &&
                c.id != 'mosque_discovery',
          ),
        );
        if (event.flags.contains(EventFlag.mosqueAdded)) {
          relevant.addAll(
            allCards.where(
              (c) =>
                  c.category == GameCardCategory.mosque &&
                  c.id == 'mosque_discovery',
            ),
          );
        }
        break;
      case PrayerMode.mosqueSingle:
        relevant.addAll(
          allCards.where(
            (c) =>
                c.id.contains('mosque_single_') &&
                c.category == GameCardCategory.daily,
          ),
        );

        // Add mosque-related cards. Only award 'mosque_discovery' when
        // the event explicitly indicates a newly added mosque.
        relevant.addAll(
          allCards.where(
            (c) =>
                c.category == GameCardCategory.mosque &&
                c.id != 'mosque_discovery',
          ),
        );
        if (event.flags.contains(EventFlag.mosqueAdded)) {
          relevant.addAll(
            allCards.where(
              (c) =>
                  c.category == GameCardCategory.mosque &&
                  c.id == 'mosque_discovery',
            ),
          );
        }
        break;
      case PrayerMode.qada:
        // Kaza namazları için özel kartlar
        relevant.addAll(
          allCards.where(
            (c) =>
                c.id.contains('qada_prayer_') &&
                c.category == GameCardCategory.daily,
          ),
        );
        break;
    }

    // Özel gün kartları
    if (event.flags.contains(EventFlag.friday)) {
      relevant.addAll(
        allCards.where((c) => c.category == GameCardCategory.friday),
      );
    }

    if (event.flags.contains(EventFlag.kandil)) {
      relevant.addAll(
        allCards.where((c) => c.category == GameCardCategory.kandil),
      );
    }

    if (event.flags.contains(EventFlag.eid)) {
      relevant.addAll(
        allCards.where((c) => c.category == GameCardCategory.eid),
      );
    }

    return relevant;
  }

  Future<(GameCard, double, double)> _updateCardWithEvent(
    GameCard card,
    PrayerEvent event,
    double baseXp,
  ) async {
    double xpGained = 0.0;
    double ruGained = 0.0;
    double newProgress = card.progress;

    // Kaza namazı için XP'yi azalt
    double effectiveXp = baseXp;
    if (card.id.contains('qada_prayer_')) {
      effectiveXp = 0.5; // Kaza namazı için sabit 0.5 XP
    }

    if (card.type == GameCardType.streak) {
      final last = card.lastUpdated;
      final eventDate = event.timestamp;
      final sameDay = _isSameDay(last, eventDate);
      final dayDiff = _dayDiff(last, eventDate);

      bool progressed = false;

      if (card.progress == 0) {
        // İlk kez başlıyor
        newProgress = 1;
        progressed = true;
      } else if (sameDay) {
        // Aynı gün tekrar namaz -> streak artmaz, XP/RU vermez bu kart için
        progressed = false;
      } else if (dayDiff == 1) {
        // Aralıksız devam eden gün
        newProgress = card.progress + 1;
        progressed = true;
      } else if (dayDiff > 1) {
        // Streak kırılmış -> yeniden başla
        newProgress = 1;
        progressed = true;
      }

      if (progressed) {
        ruGained = card.id.contains('qada_prayer_') ? 0.5 : 1.5;
        final streakBonus = card.id.contains('qada_prayer_')
            ? 0
            : ((newProgress.clamp(0, 10)) - 1) * 5; // cap 10
        xpGained = effectiveXp + streakBonus;
      } else {
        // Aynı gün tekrarında bu kart için katkı yok
        xpGained = 0;
        ruGained = 0;
      }
    } else if (card.type == GameCardType.total) {
      // Total kartı - toplam artır
      newProgress += 1;
      ruGained = card.id.contains('qada_prayer_')
          ? 0.5
          : 1.0; // Kaza için düşük RU
      xpGained = effectiveXp;
    }

    final updatedCard = card.copyWith(
      progress: newProgress,
      xpContributed: card.xpContributed + xpGained,
      ruContributed: card.ruContributed + ruGained,
      lastUpdated: (card.type == GameCardType.streak && xpGained == 0)
          ? card
                .lastUpdated // Aynı gün tekrarında tarih güncellenmesin
          : DateTime.now(),
    );

    return (updatedCard, xpGained, ruGained);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int _dayDiff(DateTime a, DateTime b) {
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);
    return bDate.difference(aDate).inDays;
  }

  /// Localize card titles and descriptions
  @override
  Future<void> localizeCards(
    Map<String, String> cardTitles,
    Map<String, String> cardDescriptions,
  ) async {
    final cards = await getAllCards();
    final updatedCards = <GameCard>[];

    for (final card in cards) {
      final titleKey = _getCardTitleKey(card.id);
      final descKey = _getCardDescriptionKey(card.id);

      final localizedTitle = cardTitles[titleKey] ?? card.title;
      final localizedDesc = cardDescriptions[descKey] ?? card.description;

      if (localizedTitle != card.title || localizedDesc != card.description) {
        updatedCards.add(
          card.copyWith(title: localizedTitle, description: localizedDesc),
        );
      }
    }

    if (updatedCards.isNotEmpty) {
      // Update all cards
      final allCards = await getAllCards();
      final Map<String, GameCard> updatedMap = {
        for (var card in updatedCards) card.id: card,
      };

      final finalCards = allCards
          .map((card) => updatedMap[card.id] ?? card)
          .toList();

      await _saveCards(finalCards);
    }
  }

  String _getCardTitleKey(String cardId) {
    return 'card${cardId.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('')}';
  }

  String _getCardDescriptionKey(String cardId) {
    return 'cardDesc${cardId.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('')}';
  }

  Future<List<GameCard>> _createDefaultCards() async {
    final now = DateTime.now();

    return [
      // Evde namaz kartları (temel)
      GameCard(
        id: 'home_prayer_streak',
        title: 'Evde Namaz Serisi',
        description: 'Aralıksız evde namaz',
        type: GameCardType.streak,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'home_prayer_total',
        title: 'Evde Namaz Toplamı',
        description: 'Toplam evde kılınan namaz',
        type: GameCardType.total,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Kaza namazı kartı (düşük motivasyon - sadece toplam)
      GameCard(
        id: 'qada_prayer_total',
        title: 'Kaza Toplamı',
        description: 'Toplam kaza namazı',
        type: GameCardType.total,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Günlük cemaat kartları
      GameCard(
        id: 'congregation_streak',
        title: 'Cemaat Serisi',
        description: 'Aralıksız cemaat namazı',
        type: GameCardType.streak,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'congregation_total',
        title: 'Cemaat Toplamı',
        description: 'Toplam cemaat namazı',
        type: GameCardType.total,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Camide cemaat kartları
      GameCard(
        id: 'mosque_congregation_streak',
        title: 'Camide Cemaat Serisi',
        description: 'Aralıksız camide cemaat',
        type: GameCardType.streak,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'mosque_congregation_total',
        title: 'Camide Cemaat Toplamı',
        description: 'Toplam camide cemaat namazı',
        type: GameCardType.total,
        category: GameCardCategory.daily,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Cuma kartları
      GameCard(
        id: 'friday_streak',
        title: 'Cuma Serisi',
        description: 'Aralıksız Cuma namazı',
        type: GameCardType.streak,
        category: GameCardCategory.friday,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'friday_total',
        title: 'Cuma Toplamı',
        description: 'Toplam Cuma namazı',
        type: GameCardType.total,
        category: GameCardCategory.friday,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Kandil kartları
      GameCard(
        id: 'kandil_streak',
        title: 'Kandil Serisi',
        description: 'Aralıksız kandil namazları',
        type: GameCardType.streak,
        category: GameCardCategory.kandil,
        rarity: Rarity.silver,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'kandil_total',
        title: 'Kandil Toplamı',
        description: 'Toplam kandil namazı',
        type: GameCardType.total,
        category: GameCardCategory.kandil,
        rarity: Rarity.silver,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Bayram kartları
      GameCard(
        id: 'eid_streak',
        title: 'Bayram Serisi',
        description: 'Aralıksız bayram namazları',
        type: GameCardType.streak,
        category: GameCardCategory.eid,
        rarity: Rarity.gold,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'eid_total',
        title: 'Bayram Toplamı',
        description: 'Toplam bayram namazı',
        type: GameCardType.total,
        category: GameCardCategory.eid,
        rarity: Rarity.gold,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Cami keşif kartları
      GameCard(
        id: 'mosque_discovery',
        title: 'Cami Kaşifi',
        description: 'Farklı camiler keşfedildi',
        type: GameCardType.total,
        category: GameCardCategory.mosque,
        rarity: Rarity.bronze,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'mosque_regular',
        title: 'Cami Müdavimi',
        description: 'Aynı camide aralıksız namaz',
        type: GameCardType.streak,
        category: GameCardCategory.mosque,
        rarity: Rarity.silver,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),

      // Milestone kartları
      GameCard(
        id: 'first_prayer',
        title: 'İlk Adım',
        description: 'İlk namaz milestone\'ı',
        type: GameCardType.milestone,
        category: GameCardCategory.milestone,
        rarity: Rarity.bronze,
        progress: 1,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'hundred_prayers',
        title: 'Yüz Namaz',
        description: '100 namaz milestone\'ı (toplam)',
        type: GameCardType.milestone,
        category: GameCardCategory.milestone,
        rarity: Rarity.silver,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'five_hundred_prayers',
        title: 'Beş Yüz Namaz',
        description: '500 namaz milestone\'ı (toplam)',
        type: GameCardType.milestone,
        category: GameCardCategory.milestone,
        rarity: Rarity.gold,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
      GameCard(
        id: 'thousand_prayers',
        title: 'Bin Namaz',
        description: '1000 namaz milestone\'ı',
        type: GameCardType.milestone,
        category: GameCardCategory.milestone,
        rarity: Rarity.gold,
        progress: 0,
        xpContributed: 0,
        ruContributed: 0,
        lastUpdated: now,
      ),
    ];
  }
}
