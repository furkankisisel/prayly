import '../entities/prayer_event.dart';
import '../entities/user_profile.dart';
import '../entities/game_card.dart';

/// Gamification sistemi ana interface'i
abstract class GamificationRepository {
  /// Kullanıcı profili getir
  Future<UserProfile> getUserProfile();

  /// Kullanıcı profilini güncelle
  Future<void> updateUserProfile(UserProfile profile);

  /// Tüm kartları getir
  Future<List<GameCard>> getAllCards();

  /// Kategori bazlı kartları getir
  Future<List<GameCard>> getCardsByCategory(GameCardCategory category);

  /// Belirli bir kartı getir
  Future<GameCard?> getCard(String cardId);

  /// Kartı güncelle
  Future<void> updateCard(GameCard card);

  /// Localize card titles and descriptions
  Future<void> localizeCards(
    Map<String, String> cardTitles,
    Map<String, String> cardDescriptions,
  );

  /// Prayer event işle - XP ve kart güncellemeleri
  Future<GamificationResult> processPrayerEvent(PrayerEvent event);

  /// Revert previously applied prayer event (remove XP/RU and card contributions)
  /// The implementation should undo the exact deltas recorded when the event
  /// was first processed.
  Future<void> revertPrayerEvent(PrayerEvent event);

  /// Günlük aktiviteyi sıfırla (yeni gün başladığında)
  Future<void> resetDailyActivity();

  /// Streak'leri kontrol et ve gerekirse sıfırla
  Future<void> validateStreaks();

  /// Milestone kartlarını kontrol et
  Future<List<GameCard>> checkMilestones();
}

/// Prayer event işleme sonucu
class GamificationResult {
  final double xpGained;
  final double ruGained;
  final List<GameCard> updatedCards;
  final List<GameCard> newMilestones;
  final UserProfile updatedProfile;

  const GamificationResult({
    required this.xpGained,
    required this.ruGained,
    required this.updatedCards,
    required this.newMilestones,
    required this.updatedProfile,
  });
}
