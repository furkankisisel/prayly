import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/daily_prayer_times.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/entities/islamic_holidays.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../data/services/prayer_times_cache.dart';
import '../../data/services/notification_service.dart';
import '../../data/repositories/aladhan_prayer_times_repository.dart';

class PrayerTimesState {
  final bool loading;
  final DailyPrayerTimes? data;
  final String? error;
  final Duration? countdown; // kalan süre
  final PrayerTime? next;
  PrayerTimesState({
    required this.loading,
    required this.data,
    required this.error,
    required this.countdown,
    required this.next,
  });

  factory PrayerTimesState.initial() => PrayerTimesState(
    loading: true,
    data: null,
    error: null,
    countdown: null,
    next: null,
  );

  PrayerTimesState copyWith({
    bool? loading,
    DailyPrayerTimes? data,
    String? error,
    Duration? countdown,
    PrayerTime? next,
  }) => PrayerTimesState(
    loading: loading ?? this.loading,
    data: data ?? this.data,
    error: error,
    countdown: countdown ?? this.countdown,
    next: next ?? this.next,
  );
}

class PrayerTimesController extends ChangeNotifier {
  final PrayerTimesRepository repository;
  final PrayerTimesCacheService cache;
  final PrayerNotificationService notifications;
  int method;
  double? _lat;
  double? _lon;
  String? currentCity;
  String currentCountry = 'Turkey';
  PrayerTimesController(
    this.repository, {
    required this.cache,
    required this.notifications,
    this.method = 13,
  });

  bool notifyOnTime = true;
  bool notifyPre = false;
  int notifyPreMinutes = 10; // minutes before
  bool notificationsPaused = false; // kadın özel modu vb. için
  bool inPrayerMode = false; // Namazdayım modu
  PrayerNotificationSound currentSound = PrayerNotificationSound.system;
  final int inPrayerDelayMinutes =
      5; // inPrayerMode açıkken yakın bildirimleri ertele
  // Per prayer overrides: { prayerName : { 'onTime': bool, 'pre': bool, 'preMinutes': int } }
  Map<String, Map<String, dynamic>> perPrayerNotif = {};

  PrayerTimesState _state = PrayerTimesState.initial();
  PrayerTimesState get state => _state;
  Timer? _ticker;

  Future<void> load(double lat, double lon) async {
    _lat = lat;
    _lon = lon;
    _set(_state.copyWith(loading: true, error: null));
    try {
      final data = await repository.getTodayPrayerTimes(lat: lat, lon: lon);
      _set(_state.copyWith(loading: false, data: data));
      unawaited(cache.save(data, method));
      unawaited(_loadNotificationSettingsIfNeeded());
      _startTicker();
      _scheduleNotificationIfNeeded();
      _scheduleAllDayIfPossible();
    } catch (e) {
      _set(_state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadByCity(String city, {String country = 'Turkey'}) async {
    _lat = null;
    _lon = null; // city mode
    currentCity = city;
    currentCountry = country;
    _set(_state.copyWith(loading: true, error: null));
    try {
      final dynamic repo = repository;
      final data = await repo.getTodayPrayerTimesByCity(
        city: city,
        country: country,
      );
      _set(_state.copyWith(loading: false, data: data));
      unawaited(cache.save(data, method));
      unawaited(cache.saveCity(city, country));
      unawaited(_loadNotificationSettingsIfNeeded());
      _startTicker();
      _scheduleNotificationIfNeeded();
      _scheduleAllDayIfPossible();
    } catch (e) {
      _set(_state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadAutomaticLocation() async {
    currentCity = null; // switch to GPS mode
    currentCountry = 'Turkey';
    unawaited(cache.clearCity());
    // Konum izinlerini kontrol et
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _set(_state.copyWith(error: 'Konum izni reddedildi'));
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await load(pos.latitude, pos.longitude);
    } catch (e) {
      _set(_state.copyWith(error: 'Konum alınamadı: $e'));
    }
  }

  Future<void> loadLastCityIfAny() async {
    final last = await cache.loadCity();
    if (last != null) {
      await loadByCity(last.$1, country: last.$2);
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final data = _state.data;
    if (data == null) return;
    final now = DateTime.now();
    var next = data.nextAfter(now);
    if (next == null) {
      // Isha'dan sonra: yarının vakitlerini yükle ve oradan devam et.
      final tomorrow = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 1));
      if (_lat != null && _lon != null) {
        repository
            .getPrayerTimesForDate(lat: _lat!, lon: _lon!, date: tomorrow)
            .then((tomorrowData) {
              _set(_state.copyWith(data: tomorrowData));
              final n2 = tomorrowData.nextAfter(DateTime.now());
              if (n2 != null) {
                _set(
                  _state.copyWith(
                    next: n2,
                    countdown: n2.time.difference(DateTime.now()),
                  ),
                );
              }
            });
      } else if (currentCity != null &&
          repository is AladhanPrayerTimesRepository) {
        (repository as AladhanPrayerTimesRepository)
            .getPrayerTimesForDateByCity(
              city: currentCity!,
              country: currentCountry,
              date: tomorrow,
            )
            .then((tomorrowData) {
              _set(_state.copyWith(data: tomorrowData));
              final n2 = tomorrowData.nextAfter(DateTime.now());
              if (n2 != null) {
                _set(
                  _state.copyWith(
                    next: n2,
                    countdown: n2.time.difference(DateTime.now()),
                  ),
                );
              }
            });
      }
      // Bu sırada countdown '—:—' olmasın diye bir placeholder koymuyoruz; UI next null ise bekleyebilir.
      return;
    }
    final prevNext = _state.next;
    _set(_state.copyWith(next: next, countdown: next.time.difference(now)));
    _persistWidgetSnapshot();
    if (prevNext == null || prevNext.name != next.name) {
      _scheduleNotificationIfNeeded();
    }
  }

  void _scheduleAllDayIfPossible() {
    final data = _state.data;
    if (data == null) return;
    // Tüm gün vakitleri programla (kullanıcının ayarlarını kullan)
    notifications.scheduleAllDay(
      data,
      onTime: notifyOnTime,
      pre: notifyPre,
      preMinutes: notifyPreMinutes,
    );
  }

  String formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);
  String formatCountdown(Duration? d) {
    if (d == null) return '--:--:--';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return [
      if (h > 0) h.toString().padLeft(2, '0'),
      m.toString().padLeft(2, '0'),
      s.toString().padLeft(2, '0'),
    ].join(':');
  }

  /// Bugünkü kandil gününü döndürür
  String? getTodaysKandil() {
    return IslamicHolidays.getTodaysKandil();
  }

  /// Şu anda kerahat vakti mi kontrol eder
  bool isKerahatTime() {
    final data = _state.data;
    if (data == null) return false;

    final now = DateTime.now();
    final prayerTimes = data.times.map((t) => t.time).toList();
    return KerahatVakitleri.isKerahatTime(now, prayerTimes);
  }

  /// Kerahat vakti açıklaması
  String getKerahatReason() {
    final data = _state.data;
    if (data == null) return '';

    final now = DateTime.now();
    final prayerTimes = data.times.map((t) => t.time).toList();
    return KerahatVakitleri.getKerahatReason(now, prayerTimes);
  }

  /// Kandil günü mü kontrol eder
  bool isKandilDay() {
    return IslamicHolidays.isSpecialDay();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _set(PrayerTimesState s) {
    _state = s;
    notifyListeners();
  }

  Future<void> _persistWidgetSnapshot() async {
    final next = _state.next;
    final countdown = _state.countdown;
    if (next == null || countdown == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('widget_next_prayer_name', next.name);
      await prefs.setString(
        'widget_next_prayer_time',
        next.time.toIso8601String(),
      );
      await prefs.setInt('widget_next_prayer_countdown', countdown.inSeconds);
      final data = _state.data;
      if (data != null) {
        final listStr = data.times
            .map((t) => '${t.name}|${DateFormat('HH:mm').format(t.time)}')
            .join(';');
        await prefs.setString('widget_prayer_times_list', listStr);
        for (final t in data.times) {
          await prefs.setString(
            'widget_time_${t.name}',
            DateFormat('HH:mm').format(t.time),
          );
        }
      }
      // trigger native widget refresh
      const ch = MethodChannel('home_widgets');
      await ch.invokeMethod('refreshPrayerTimes');
    } catch (_) {}
  }

  Future<void> loadFromCacheIfAvailable() async {
    final cached = await cache.load();
    if (cached != null && DateTime.now().difference(cached.date).inDays == 0) {
      _set(_state.copyWith(loading: false, data: cached));
      _startTicker();
    }
  }

  void _scheduleNotificationIfNeeded() {
    final next = _state.next;
    if (next == null) return;
    if (notificationsPaused) return; // paused state => scheduling disabled
    final override = perPrayerNotif[next.name];
    final onTimeEnabled = override?['onTime'] as bool? ?? notifyOnTime;
    final preEnabled = override?['pre'] as bool? ?? notifyPre;
    final preMinutesVal = override?['preMinutes'] as int? ?? notifyPreMinutes;
    // Determine per-prayer sound overrides
    final soundOnTimeId =
        (override?['soundOnTime'] as String?) ??
        (override?['sound'] as String?);
    final soundPreId =
        (override?['soundPre'] as String?) ?? (override?['sound'] as String?);
    final soundOnTimeOverride = soundOnTimeId != null
        ? PrayerNotificationSound.values.firstWhere(
            (e) => e.id == soundOnTimeId,
            orElse: () => currentSound,
          )
        : null;
    final soundPreOverride = soundPreId != null
        ? PrayerNotificationSound.values.firstWhere(
            (e) => e.id == soundPreId,
            orElse: () => currentSound,
          )
        : null;
    if (onTimeEnabled) {
      unawaited(
        notifications.scheduleAt(
          _maybeDelay(next.time),
          title: 'Vakit: ${next.name}',
          body: 'Saat ${formatTime(next.time)}',
          soundOverride: soundOnTimeOverride,
        ),
      );
    }
    if (preEnabled) {
      final preTime = next.time.subtract(Duration(minutes: preMinutesVal));
      if (preTime.isAfter(DateTime.now())) {
        unawaited(
          notifications.scheduleAt(
            _maybeDelay(preTime),
            title: 'Yaklaşıyor: ${next.name}',
            body: '$preMinutesVal dk kaldı',
            soundOverride: soundPreOverride,
          ),
        );
      }
    }
  }

  Future<void> changeMethod(int newMethod) async {
    if (method == newMethod) return;
    method = newMethod;
    await cache.saveMethod(newMethod);
    if (currentCity != null) {
      await loadByCity(currentCity!, country: currentCountry);
    } else if (_lat != null && _lon != null) {
      await load(_lat!, _lon!);
    }
  }

  Future<void> _loadNotificationSettingsIfNeeded() async {
    // Only load once
    if (_loadedNotifSettings) return;
    _loadedNotifSettings = true;
    final settings = await cache.loadNotificationSettings();
    notifyOnTime = settings.$1;
    notifyPre = settings.$2;
    notifyPreMinutes = settings.$3;
    perPrayerNotif = await cache.loadPerPrayerNotificationSettings();
    notificationsPaused = await cache.loadPaused();
    final soundId = await cache.loadSound();
    if (soundId != null) {
      final found = PrayerNotificationSound.values.firstWhere(
        (e) => e.id == soundId,
        orElse: () => PrayerNotificationSound.system,
      );
      currentSound = found;
      notifications.setSound(found);
    }
  }

  bool _loadedNotifSettings = false;

  Future<void> updateNotificationSettings({
    bool? onTime,
    bool? pre,
    int? preMinutes,
    bool? paused,
  }) async {
    if (onTime != null) notifyOnTime = onTime;
    if (pre != null) notifyPre = pre;
    if (preMinutes != null) notifyPreMinutes = preMinutes;
    if (paused != null) notificationsPaused = paused;
    await cache.saveNotificationSettings(
      onTime: notifyOnTime,
      pre: notifyPre,
      preMinutes: notifyPreMinutes,
    );
    _scheduleNotificationIfNeeded();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  Future<void> togglePauseNotifications() async {
    notificationsPaused = !notificationsPaused;
    if (notificationsPaused) {
      await notifications.cancelAll();
    } else {
      _scheduleNotificationIfNeeded();
    }
    await cache.savePaused(notificationsPaused);
    notifyListeners();
  }

  void toggleInPrayerMode() {
    inPrayerMode = !inPrayerMode;
    _applyRingerMode();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  static const _ringerChannel = MethodChannel('device_ringer');
  Future<void> _applyRingerMode() async {
    try {
      if (inPrayerMode) {
        try {
          await _ringerChannel.invokeMethod('setMode', {'mode': 'silent'});
        } on PlatformException catch (e) {
          // If no permission to set silent directly, fall back to vibrate
          if (e.code == 'NO_PERMISSION') {
            await _ringerChannel.invokeMethod('setMode', {'mode': 'vibrate'});
          }
        }
      } else {
        // restore previous if stored (native side handles restore)
        await _ringerChannel.invokeMethod('setMode', {'mode': 'restore'});
      }
    } catch (_) {
      // ignore failures silently
    }
  }

  Future<void> updatePerPrayerNotification(
    String prayerName, {
    bool? onTime,
    bool? pre,
    int? preMinutes,
    String? sound, // legacy combined override
    String? soundOnTime,
    String? soundPre,
  }) async {
    final current = perPrayerNotif[prayerName] ?? <String, dynamic>{};
    if (onTime != null) current['onTime'] = onTime;
    if (pre != null) current['pre'] = pre;
    if (preMinutes != null) current['preMinutes'] = preMinutes;
    // Sound handling (only set keys that are provided)
    if (soundOnTime != null) {
      current['soundOnTime'] = soundOnTime;
    }
    if (soundPre != null) {
      current['soundPre'] = soundPre;
    }
    if (sound != null) {
      current['sound'] = sound; // legacy
    }
    perPrayerNotif[prayerName] = current;
    await cache.savePerPrayerNotificationSettings(perPrayerNotif);
    _scheduleNotificationIfNeeded();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  DateTime _maybeDelay(DateTime original) {
    if (!inPrayerMode) return original;
    final now = DateTime.now();
    if (original.isBefore(now)) return original;
    final diff = original.difference(now);
    if (diff.inMinutes <= 30) {
      return original.add(Duration(minutes: inPrayerDelayMinutes));
    }
    return original;
  }

  Future<void> changeSound(PrayerNotificationSound sound) async {
    currentSound = sound;
    notifications.setSound(sound);
    await cache.saveSound(sound.id);
    // Günün geri kalanı için yeniden zamanla
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  /// Belirtilen namaz için tüm özelleştirmeleri kaldırır (global ayarlara döner)
  Future<void> clearPerPrayerOverrides(String prayerName) async {
    perPrayerNotif.remove(prayerName);
    await cache.savePerPrayerNotificationSettings(perPrayerNotif);
    _scheduleNotificationIfNeeded();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  // Clear specific sound overrides
  Future<void> clearPerPrayerSoundOnTime(String prayerName) async {
    final current = perPrayerNotif[prayerName];
    if (current == null) return;
    current.remove('soundOnTime');
    await cache.savePerPrayerNotificationSettings(perPrayerNotif);
    _scheduleNotificationIfNeeded();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }

  Future<void> clearPerPrayerSoundPre(String prayerName) async {
    final current = perPrayerNotif[prayerName];
    if (current == null) return;
    current.remove('soundPre');
    await cache.savePerPrayerNotificationSettings(perPrayerNotif);
    _scheduleNotificationIfNeeded();
    _scheduleAllDayIfPossible();
    notifyListeners();
  }
}
