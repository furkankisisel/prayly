import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/daily_prayer_times.dart';
import '../../domain/entities/prayer_time.dart';

class PrayerTimesCacheService {
  static const _key = 'daily_prayer_times_v1';
  static const _methodKey = 'prayer_calc_method';
  static const _cityKey = 'prayer_last_city';
  static const _countryKey = 'prayer_last_country';
  static const _notifOnTimeKey = 'notif_on_time_enabled';
  static const _notifPreKey = 'notif_pre_enabled';
  static const _notifPreMinutesKey = 'notif_pre_minutes';
  static const _notifPerPrayerKey = 'notif_per_prayer_v1';
  static const _notifPausedKey = 'notif_paused_flag';
  static const _notifSoundKey = 'notif_sound_choice_v1';

  Future<void> save(DailyPrayerTimes data, int method) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'date': data.date.toIso8601String(),
      'method': method,
      'times': [
        for (final t in data.times)
          {'name': t.name, 'time': t.time.toIso8601String()},
      ],
    };
    await prefs.setString(_key, jsonEncode(payload));
  }

  Future<DailyPrayerTimes?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final date = DateTime.parse(map['date'] as String);
      final times = (map['times'] as List)
          .map(
            (e) => PrayerTime(
              e['name'] as String,
              DateTime.parse(e['time'] as String),
            ),
          )
          .toList();
      return DailyPrayerTimes(date: date, times: times);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMethod(int method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_methodKey, method);
  }

  Future<int?> loadMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_methodKey);
  }

  Future<void> saveCity(String city, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, city);
    await prefs.setString(_countryKey, country);
  }

  Future<void> clearCity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cityKey);
    await prefs.remove(_countryKey);
  }

  Future<(String city, String country)?> loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_cityKey);
    final country = prefs.getString(_countryKey);
    if (c == null || country == null) return null;
    return (c, country);
  }

  Future<void> saveNotificationSettings({
    required bool onTime,
    required bool pre,
    required int preMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifOnTimeKey, onTime);
    await prefs.setBool(_notifPreKey, pre);
    await prefs.setInt(_notifPreMinutesKey, preMinutes);
  }

  Future<(bool onTime, bool pre, int preMinutes)>
  loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final onTime = prefs.getBool(_notifOnTimeKey) ?? true;
    final pre = prefs.getBool(_notifPreKey) ?? false;
    final preMinutes = prefs.getInt(_notifPreMinutesKey) ?? 10;
    return (onTime, pre, preMinutes);
  }

  Future<void> savePaused(bool paused) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifPausedKey, paused);
  }

  Future<bool> loadPaused() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifPausedKey) ?? false;
  }

  Future<void> savePerPrayerNotificationSettings(
    Map<String, Map<String, dynamic>> map,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notifPerPrayerKey, jsonEncode(map));
  }

  Future<Map<String, Map<String, dynamic>>>
  loadPerPrayerNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notifPerPrayerKey);
    if (raw == null) return {};
    try {
      final decoded = (jsonDecode(raw) as Map).map(
        (k, v) => MapEntry(
          k.toString(),
          (v as Map).map((k2, v2) => MapEntry(k2.toString(), v2)),
        ),
      );
      return decoded;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveSound(String soundId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notifSoundKey, soundId);
  }

  Future<String?> loadSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notifSoundKey);
  }
}
