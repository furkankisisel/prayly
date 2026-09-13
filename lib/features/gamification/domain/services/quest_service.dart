
/// Günlük ve haftalık görevleri yöneten servis
class QuestService {
  /// Günlük görev tanımları
  static final List<QuestDefinition> _dailyQuests = [
    QuestDefinition(
      id: 'daily_5_prayers',
      title: '5 Vakit Tamamla',
      description: 'Bugün 5 vakit namazı kaydet',
      type: QuestType.daily,
      targetValue: 5,
      rewardXp: 100,
      icon: 'access_time',
    ),
    QuestDefinition(
      id: 'daily_3_congregation',
      title: '3 Cemaat',
      description: 'Bugün 3 cemaat namazı kaydet',
      type: QuestType.daily,
      targetValue: 3,
      rewardXp: 150,
      icon: 'groups',
    ),
    QuestDefinition(
      id: 'daily_mosque_visit',
      title: 'Cami Ziyareti',
      description: 'Bugün en az 1 camide namaz kıl',
      type: QuestType.daily,
      targetValue: 1,
      rewardXp: 200,
      icon: 'mosque',
    ),
  ];

  /// Haftalık görev tanımları
  static final List<QuestDefinition> _weeklyQuests = [
    QuestDefinition(
      id: 'weekly_friday_prayer',
      title: 'Cuma Namazı',
      description: 'Bu hafta Cuma namazını kaydet',
      type: QuestType.weekly,
      targetValue: 1,
      rewardXp: 300,
      icon: 'celebration',
    ),
    QuestDefinition(
      id: 'weekly_20_congregation',
      title: '20 Cemaat Hedefi',
      description: 'Bu hafta 20 cemaat namazı kaydet',
      type: QuestType.weekly,
      targetValue: 20,
      rewardXp: 500,
      icon: 'groups',
    ),
    QuestDefinition(
      id: 'weekly_streak_7',
      title: '7 Günlük Seri',
      description: 'Bu hafta 7 gün aralıksız namaz kaydet',
      type: QuestType.weekly,
      targetValue: 7,
      rewardXp: 750,
      icon: 'local_fire_department',
    ),
  ];

  /// Aktif görevleri getir
  static List<ActiveQuest> getActiveQuests(
    Map<String, dynamic> todayStats,
    Map<String, dynamic> weeklyStats,
  ) {
    final activeQuests = <ActiveQuest>[];

    // Günlük görevler
    for (final quest in _dailyQuests) {
      final currentProgress = _getQuestProgress(quest, todayStats, weeklyStats);
      activeQuests.add(
        ActiveQuest(
          definition: quest,
          currentProgress: currentProgress,
          isCompleted: currentProgress >= quest.targetValue,
          completedAt: null, // TODO: Completion tracking
        ),
      );
    }

    // Haftalık görevler
    for (final quest in _weeklyQuests) {
      final currentProgress = _getQuestProgress(quest, todayStats, weeklyStats);
      activeQuests.add(
        ActiveQuest(
          definition: quest,
          currentProgress: currentProgress,
          isCompleted: currentProgress >= quest.targetValue,
          completedAt: null,
        ),
      );
    }

    return activeQuests;
  }

  /// Görev tipine göre mevcut ilerlemeyi hesapla
  static double _getQuestProgress(
    QuestDefinition quest,
    Map<String, dynamic> todayStats,
    Map<String, dynamic> weeklyStats,
  ) {
    switch (quest.id) {
      case 'daily_5_prayers':
        return (todayStats['totalPrayers'] ?? 0).toDouble();
      case 'daily_3_congregation':
        return (todayStats['congregationCount'] ?? 0).toDouble();
      case 'daily_mosque_visit':
        return (todayStats['mosqueVisits'] ?? 0).toDouble();
      case 'weekly_friday_prayer':
        return (weeklyStats['fridayPrayers'] ?? 0).toDouble();
      case 'weekly_20_congregation':
        return (weeklyStats['congregationCount'] ?? 0).toDouble();
      case 'weekly_streak_7':
        return (weeklyStats['currentStreak'] ?? 0).toDouble();
      default:
        return 0.0;
    }
  }

  /// Tamamlanan görevlerin XP'sini hesapla
  static double calculateCompletedQuestXp(List<ActiveQuest> quests) {
    double totalXp = 0;
    for (final quest in quests) {
      if (quest.isCompleted) {
        totalXp += quest.definition.rewardXp;
      }
    }
    return totalXp;
  }

  /// Görev tamamlama yüzdesini hesapla
  static double calculateCompletionPercentage(List<ActiveQuest> quests) {
    if (quests.isEmpty) return 0.0;

    final completedCount = quests.where((q) => q.isCompleted).length;
    return completedCount / quests.length;
  }
}

/// Görev tanımı
class QuestDefinition {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final double targetValue;
  final double rewardXp;
  final String icon;

  const QuestDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.rewardXp,
    required this.icon,
  });
}

/// Aktif görev durumu
class ActiveQuest {
  final QuestDefinition definition;
  final double currentProgress;
  final bool isCompleted;
  final DateTime? completedAt;

  const ActiveQuest({
    required this.definition,
    required this.currentProgress,
    required this.isCompleted,
    this.completedAt,
  });

  /// İlerleme yüzdesi (0.0 - 1.0)
  double get progressPercentage {
    if (definition.targetValue == 0) return 0.0;
    return (currentProgress / definition.targetValue).clamp(0.0, 1.0);
  }

  /// Hedeften kalan miktar
  double get remainingProgress {
    return (definition.targetValue - currentProgress).clamp(
      0.0,
      definition.targetValue,
    );
  }
}

/// Görev türleri
enum QuestType { daily, weekly, monthly, special }
