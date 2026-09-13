import 'dart:math' as math;

/// Kullanıcı profili - sadece XP tabanlı
class UserProfile {
  final double totalXp;
  final DateTime lastUpdated;
  final int seasonXp; // Son 30 gün XP (opsiyonel)

  const UserProfile({
    required this.totalXp,
    required this.lastUpdated,
    this.seasonXp = 0,
  });

  /// Level hesaplama: floor(sqrt(totalXp/250))
  int get level => (math.sqrt(totalXp / 250)).floor();

  /// Mevcut seviye için gereken XP
  double get currentLevelXp => level * level * 250;

  /// Bir sonraki seviye için gereken XP
  double get nextLevelXp => (level + 1) * (level + 1) * 250;

  /// Mevcut seviyedeki ilerleme (0.0 - 1.0)
  double get levelProgress {
    if (nextLevelXp == currentLevelXp) return 1.0;
    return (totalXp - currentLevelXp) / (nextLevelXp - currentLevelXp);
  }

  /// Profil çerçevesi (XP eşiğine göre)
  ProfileFrame get frame {
    if (totalXp >= 1000000) return ProfileFrame.aurora;
    if (totalXp >= 500000) return ProfileFrame.cosmic;
    if (totalXp >= 250000) return ProfileFrame.divine;
    if (totalXp >= 100000) return ProfileFrame.platinum;
    if (totalXp >= 50000) return ProfileFrame.diamond;
    if (totalXp >= 25000) return ProfileFrame.gold;
    if (totalXp >= 10000) return ProfileFrame.silver;
    if (totalXp >= 2500) return ProfileFrame.bronze;
    return ProfileFrame.basic;
  }

  /// Unvan (level aralığına göre)
  String get title {
    if (level >= 100) return 'İbadetin Işığı';
    if (level >= 75) return 'Mütekamil Mümin';
    if (level >= 50) return 'Müdavim Mü\'min';
    if (level >= 25) return 'Gayretkeş';
    if (level >= 10) return 'Mübtedi';
    return 'Yeni Başlayan';
  }

  UserProfile copyWith({
    double? totalXp,
    DateTime? lastUpdated,
    int? seasonXp,
  }) => UserProfile(
    totalXp: totalXp ?? this.totalXp,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    seasonXp: seasonXp ?? this.seasonXp,
  );

  Map<String, dynamic> toJson() => {
    'totalXp': totalXp,
    'lastUpdated': lastUpdated.toIso8601String(),
    'seasonXp': seasonXp,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    totalXp: json['totalXp']?.toDouble() ?? 0.0,
    lastUpdated: json['lastUpdated'] != null
        ? DateTime.parse(json['lastUpdated'])
        : DateTime.now(),
    seasonXp: json['seasonXp'] ?? 0,
  );
}

enum ProfileFrame {
  basic,
  bronze,
  silver,
  gold,
  diamond,
  platinum,
  divine,
  cosmic,
  aurora,
}
