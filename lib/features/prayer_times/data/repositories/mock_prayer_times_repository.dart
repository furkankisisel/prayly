import 'dart:math';
import '../../domain/entities/daily_prayer_times.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_times_repository.dart';

/// Geçici mock: random küçük varyansla saatler üretir.
class MockPrayerTimesRepository implements PrayerTimesRepository {
  @override
  Future<DailyPrayerTimes> getTodayPrayerTimes({
    required double lat,
    required double lon,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day);
    final rnd = Random(lat.hashCode ^ lon.hashCode ^ now.day);
    DateTime at(int h, int m) => base.add(
      Duration(hours: h, minutes: m + rnd.nextInt(3)),
    ); // +/- 0-2 min
    final imsak = PrayerTime('İmsak', at(4, 30));
    final gunes = PrayerTime('Güneş', at(6, 5));
    final sabah = PrayerTime(
      'Sabah',
      gunes.time.subtract(const Duration(hours: 1)),
    );
    final list = [
      imsak,
      sabah,
      gunes,
      PrayerTime('Öğle', at(13, 0)),
      PrayerTime('İkindi', at(16, 30)),
      PrayerTime('Akşam', at(19, 15)),
      PrayerTime('Yatsı', at(21, 0)),
    ];
    list.sort((a, b) => a.time.compareTo(b.time));
    return DailyPrayerTimes(date: base, times: list);
  }

  @override
  Future<DailyPrayerTimes> getPrayerTimesForDate({
    required double lat,
    required double lon,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final base = DateTime(date.year, date.month, date.day);
    final rnd = Random(lat.hashCode ^ lon.hashCode ^ date.day);
    DateTime at(int h, int m) =>
        base.add(Duration(hours: h, minutes: m + rnd.nextInt(3)));
    final imsak = PrayerTime('İmsak', at(4, 30));
    final gunes = PrayerTime('Güneş', at(6, 5));
    final sabah = PrayerTime(
      'Sabah',
      gunes.time.subtract(const Duration(hours: 1)),
    );
    final list = [
      imsak,
      sabah,
      gunes,
      PrayerTime('Öğle', at(13, 0)),
      PrayerTime('İkindi', at(16, 30)),
      PrayerTime('Akşam', at(19, 15)),
      PrayerTime('Yatsı', at(21, 0)),
    ];
    list.sort((a, b) => a.time.compareTo(b.time));
    return DailyPrayerTimes(date: base, times: list);
  }
}
