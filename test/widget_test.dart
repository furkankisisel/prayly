import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prayly/core/theme/app_controller.dart';
import 'package:prayly/features/prayer_times/domain/entities/prayer_time.dart';
import 'package:prayly/features/prayer_times/domain/entities/daily_prayer_times.dart';
import 'package:prayly/features/splash/presentation/pages/splash_page.dart';

void main() {
  group('AppController & Localization Tests', () {
    test('AppLanguage maps to correct locale and display name', () {
      expect(AppLanguage.turkish.locale, const Locale('tr', 'TR'));
      expect(AppLanguage.english.locale, const Locale('en', 'US'));
      expect(AppLanguage.arabic.locale, const Locale('ar', 'SA'));
      expect(AppLanguage.turkish.displayName, 'Türkçe');
      expect(AppLanguage.english.displayName, 'English');
    });

    test('AppController initializes with default theme mode and language', () {
      final controller = AppController();
      expect(controller.themeMode, AppThemeMode.system);
      expect(controller.language, AppLanguage.turkish);
      expect(controller.locale, const Locale('tr', 'TR'));
    });
  });

  group('DailyPrayerTimes Domain Logic Tests', () {
    test('nextAfter returns the upcoming prayer correctly', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final fajr = PrayerTime('Fajr', DateTime(2026, 1, 1, 6, 0));
      final dhuhr = PrayerTime('Dhuhr', DateTime(2026, 1, 1, 13, 0));
      final asr = PrayerTime('Asr', DateTime(2026, 1, 1, 16, 0));

      final daily = DailyPrayerTimes(
        date: DateTime(2026, 1, 1),
        times: [fajr, dhuhr, asr],
      );

      final next = daily.nextAfter(now);
      expect(next, isNotNull);
      expect(next!.name, 'Dhuhr');
      expect(next.time, DateTime(2026, 1, 1, 13, 0));
    });

    test('nextAfter returns null when all daily prayers have passed', () {
      final now = DateTime(2026, 1, 1, 23, 0);
      final isha = PrayerTime('Isha', DateTime(2026, 1, 1, 20, 0));

      final daily = DailyPrayerTimes(
        date: DateTime(2026, 1, 1),
        times: [isha],
      );

      final next = daily.nextAfter(now);
      expect(next, isNull);
    });
  });

  group('Widget Presentation Tests', () {
    testWidgets('SplashPage mounts and displays scaffold correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(duration: Duration(hours: 1)),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
