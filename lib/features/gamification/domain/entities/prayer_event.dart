/// Gamification sisteminde işlenen namaz kaydı eventi
class PrayerEvent {
  final String prayerType; // fajr, dhuhr, asr, maghrib, isha, jumu'ah, eid
  final PrayerMode mode;
  final DateTime timestamp;
  final String? mosqueId; // null = evde
  final Set<EventFlag> flags; // ramazan, kandil, eid, friday vb.
  final double? latitude;
  final double? longitude;

  const PrayerEvent({
    required this.prayerType,
    required this.mode,
    required this.timestamp,
    this.mosqueId,
    this.flags = const {},
    this.latitude,
    this.longitude,
  });

  /// XP hesaplama için temel çarpan
  double get baseModeMultiplier => switch (mode) {
    PrayerMode.normal => 1.0,
    PrayerMode.mosqueSingle => 10.0,
    PrayerMode.congregation => 27.0,
    PrayerMode.mosqueCongregation => 40.0,
    PrayerMode.qada => 0.5,
  };

  /// Özel gün bonus çarpanları
  double get eventBonusMultiplier {
    double multiplier = 1.0;
    if (flags.contains(EventFlag.friday)) multiplier *= 1.20;
    if (flags.contains(EventFlag.ramadan)) multiplier *= 1.15;
    if (flags.contains(EventFlag.kandil)) multiplier *= 1.25;
    if (flags.contains(EventFlag.eid)) multiplier *= 1.30;
    return multiplier;
  }

  /// RU (Rarity Unit) hesaplama
  double calculateRU(bool isInStreak) => isInStreak ? 1.5 : 1.0;

  Map<String, dynamic> toJson() => {
    'prayerType': prayerType,
    'mode': mode.name,
    'timestamp': timestamp.toIso8601String(),
    'mosqueId': mosqueId,
    'flags': flags.map((f) => f.name).toList(),
    'latitude': latitude,
    'longitude': longitude,
  };

  factory PrayerEvent.fromJson(Map<String, dynamic> json) => PrayerEvent(
    prayerType: json['prayerType'],
    mode: PrayerMode.values.byName(json['mode']),
    timestamp: DateTime.parse(json['timestamp']),
    mosqueId: json['mosqueId'],
    flags:
        (json['flags'] as List?)
            ?.map((f) => EventFlag.values.byName(f))
            .toSet() ??
        {},
    latitude: json['latitude'],
    longitude: json['longitude'],
  );
}

enum PrayerMode { normal, mosqueSingle, congregation, mosqueCongregation, qada }

enum EventFlag { friday, ramadan, kandil, eid, mosqueAdded }
