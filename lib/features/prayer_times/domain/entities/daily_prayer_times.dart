import 'prayer_time.dart';

class DailyPrayerTimes {
  final DateTime date; // day start (midnight local)
  final List<PrayerTime> times; // ordered chronologically
  DailyPrayerTimes({required this.date, required this.times});

  PrayerTime? nextAfter(DateTime now) {
    for (final t in times) {
      if (t.time.isAfter(now)) return t;
    }
    return null; // none left (day finished)
  }
}
