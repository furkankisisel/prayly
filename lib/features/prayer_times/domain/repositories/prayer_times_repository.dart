import '../entities/daily_prayer_times.dart';

abstract class PrayerTimesRepository {
  Future<DailyPrayerTimes> getTodayPrayerTimes({
    required double lat,
    required double lon,
  });

  Future<DailyPrayerTimes> getPrayerTimesForDate({
    required double lat,
    required double lon,
    required DateTime date,
  });
}
