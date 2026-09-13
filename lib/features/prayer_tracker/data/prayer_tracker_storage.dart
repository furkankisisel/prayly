import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Dört durum: kılmadı (none), kaza, kıldı (kilindi), cemaatle.
enum PrayerStatus { none, kaza, kilindi, cemaat }

extension PrayerStatusX on PrayerStatus {
  String get code => switch (this) {
    PrayerStatus.none => 'none',
    PrayerStatus.kaza => 'kaza',
    PrayerStatus.kilindi => 'kilindi',
    PrayerStatus.cemaat => 'cemaat',
  };
  static PrayerStatus from(String raw) {
    switch (raw) {
      case 'kaza':
        return PrayerStatus.kaza;
      case 'kilindi':
        return PrayerStatus.kilindi;
      case 'cemaat':
        return PrayerStatus.cemaat;
      case 'none':
      default:
        return PrayerStatus.none;
    }
  }
}

/// Namaz lokasyon bilgisi
class PrayerLocation {
  final String name;
  final String? imagePath;
  final DateTime firstVisited;

  const PrayerLocation({
    required this.name,
    this.imagePath,
    required this.firstVisited,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'firstVisited': firstVisited.toIso8601String(),
    };
  }

  factory PrayerLocation.fromJson(Map<String, dynamic> json) {
    // Backward compatibility: check if old coordinate-based format
    if (json.containsKey('latitude') && json.containsKey('longitude')) {
      // Convert old format to new format
      return PrayerLocation(
        name: json['name'] as String,
        imagePath: null, // No image in old format
        firstVisited: DateTime.parse(json['firstVisited'] as String),
      );
    }

    // New format
    return PrayerLocation(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String?,
      firstVisited: DateTime.parse(json['firstVisited'] as String),
    );
  }

  String get uniqueId => name;
}

/// Namaz takip detayı
class PrayerRecord {
  final PrayerStatus status;
  final PrayerLocation? location; // null means not in mosque
  final DateTime? recordedAt;
  final bool isNewLocation;

  const PrayerRecord({
    required this.status,
    this.location,
    this.recordedAt,
    this.isNewLocation = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.code,
      'location': location?.toJson(),
      'recordedAt': recordedAt?.toIso8601String(),
      'isNewLocation': isNewLocation,
    };
  }

  factory PrayerRecord.fromJson(Map<String, dynamic> json) {
    return PrayerRecord(
      status: PrayerStatusX.from(json['status'] as String),
      location: json['location'] != null
          ? PrayerLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      recordedAt: json['recordedAt'] != null
          ? DateTime.parse(json['recordedAt'] as String)
          : null,
      isNewLocation: json['isNewLocation'] as bool? ?? false,
    );
  }
}

class PrayerTrackerStorage {
  static const _keyV2 = 'prayer_tracker_day_v2'; // status map
  static const _keyV3 = 'prayer_tracker_day_v3'; // PrayerRecord map
  static const _keyLocations = 'prayer_locations'; // PrayerLocation list

  Future<Map<String, PrayerRecord>> loadRecordsForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyV3-${_dayKey(date)}';
    final raw = prefs.getString(key);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map;
        return decoded.map(
          (k, v) => MapEntry(
            k.toString(),
            PrayerRecord.fromJson(v as Map<String, dynamic>),
          ),
        );
      } catch (_) {
        return {};
      }
    }
    return {};
  }

  Future<void> saveRecordsForDate(
    DateTime date,
    Map<String, PrayerRecord> records,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_keyV3-${_dayKey(date)}',
      jsonEncode(records.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  // Backward compatibility methods
  Future<Map<String, PrayerStatus>> loadForDate(DateTime date) async {
    final records = await loadRecordsForDate(date);
    return records.map((k, v) => MapEntry(k, v.status));
  }

  Future<void> saveForDate(
    DateTime date,
    Map<String, PrayerStatus> values,
  ) async {
    final records = values.map((k, v) => MapEntry(k, PrayerRecord(status: v)));
    await saveRecordsForDate(date, records);
  }

  // Location management
  Future<List<PrayerLocation>> loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLocations);
    if (raw != null) {
      try {
        final List<dynamic> decoded = jsonDecode(raw);
        return decoded
            .map((e) => PrayerLocation.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  Future<bool> saveLocation(PrayerLocation location) async {
    final locations = await loadSavedLocations();

    // Check if location already exists
    final existingIndex = locations.indexWhere(
      (l) => l.uniqueId == location.uniqueId,
    );
    if (existingIndex == -1) {
      locations.add(location);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyLocations,
        jsonEncode(locations.map((l) => l.toJson()).toList()),
      );
      return true;
    }
    return false;
  }

  Future<int> getUniqueLocationCount() async {
    final locations = await loadSavedLocations();
    return locations.length;
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Future<Set<DateTime>> listRecordedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final set = <DateTime>{};
    for (final k in keys) {
      if (k.startsWith(_keyV3) || k.startsWith(_keyV2)) {
        final prefix = k.startsWith(_keyV3) ? _keyV3 : _keyV2;
        final part = k.substring(prefix.length + 1); // remove prefix + '-'
        final segs = part.split('-');
        if (segs.length == 3) {
          final y = int.tryParse(segs[0]);
          final m = int.tryParse(segs[1]);
          final d = int.tryParse(segs[2]);
          if (y != null && m != null && d != null) {
            set.add(DateTime(y, m, d));
          }
        }
      }
    }
    return set;
  }
}
