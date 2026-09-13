import 'package:flutter/material.dart';

/// Gamification kartı - streak veya total türünde
class GameCard {
  final String id;
  final String title;
  final String description;
  final GameCardType type;
  final GameCardCategory category;
  final Rarity rarity;
  final double progress; // streak sayısı veya total sayısı
  final double xpContributed; // Bu karttan kazanılan toplam XP
  final double ruContributed; // Bu karttan kazanılan toplam RU
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata; // Ek veriler

  const GameCard({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.rarity,
    required this.progress,
    required this.xpContributed,
    required this.ruContributed,
    required this.lastUpdated,
    this.metadata,
  });

  /// Kart için RU değeri hesaplama
  double get rarityValue {
    switch (type) {
      case GameCardType.streak:
        return progress * 1.5; // bestStreak * 1.5
      case GameCardType.total:
        return ruContributed; // Toplam kazanılan RU
      case GameCardType.milestone:
        return _getMilestoneRarityValue();
    }
  }

  /// Bir sonraki nadirlik için gereken RU
  double get nextRarityThreshold {
    final thresholds = _getRarityThresholds();
    final currentIndex = thresholds.indexWhere((t) => rarityValue < t);
    return currentIndex == -1 ? thresholds.last : thresholds[currentIndex];
  }

  /// Kalan RU miktarı
  double get remainingRU => nextRarityThreshold - rarityValue;

  /// Kart kategorisine ve tipine göre uygun icon
  IconData get icon {
    switch (category) {
      case GameCardCategory.daily:
        return type == GameCardType.streak
            ? Icons
                  .local_fire_department // Streak için alev
            : Icons.calendar_today; // Total için takvim

      case GameCardCategory.friday:
        return Icons.mosque; // Cuma namazı için cami

      case GameCardCategory.kandil:
        return Icons.brightness_7; // Kandil geceleri için parlaklık

      case GameCardCategory.eid:
        return Icons.celebration; // Bayramlar için kutlama

      case GameCardCategory.mosque:
        return Icons.location_on; // Cami keşfi için konum

      case GameCardCategory.milestone:
        return Icons.emoji_events; // Milestone için kupa

      default:
        return Icons.star; // Varsayılan
    }
  }

  /// Kart tipine göre ek icon (overlay olarak kullanılabilir)
  IconData? get typeIcon {
    switch (type) {
      case GameCardType.streak:
        return Icons.trending_up; // Streak
      case GameCardType.total:
        return Icons.format_list_numbered; // Total
      case GameCardType.milestone:
        return Icons.flag; // Milestone
      default:
        return null;
    }
  }

  List<double> _getRarityThresholds() {
    // Kategori bazlı eşikler (bronze, silver, gold, diamond)
    switch (category) {
      case GameCardCategory.daily:
        return [7.0, 30.0, 90.0, 365.0]; // günlük streak/total
      case GameCardCategory.friday:
        return [4.0, 12.0, 52.0, 260.0]; // cuma
      case GameCardCategory.kandil:
        return [3.0, 10.0, 25.0, 100.0]; // kandil geceleri
      case GameCardCategory.eid:
        return [2.0, 5.0, 15.0, 50.0]; // bayramlar
      case GameCardCategory.mosque:
        return [5.0, 25.0, 100.0, 500.0]; // cami keşfi
      case GameCardCategory.milestone:
        return [1.0, 1.0, 1.0, 1.0]; // milestone sabit
    }
  }

  double _getMilestoneRarityValue() {
    // Milestone kartları için rarity sabit
    switch (rarity) {
      case Rarity.bronze:
        return 1.0;
      case Rarity.silver:
        return 2.0;
      case Rarity.gold:
        return 3.0;
      case Rarity.diamond:
        return 4.0;
    }
  }

  GameCard copyWith({
    String? id,
    String? title,
    String? description,
    GameCardType? type,
    GameCardCategory? category,
    Rarity? rarity,
    double? progress,
    double? xpContributed,
    double? ruContributed,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) => GameCard(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    category: category ?? this.category,
    rarity: rarity ?? this.rarity,
    progress: progress ?? this.progress,
    xpContributed: xpContributed ?? this.xpContributed,
    ruContributed: ruContributed ?? this.ruContributed,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    metadata: metadata ?? this.metadata,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.name,
    'category': category.name,
    'rarity': rarity.name,
    'progress': progress,
    'xpContributed': xpContributed,
    'ruContributed': ruContributed,
    'lastUpdated': lastUpdated.toIso8601String(),
    'metadata': metadata,
  };

  factory GameCard.fromJson(Map<String, dynamic> json) => GameCard(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    type: GameCardType.values.byName(json['type']),
    category: GameCardCategory.values.byName(json['category']),
    rarity: Rarity.values.byName(json['rarity']),
    progress: json['progress']?.toDouble() ?? 0.0,
    xpContributed: json['xpContributed']?.toDouble() ?? 0.0,
    ruContributed: json['ruContributed']?.toDouble() ?? 0.0,
    lastUpdated: DateTime.parse(json['lastUpdated']),
    metadata: json['metadata'],
  );
}

enum GameCardType {
  streak, // Süreklili kartları
  total, // Toplam kartları
  milestone, // Milestone kartları
}

enum GameCardCategory {
  daily, // Günlük davranış
  friday, // Cuma
  kandil, // Kandil geceleri
  eid, // Bayramlar
  mosque, // Cami keşfi
  milestone, // Milestone
}

enum Rarity { bronze, silver, gold, diamond }
