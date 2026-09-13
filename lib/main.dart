import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'gen_l10n/app_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_controller.dart';
import 'features/prayer_times/presentation/pages/prayer_times_page.dart';
import 'features/prayer_times/presentation/controllers/prayer_times_controller.dart';
import 'features/prayer_times/data/repositories/aladhan_prayer_times_repository.dart';
import 'features/prayer_times/data/services/prayer_times_cache.dart';
import 'features/prayer_times/data/services/notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'features/qibla/presentation/pages/qibla_page.dart';
import 'features/prayer_tracker/presentation/pages/prayer_tracker_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/gamification/presentation/pages/gamification_profile_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'shared/widgets/pixel/pixel_app_bar.dart';
import 'shared/widgets/pixel/pixel_nav_bar.dart';
import 'features/onboarding/presentation/pages/onboarding_theme_page.dart';
import 'features/onboarding/presentation/pages/onboarding_language_page.dart';
import 'features/onboarding/presentation/pages/onboarding_location_page.dart';
import 'features/onboarding/presentation/pages/onboarding_variation_page.dart';
import 'features/onboarding/presentation/pages/onboarding_name_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appController = await AppController.create();
  runApp(
    AppControllerProvider(
      controller: appController,
      child: PraylyApp(controller: appController),
    ),
  );
}

class PraylyApp extends StatelessWidget {
  final AppController controller;
  const PraylyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.light(),
        darkTheme: controller.isAmoled ? AppTheme.amoled() : AppTheme.dark(),
        themeMode: controller.flutterThemeMode,
        locale: controller.locale,
        debugShowCheckedModeBanner: false,
        // Slightly increase global text scale for larger widgets/text.
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(textScaler: const TextScaler.linear(1.12)),
            child: child ?? const SizedBox.shrink(),
          );
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'),
          Locale('en', 'US'),
          Locale('ar', 'SA'),
          Locale('es', 'ES'),
          Locale('zh', 'CN'),
          Locale('fr', 'FR'),
          Locale('de', 'DE'),
        ],
        routes: {
          '/': (_) => const SplashPage(),
          '/onboarding/theme': (_) => const OnboardingThemePage(),
          '/onboarding/language': (_) => const OnboardingLanguagePage(),
          '/onboarding/location': (_) => const OnboardingLocationPage(),
          '/onboarding/variation': (_) => const OnboardingVariationPage(),
          '/onboarding/name': (_) => const OnboardingNamePage(),
          '/home': (_) => const _HomeShell(),
        },
        initialRoute: '/',
      ),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;
  late final PrayerTimesController prayerController;

  @override
  void initState() {
    super.initState();
    prayerController = PrayerTimesController(
      AladhanPrayerTimesRepository(),
      cache: PrayerTimesCacheService(),
      notifications: PrayerNotificationService(),
    );
    // Gamification repo'ya prayer window checker bağla
    prayerController.addListener(_bindWindowCheckerOnce);
    // Async initializations
    prayerController.loadFromCacheIfAvailable();
    _preloadMethod();
    prayerController.loadLastCityIfAny();
    _initLocation();
  }

  Future<void> _preloadMethod() async {
    final saved = await prayerController.cache.loadMethod();
    if (saved != null && saved != prayerController.method) {
      prayerController.method = saved;
    }
  }

  Future<void> _initLocation() async {
    try {
      // Use onboarding choices if available
      final prefs = await SharedPreferences.getInstance();
      final chosen = prefs.getBool('onboarding_location_chosen_v1') ?? false;
      if (chosen) {
        final manual = prefs.getString('onboarding_location_manual_v1');
        final city = prefs.getString('onboarding_location_manual_city_v1');
        final country =
            prefs.getString('onboarding_location_manual_country_v1') ??
            'Turkey';
        final lat = prefs.getDouble('onboarding_location_lat_v1');
        final lng = prefs.getDouble('onboarding_location_lng_v1');
        if (manual != null && city != null && city.isNotEmpty) {
          await prayerController.loadByCity(city, country: country);
          return;
        }
        if (lat != null && lng != null) {
          await prayerController.load(lat, lng);
          return;
        }
        // fallback to automatic if chosen but no details
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Service disabled; fall back
        await prayerController.load(41.0082, 28.9784);
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        await prayerController.load(41.0082, 28.9784); // İstanbul fallback
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
      );
      await prayerController.load(pos.latitude, pos.longitude);
    } catch (_) {
      await prayerController.load(41.0082, 28.9784); // fallback
    }
  }

  @override
  void dispose() {
    prayerController.removeListener(_bindWindowCheckerOnce);
    prayerController.dispose();
    super.dispose();
  }

  void _bindWindowCheckerOnce() {}

  List<Widget> get _pages => const [
    PrayerTimesPage(),
    PrayerTrackerPage(),
    QiblaPage(),
    GamificationProfilePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<PrayerTimesController>.value(
      value: prayerController,
      child: Scaffold(
        appBar: PixelAppBar(title: _titleForIndex(_index, l10n)),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _pages[_index],
        ),
        bottomNavigationBar: PixelNavBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: [
            PixelNavItem(
              icon: Icons.access_time,
              label: l10n.navigationPrayerTimes,
            ),
            PixelNavItem(icon: Icons.checklist, label: l10n.navigationTracker),
            PixelNavItem(icon: Icons.explore, label: l10n.navigationQibla),
            PixelNavItem(icon: Icons.auto_awesome, label: l10n.navigationLevel),
            PixelNavItem(icon: Icons.person, label: l10n.navigationProfile),
          ],
        ),
      ),
    );
  }

  String _titleForIndex(int i, AppLocalizations l10n) {
    switch (i) {
      case 0:
        return l10n.screenTitlePrayerTimes;
      case 1:
        return l10n.screenTitlePrayerTracker;
      case 2:
        return l10n.screenTitleQiblaCompass;
      case 3:
        return l10n.screenTitleLevel;
      case 4:
        return l10n.screenTitleProfile;
      default:
        return AppConstants.appName;
    }
  }
}
