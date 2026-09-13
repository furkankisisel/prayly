import '../entities/game_card.dart';
import '../../data/repositories/local_gamification_repository.dart';

/// Kullanıcı istatistiklerini toplayan ve hesaplayan servis
class GamificationStatsService {
  final LocalGamificationRepository _repository;

  GamificationStatsService(this._repository);

  /// Milestone kontrolü için gerekli istatistikleri hesapla
  Future<Map<String, dynamic>> calculateStats() async {
    final allCards = await _repository.getAllCards();

    // Toplam namaz sayısı (tüm kartların progress toplamı)
    final totalPrayers = _calculateTotalPrayers(allCards);

    // Cemaat namazı toplamı
    final congregationTotal = _getCongregationTotal(allCards);

    // En uzun cemaat streak'i
    final congregationStreak = _getBestCongregationStreak(allCards);

    // Benzersiz cami sayısı (gelecek için hazır)
    final uniqueMosques = _getUniqueMosqueCount(allCards);

    // Cuma namazı toplamı
    final fridayTotal = _getFridayTotal(allCards);

    return {
      'totalPrayers': totalPrayers,
      'congregationTotal': congregationTotal,
      'congregationStreak': congregationStreak,
      'uniqueMosques': uniqueMosques,
      'fridayTotal': fridayTotal,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// Toplam namaz sayısını hesapla
  double _calculateTotalPrayers(List<GameCard> cards) {
    double total = 0;

    for (final card in cards) {
      if (card.type == GameCardType.total &&
          card.category == GameCardCategory.daily) {
        total += card.progress;
      }
    }

    return total;
  }

  /// Toplam cemaat namazı sayısını al
  double _getCongregationTotal(List<GameCard> cards) {
    final congregationCards = cards.where(
      (card) =>
          card.type == GameCardType.total &&
          (card.id.contains('congregation') ||
              card.id.contains('mosque_congregation')),
    );

    double total = 0;
    for (final card in congregationCards) {
      total += card.progress;
    }

    return total;
  }

  /// En iyi cemaat streak'ini al
  double _getBestCongregationStreak(List<GameCard> cards) {
    double bestStreak = 0;

    for (final card in cards) {
      if (card.type == GameCardType.streak &&
          (card.id.contains('congregation') ||
              card.id.contains('mosque_congregation'))) {
        if (card.progress > bestStreak) {
          bestStreak = card.progress;
        }
      }
    }

    return bestStreak;
  }

  /// Benzersiz cami sayısını al (gelecek için)
  double _getUniqueMosqueCount(List<GameCard> cards) {
    // Şimdilik 0, cami keşif sistemi eklendiğinde güncellenecek
    return 0;
  }

  /// Toplam Cuma namazı sayısını al
  double _getFridayTotal(List<GameCard> cards) {
    final fridayCard = cards
        .where(
          (card) =>
              card.type == GameCardType.total &&
              card.category == GameCardCategory.friday,
        )
        .firstOrNull;

    return fridayCard?.progress ?? 0;
  }

  /// Kullanıcı için özet istatistik raporu oluştur
  Future<UserStatsReport> generateStatsReport() async {
    final stats = await calculateStats();
    final allCards = await _repository.getAllCards();
    final profile = await _repository.getUserProfile();

    // Aktif streak'leri bul
    final activeStreaks = _getActiveStreaks(allCards);

    // Bu hafta kazanılan XP
    final weeklyXp = _calculateWeeklyXp(allCards);

    // Rarity dağılımı
    final rarityDistribution = _calculateRarityDistribution(allCards);

    return UserStatsReport(
      totalXp: profile.totalXp,
      level: profile.level,
      totalPrayers: stats['totalPrayers'],
      congregationTotal: stats['congregationTotal'],
      bestStreak: stats['congregationStreak'],
      uniqueMosques: stats['uniqueMosques'],
      activeStreaks: activeStreaks,
      weeklyXp: weeklyXp,
      rarityDistribution: rarityDistribution,
      totalCards: allCards.length,
      lastUpdated: DateTime.now(),
    );
  }

  /// Aktif streak'leri getir
  List<ActiveStreak> _getActiveStreaks(List<GameCard> cards) {
    final streaks = <ActiveStreak>[];

    for (final card in cards.where((c) => c.type == GameCardType.streak)) {
      if (card.progress > 0) {
        streaks.add(
          ActiveStreak(
            title: card.title,
            currentValue: card.progress.toInt(),
            category: card.category,
          ),
        );
      }
    }

    // Progress'e göre sırala
    streaks.sort((a, b) => b.currentValue.compareTo(a.currentValue));

    return streaks.take(5).toList(); // En iyi 5'i al
  }

  /// Bu hafta kazanılan XP (yaklaşık)
  double _calculateWeeklyXp(List<GameCard> cards) {
    // Basit yaklaşım: son güncellenen kartların XP'lerini topla
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    double weeklyXp = 0;

    for (final card in cards) {
      if (card.lastUpdated.isAfter(oneWeekAgo)) {
        // Bu hafta güncellenen kartlardan XP tahmin et
        weeklyXp += card.xpContributed * 0.1; // Yaklaşık hesap
      }
    }

    return weeklyXp;
  }

  /// Rarity dağılımını hesapla
  Map<Rarity, int> _calculateRarityDistribution(List<GameCard> cards) {
    final distribution = <Rarity, int>{
      Rarity.bronze: 0,
      Rarity.silver: 0,
      Rarity.gold: 0,
      Rarity.diamond: 0,
    };

    for (final card in cards) {
      distribution[card.rarity] = (distribution[card.rarity] ?? 0) + 1;
    }

    return distribution;
  }
}

/// Kullanıcı istatistik raporu
class UserStatsReport {
  final double totalXp;
  final int level;
  final double totalPrayers;
  final double congregationTotal;
  final double bestStreak;
  final double uniqueMosques;
  final List<ActiveStreak> activeStreaks;
  final double weeklyXp;
  final Map<Rarity, int> rarityDistribution;
  final int totalCards;
  final DateTime lastUpdated;

  const UserStatsReport({
    required this.totalXp,
    required this.level,
    required this.totalPrayers,
    required this.congregationTotal,
    required this.bestStreak,
    required this.uniqueMosques,
    required this.activeStreaks,
    required this.weeklyXp,
    required this.rarityDistribution,
    required this.totalCards,
    required this.lastUpdated,
  });
}

/// Aktif streak bilgisi
class ActiveStreak {
  final String title;
  final int currentValue;
  final GameCardCategory category;

  const ActiveStreak({
    required this.title,
    required this.currentValue,
    required this.category,
  });
}
