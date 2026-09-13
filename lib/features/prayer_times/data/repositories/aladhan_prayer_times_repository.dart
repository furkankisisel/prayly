import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../domain/entities/daily_prayer_times.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_times_repository.dart';

/// Aladhan API implementasyonu
/// Docs: https://aladhan.com/prayer-times-api
class AladhanPrayerTimesRepository implements PrayerTimesRepository {
  final http.Client _client;
  final int method; // 13: Diyanet İşleri
  AladhanPrayerTimesRepository({http.Client? client, this.method = 13})
    : _client = client ?? http.Client();

  @override
  Future<DailyPrayerTimes> getTodayPrayerTimes({
    required double lat,
    required double lon,
  }) async {
    final now = DateTime.now();
    return getPrayerTimesForDate(lat: lat, lon: lon, date: now);
  }

  @override
  Future<DailyPrayerTimes> getPrayerTimesForDate({
    required double lat,
    required double lon,
    required DateTime date,
  }) async {
    final ts = date.millisecondsSinceEpoch ~/ 1000;
    final uri = Uri.https('api.aladhan.com', '/v1/timings/$ts', {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'method': method.toString(),
      'adjustment': '0',
    });
    final res = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw HttpException('HTTP ${res.statusCode}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('API code ${json['code']}');
    final data = json['data'] as Map<String, dynamic>;
    final dateInfo = data['date'] as Map<String, dynamic>;
    final readable = dateInfo['readable'] as String; // e.g. "31 Aug 2025"
    final parts = readable.split(' ');
    final day = int.tryParse(parts[0])!;
    final month = _monthFromAbbrev(parts[1]);
    final year = int.tryParse(parts[2])!;
    final base = DateTime(year, month, day);
    final timings = (data['timings'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as String),
    );

    DateTime parse(String key) {
      var raw = timings[key] ?? '00:00';
      raw = raw.split(' ').first; // remove timezone suffix
      final hm = raw.split(':');
      int h = int.tryParse(hm[0]) ?? 0;
      int m = int.tryParse(hm[1]) ?? 0;
      if (h >= 24) h = h % 24; // guard
      return DateTime(year, month, day, h, m);
    }

    String tr(String key) => switch (key) {
      'Fajr' => 'İmsak',
      'Sunrise' => 'Güneş',
      'Dhuhr' => 'Öğle',
      'Asr' => 'İkindi',
      'Maghrib' => 'Akşam',
      'Isha' => 'Yatsı',
      _ => key,
    };
    final order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final baseList = [for (final k in order) PrayerTime(tr(k), parse(k))];
    // Sabah = Güneşten 1 saat önce (her zaman)
    final sunrise = baseList.firstWhere((t) => t.name == 'Güneş').time;
    final sabahTime = sunrise.subtract(const Duration(hours: 1));
    final sabah = PrayerTime('Sabah', sabahTime);
    final list = [
      baseList.firstWhere((t) => t.name == 'İmsak'),
      sabah,
      ...baseList.where((t) => t.name != 'İmsak'),
    ];
    return DailyPrayerTimes(date: base, times: list);
  }

  Future<DailyPrayerTimes> getPrayerTimesForDateByCity({
    required String city,
    required String country,
    required DateTime date,
  }) async {
    final ts = date.millisecondsSinceEpoch ~/ 1000;
    final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity/$ts', {
      'city': city,
      'country': country,
      'method': method.toString(),
      'adjustment': '0',
    });
    final res = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw HttpException('HTTP ${res.statusCode}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('API code ${json['code']}');
    final data = json['data'] as Map<String, dynamic>;
    final dateInfo = data['date'] as Map<String, dynamic>;
    final readable = dateInfo['readable'] as String;
    final parts = readable.split(' ');
    final day = int.tryParse(parts[0])!;
    final month = _monthFromAbbrev(parts[1]);
    final year = int.tryParse(parts[2])!;
    final base = DateTime(year, month, day);
    final timings = (data['timings'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as String),
    );

    DateTime parse(String key) {
      var raw = timings[key] ?? '00:00';
      raw = raw.split(' ').first;
      final hm = raw.split(':');
      int h = int.tryParse(hm[0]) ?? 0;
      int m = int.tryParse(hm[1]) ?? 0;
      if (h >= 24) h = h % 24;
      return DateTime(year, month, day, h, m);
    }

    String tr(String key) => switch (key) {
      'Fajr' => 'İmsak',
      'Sunrise' => 'Güneş',
      'Dhuhr' => 'Öğle',
      'Asr' => 'İkindi',
      'Maghrib' => 'Akşam',
      'Isha' => 'Yatsı',
      _ => key,
    };
    final order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final baseList = [for (final k in order) PrayerTime(tr(k), parse(k))];
    final sunrise = baseList.firstWhere((t) => t.name == 'Güneş').time;
    final sabahTime = sunrise.subtract(const Duration(hours: 1));
    final sabah = PrayerTime('Sabah', sabahTime);
    final list = [
      baseList.firstWhere((t) => t.name == 'İmsak'),
      sabah,
      ...baseList.where((t) => t.name != 'İmsak'),
    ];
    return DailyPrayerTimes(date: base, times: list);
  }

  Future<DailyPrayerTimes> getTodayPrayerTimesByCity({
    required String city,
    String country = 'Turkey',
  }) async {
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity/$ts', {
      'city': city,
      'country': country,
      'method': method.toString(),
      'adjustment': '0',
    });
    final res = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw HttpException('HTTP ${res.statusCode}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('API code ${json['code']}');
    final data = json['data'] as Map<String, dynamic>;
    final dateInfo = data['date'] as Map<String, dynamic>;
    final readable = dateInfo['readable'] as String;
    final parts = readable.split(' ');
    final day = int.tryParse(parts[0])!;
    final month = _monthFromAbbrev(parts[1]);
    final year = int.tryParse(parts[2])!;
    final base = DateTime(year, month, day);
    final timings = (data['timings'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as String),
    );

    DateTime parse(String key) {
      var raw = timings[key] ?? '00:00';
      raw = raw.split(' ').first;
      final hm = raw.split(':');
      int h = int.tryParse(hm[0]) ?? 0;
      int m = int.tryParse(hm[1]) ?? 0;
      if (h >= 24) h = h % 24;
      return DateTime(year, month, day, h, m);
    }

    String tr(String key) => switch (key) {
      'Fajr' => 'İmsak',
      'Sunrise' => 'Güneş',
      'Dhuhr' => 'Öğle',
      'Asr' => 'İkindi',
      'Maghrib' => 'Akşam',
      'Isha' => 'Yatsı',
      _ => key,
    };
    final order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final baseList = [for (final k in order) PrayerTime(tr(k), parse(k))];
    final sunrise = baseList.firstWhere((t) => t.name == 'Güneş').time;
    final sabahTime = sunrise.subtract(const Duration(hours: 1));
    final sabah = PrayerTime('Sabah', sabahTime);
    final list = [
      baseList.firstWhere((t) => t.name == 'İmsak'),
      sabah,
      ...baseList.where((t) => t.name != 'İmsak'),
    ];
    return DailyPrayerTimes(date: base, times: list);
  }

  int _monthFromAbbrev(String m) {
    const map = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return map[m] ?? DateTime.now().month;
  }
}
