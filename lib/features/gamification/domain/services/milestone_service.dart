import '../entities/game_card.dart';

/// Milestone (başarı) kartlarını yöneten servis
class MilestoneService {
  /// Milestone tanımları - sabit başarılar
  static final List<MilestoneDefinition> _milestones = [
    // İlk namazlar
    MilestoneDefinition(
      id: 'first_prayer',
      title: 'İlk Adım',
      description: 'İlk namazınızı kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.bronze,
      triggerType: MilestoneTriggerType.totalPrayer,
      threshold: 1,
      baseXp: 50,
    ),
    MilestoneDefinition(
      id: 'prayer_10',
      title: 'Düzenli',
      description: '10 namaz kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.bronze,
      triggerType: MilestoneTriggerType.totalPrayer,
      threshold: 10,
      baseXp: 100,
    ),
    MilestoneDefinition(
      id: 'prayer_50',
      title: 'Azimli',
      description: '50 namaz kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.silver,
      triggerType: MilestoneTriggerType.totalPrayer,
      threshold: 50,
      baseXp: 250,
    ),
    MilestoneDefinition(
      id: 'prayer_100',
      title: 'Müdavim',
      description: '100 namaz kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.gold,
      triggerType: MilestoneTriggerType.totalPrayer,
      threshold: 100,
      baseXp: 500,
    ),

    // Cemaat namazları
    MilestoneDefinition(
      id: 'first_congregation',
      title: 'Cemaat İle',
      description: 'İlk cemaat namazınızı kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.bronze,
      triggerType: MilestoneTriggerType.congregationTotal,
      threshold: 1,
      baseXp: 75,
    ),
    MilestoneDefinition(
      id: 'congregation_25',
      title: 'Cemaat Dostu',
      description: '25 cemaat namazı kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.silver,
      triggerType: MilestoneTriggerType.congregationTotal,
      threshold: 25,
      baseXp: 300,
    ),
    MilestoneDefinition(
      id: 'congregation_100',
      title: 'Cemaat Ustası',
      description: '100 cemaat namazı kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.gold,
      triggerType: MilestoneTriggerType.congregationTotal,
      threshold: 100,
      baseXp: 750,
    ),

    // Cami ziyaretleri
    MilestoneDefinition(
      id: 'first_mosque',
      title: 'İlk Ziyaret',
      description: 'İlk cami ziyaretinizi kaydettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.bronze,
      triggerType: MilestoneTriggerType.uniqueMosque,
      threshold: 1,
      baseXp: 100,
    ),
    MilestoneDefinition(
      id: 'mosque_explorer_5',
      title: 'Keşifçi',
      description: '5 farklı cami ziyaret ettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.silver,
      triggerType: MilestoneTriggerType.uniqueMosque,
      threshold: 5,
      baseXp: 400,
    ),
    MilestoneDefinition(
      id: 'mosque_explorer_25',
      title: 'Cami Uzmanı',
      description: '25 farklı cami ziyaret ettiniz',
      category: GameCardCategory.milestone,
      rarity: Rarity.gold,
      triggerType: MilestoneTriggerType.uniqueMosque,
      threshold: 25,
      baseXp: 1000,
    ),

    // Streak başarıları
    MilestoneDefinition(
      id: 'streak_7',
      title: 'Haftalık Disiplin',
      description: '7 gün aralıksız cemaat',
      category: GameCardCategory.milestone,
      rarity: Rarity.silver,
      triggerType: MilestoneTriggerType.congregationStreak,
      threshold: 7,
      baseXp: 350,
    ),
    MilestoneDefinition(
      id: 'streak_30',
      title: 'Aylık Kararlılık',
      description: '30 gün aralıksız cemaat',
      category: GameCardCategory.milestone,
      rarity: Rarity.gold,
      triggerType: MilestoneTriggerType.congregationStreak,
      threshold: 30,
      baseXp: 1500,
    ),
    MilestoneDefinition(
      id: 'streak_100',
      title: 'Efsane Disiplin',
      description: '100 gün aralıksız cemaat',
      category: GameCardCategory.milestone,
      rarity: Rarity.diamond,
      triggerType: MilestoneTriggerType.congregationStreak,
      threshold: 100,
      baseXp: 5000,
    ),
  ];

  /// Verilen istatistiklere göre kazanılması gereken milestone'ları kontrol et
  static List<GameCard> checkMilestones(
    Map<String, dynamic> stats,
    List<GameCard> existingCards,
  ) {
    final newMilestones = <GameCard>[];
    final existingIds = existingCards.map((c) => c.id).toSet();

    for (final milestone in _milestones) {
      // Bu milestone zaten kazanılmış mı?
      if (existingIds.contains(milestone.id)) continue;

      // Threshold karşılanıyor mu?
      final currentValue = _getStatValue(stats, milestone.triggerType);
      if (currentValue >= milestone.threshold) {
        final milestoneCard = _createMilestoneCard(milestone);
        newMilestones.add(milestoneCard);
      }
    }

    return newMilestones;
  }

  /// İstatistik tipine göre değer al
  static double _getStatValue(
    Map<String, dynamic> stats,
    MilestoneTriggerType type,
  ) {
    switch (type) {
      case MilestoneTriggerType.totalPrayer:
        return (stats['totalPrayers'] ?? 0).toDouble();
      case MilestoneTriggerType.congregationTotal:
        return (stats['congregationTotal'] ?? 0).toDouble();
      case MilestoneTriggerType.congregationStreak:
        return (stats['congregationStreak'] ?? 0).toDouble();
      case MilestoneTriggerType.uniqueMosque:
        return (stats['uniqueMosques'] ?? 0).toDouble();
      case MilestoneTriggerType.fridayTotal:
        return (stats['fridayTotal'] ?? 0).toDouble();
    }
  }

  /// Milestone definition'dan GameCard oluştur
  static GameCard _createMilestoneCard(MilestoneDefinition milestone) {
    return GameCard(
      id: milestone.id,
      title: milestone.title,
      description: milestone.description,
      type: GameCardType.milestone,
      category: milestone.category,
      rarity: milestone.rarity,
      progress: milestone.threshold, // Milestone tamamlandı
      xpContributed: milestone.baseXp,
      ruContributed: 0, // Milestone kartları RU değil XP tabanlı
      lastUpdated: DateTime.now(),
      metadata: {
        'baseXp': milestone.baseXp,
        'threshold': milestone.threshold,
        'triggerType': milestone.triggerType.name,
      },
    );
  }

  /// Tüm milestone tanımlarını getir
  static List<MilestoneDefinition> getAllMilestones() => _milestones;

  /// Belirli bir kategorideki milestone'ları getir
  static List<MilestoneDefinition> getMilestonesByCategory(
    GameCardCategory category,
  ) {
    return _milestones.where((m) => m.category == category).toList();
  }
}

/// Milestone tanımı
class MilestoneDefinition {
  final String id;
  final String title;
  final String description;
  final GameCardCategory category;
  final Rarity rarity;
  final MilestoneTriggerType triggerType;
  final double threshold;
  final double baseXp;

  const MilestoneDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rarity,
    required this.triggerType,
    required this.threshold,
    required this.baseXp,
  });
}

/// Milestone tetikleme türleri
enum MilestoneTriggerType {
  totalPrayer,
  congregationTotal,
  congregationStreak,
  uniqueMosque,
  fridayTotal,
}
