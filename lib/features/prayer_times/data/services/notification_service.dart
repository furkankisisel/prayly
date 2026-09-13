import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:io' as io;
import 'package:flutter/widgets.dart';
import '../../../../gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import '../../domain/entities/prayer_time.dart';
import '../../domain/entities/daily_prayer_times.dart';

/// Desteklenen bildirim sesi seçenekleri. Android için raw/ klasörüne ilgili
/// dosya eklenmeli (örn: android/app/src/main/res/raw/soft_bell.wav)
/// iOS için aynı isimde (örn soft_bell.aiff) Runner projesine eklenmeli.
enum PrayerNotificationSound {
  system,
  softBell,
  softBellAlt,
  shortAdhan,
  natureBell,
  gentleChime,
  qanun,
  single8,
  twoNoteA,
  twoNoteB,
  softMix,
  warm8bitAlt,
  clearSound,
  systemAlarm,
  systemNotification,
  systemRingtone,
}

extension PrayerNotificationSoundX on PrayerNotificationSound {
  String get id => name; // prefs anahtarı olarak
  String get label {
    switch (this) {
      case PrayerNotificationSound.system:
        return 'system';
      case PrayerNotificationSound.softBell:
        return 'softBell';
      case PrayerNotificationSound.softBellAlt:
        return 'softBellAlt';
      case PrayerNotificationSound.shortAdhan:
        return 'shortAdhan';
      case PrayerNotificationSound.natureBell:
        return 'natureBell';
      case PrayerNotificationSound.gentleChime:
        return 'gentleChime';
      case PrayerNotificationSound.qanun:
        return 'qanun';
      case PrayerNotificationSound.single8:
        return 'single8';
      case PrayerNotificationSound.twoNoteA:
        return 'twoNoteA';
      case PrayerNotificationSound.twoNoteB:
        return 'twoNoteB';
      case PrayerNotificationSound.softMix:
        return 'softMix';
      case PrayerNotificationSound.warm8bitAlt:
        return 'warm8bitAlt';
      case PrayerNotificationSound.clearSound:
        return 'clearSound';
      case PrayerNotificationSound.systemAlarm:
        return 'systemAlarm';
      case PrayerNotificationSound.systemNotification:
        return 'systemNotification';
      case PrayerNotificationSound.systemRingtone:
        return 'systemRingtone';
    }
  }

  /// Localized display name using current locale from context.
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PrayerNotificationSound.system:
        return l10n.soundNameSystem;
      case PrayerNotificationSound.softBell:
        return l10n.soundNameSoftBell;
      case PrayerNotificationSound.softBellAlt:
        return l10n.soundNameSoftBellAlt;
      case PrayerNotificationSound.shortAdhan:
        return l10n.soundNameShortAdhan;
      case PrayerNotificationSound.natureBell:
        return l10n.soundNameNatureBell;
      case PrayerNotificationSound.gentleChime:
        return l10n.soundNameGentleChime;
      case PrayerNotificationSound.qanun:
        return l10n.soundNameQanun;
      case PrayerNotificationSound.single8:
        return l10n.soundNameSingle8;
      case PrayerNotificationSound.twoNoteA:
        return l10n.soundNameTwoNoteA;
      case PrayerNotificationSound.twoNoteB:
        return l10n.soundNameTwoNoteB;
      case PrayerNotificationSound.softMix:
        return l10n.soundNameSoftMix;
      case PrayerNotificationSound.warm8bitAlt:
        return l10n.soundNameWarm8bitAlt;
      case PrayerNotificationSound.clearSound:
        return l10n.soundNameClearSound;
      case PrayerNotificationSound.systemAlarm:
        return l10n.soundNameSystemAlarm;
      case PrayerNotificationSound.systemNotification:
        return l10n.soundNameSystemNotification;
      case PrayerNotificationSound.systemRingtone:
        return l10n.soundNameSystemRingtone;
    }
  }

  /// Android raw resource adı (uzantısız). system durumunda null.
  String? get androidRawName {
    switch (this) {
      case PrayerNotificationSound.system:
      case PrayerNotificationSound.systemAlarm:
      case PrayerNotificationSound.systemNotification:
      case PrayerNotificationSound.systemRingtone:
        return null;
      case PrayerNotificationSound.softBell:
        return 'snd_0_4_second_soft_8_bi_2_1757184395518';
      case PrayerNotificationSound.softBellAlt:
        return 'snd_0_4_second_soft_8_bi_3_1757184395483';
      case PrayerNotificationSound.shortAdhan:
        return 'snd_1_second_warm_8_bit_1757184359004';
      case PrayerNotificationSound.natureBell:
        return 'snd_0_5_second_cheerful_2_1757184376408';
      case PrayerNotificationSound.gentleChime:
        return 'snd_0_6_second_airy_8_bi_3_1757184382045';
      case PrayerNotificationSound.qanun:
        return 'snd_0_5_second_qanun_str_2_1757184432228';
      case PrayerNotificationSound.single8:
        return 'snd_0_5_second_single_8_3_1757184394621';
      case PrayerNotificationSound.twoNoteA:
        return 'snd_0_7_second_two_note_1_1757184381080';
      case PrayerNotificationSound.twoNoteB:
        return 'snd_0_7_second_two_note_2_1757184380970';
      case PrayerNotificationSound.softMix:
        return 'snd_1_second_soft_mix_of_3_1757184417575';
      case PrayerNotificationSound.warm8bitAlt:
        return 'snd_1_second_warm_8_bit_2_1757184359010';
      case PrayerNotificationSound.clearSound:
        return 'snd_4_second_clear_sound_3_1757184424196';
    }
  }

  /// iOS custom sound dosya adı (uzantı ile). system durumunda null.
  String? get iosFileName {
    switch (this) {
      case PrayerNotificationSound.system:
      case PrayerNotificationSound.systemAlarm:
      case PrayerNotificationSound.systemNotification:
      case PrayerNotificationSound.systemRingtone:
        return null;
      case PrayerNotificationSound.softBell:
        return '0.4_second_soft_8-bi-#2-1757184395518.wav';
      case PrayerNotificationSound.softBellAlt:
        return '0.4_second_soft_8-bi-#3-1757184395483.wav';
      case PrayerNotificationSound.shortAdhan:
        return '1_second_warm_8-bit_-1757184359004.wav';
      case PrayerNotificationSound.natureBell:
        return '0.5_second_cheerful_-#2-1757184376408.wav';
      case PrayerNotificationSound.gentleChime:
        return '0.6_second_airy_8-bi-#3-1757184382045.wav';
      case PrayerNotificationSound.qanun:
        return '0.5_second_qanun_str-#2-1757184432228.wav';
      case PrayerNotificationSound.single8:
        return '0.5_second_single_8--#3-1757184394621.wav';
      case PrayerNotificationSound.twoNoteA:
        return '0.7_second_two-note_-#1-1757184381080.wav';
      case PrayerNotificationSound.twoNoteB:
        return '0.7_second_two-note_-#2-1757184380970.wav';
      case PrayerNotificationSound.softMix:
        return '1_second_soft_mix_of-#3-1757184417575.wav';
      case PrayerNotificationSound.warm8bitAlt:
        return '1_second_warm_8-bit_-#2-1757184359010.wav';
      case PrayerNotificationSound.clearSound:
        return '4_second_clear_sound-#3-1757184424196.wav';
    }
  }

  /// Sistem seslerini sistem API'sı ile çalmak için gerekli URI
  UriAndroidNotificationSound? get systemSoundUri {
    switch (this) {
      case PrayerNotificationSound.systemAlarm:
        return UriAndroidNotificationSound(
          'android.resource://com.android.providers.settings/raw/alarm',
        );
      case PrayerNotificationSound.systemNotification:
        return UriAndroidNotificationSound(
          'android.resource://com.android.providers.settings/raw/notification',
        );
      case PrayerNotificationSound.systemRingtone:
        return UriAndroidNotificationSound(
          'android.resource://com.android.providers.settings/raw/ringtone',
        );
      default:
        return null;
    }
  }
}

class PrayerNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  PrayerNotificationSound selectedSound = PrayerNotificationSound.system;

  Future<void> init() async {
    if (_initialized) return;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    // Windows requires explicit AUMID (App User Model ID) and lowercase GUID without braces.
    const windowsInit = WindowsInitializationSettings(
      appName: 'Prayly',
      appUserModelId: 'com.prayly.app',
      guid: '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
    );
    try {
      await _plugin.initialize(
        InitializationSettings(
          android: androidInit,
          iOS: iosInit,
          windows: windowsInit,
        ),
      );
      // Android 13+ (API 33) requires runtime POST_NOTIFICATIONS permission.
      if (Platform.isAndroid) {
        try {
          await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
        } catch (_) {
          // ignore; permission request failure shouldn't crash
        }
      }
      _initialized = true;
      // Ensure sound assets are available as files for platforms that require file URIs.
      await _prepareAssetSounds();
    } catch (e) {
      // If Windows init fails, mark initialized to avoid repeated crashes and skip scheduling.
      if (Platform.isWindows) {
        _initialized = true;
      } else {
        rethrow;
      }
    }
  }

  Future<void> scheduleNext(PrayerTime prayer) async {
    await init();
    if (prayer.time.isBefore(DateTime.now())) return;
    if (Platform.isWindows && !_pluginInitializedSafely) return;
    final android = _androidDetails();
    final ios = _iosDetails();
    final windows = const WindowsNotificationDetails();
    // Timezone init
    if (!_initializedTz) {
      await _ensureTimezone();
    }
    final scheduled = tz.TZDateTime.from(prayer.time, tz.local);
    // Lookup localized strings using platform locale so this service doesn't need BuildContext
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final l10n = lookupAppLocalizations(locale);
    final title = l10n.notificationTitleOnTime(prayer.name);
    final body = l10n.notificationBodyOnTime(_fmt(prayer.time));
    try {
      await _plugin.zonedSchedule(
        100,
        title,
        body,
        scheduled,
        NotificationDetails(android: android, iOS: ios, windows: windows),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException catch (e) {
      // Fallback: if exact alarm not permitted, attempt inexact schedule via show() if time is near.
      if (e.code == 'exact_alarms_not_permitted') {
        final diff = scheduled.difference(DateTime.now());
        if (diff.inMinutes <= 1 && diff.isNegative == false) {
          await _plugin.show(
            100,
            l10n.notificationTitleOnTime(prayer.name),
            l10n.notificationBodyOnTime(_fmt(prayer.time)),
            NotificationDetails(android: android, iOS: ios, windows: windows),
          );
        }
      }
    } catch (_) {
      // swallow other exceptions for robustness
    }
  }

  Future<void> scheduleAt(
    DateTime time, {
    required String title,
    required String body,
    int id = 100,
    PrayerNotificationSound? soundOverride,
  }) async {
    await init();
    if (time.isBefore(DateTime.now())) return;
    if (Platform.isWindows && !_pluginInitializedSafely) return;
    if (!_initializedTz) await _ensureTimezone();
    final prev = selectedSound;
    if (soundOverride != null) selectedSound = soundOverride; // geçici
    final android = _androidDetails();
    final ios = _iosDetails();
    final windows = const WindowsNotificationDetails();
    final scheduled = tz.TZDateTime.from(time, tz.local);
    try {
      // Use provided title/body (already expected to be localized by caller).
      final sendTitle = title;
      final sendBody = body;
      await _plugin.zonedSchedule(
        id,
        sendTitle,
        sendBody,
        scheduled,
        NotificationDetails(android: android, iOS: ios, windows: windows),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        final diff = scheduled.difference(DateTime.now());
        if (diff.inMinutes <= 1 && !diff.isNegative) {
          await _plugin.show(
            id,
            title,
            body,
            NotificationDetails(android: android, iOS: ios, windows: windows),
          );
        }
      } else {
        rethrow;
      }
    } catch (_) {
      // swallow other errors for robustness
    } finally {
      // restore previous selection
      selectedSound = prev;
    }
  }

  /// Günün tüm vakitleri için (varsa pre notification dahil) programlar.
  /// Her namaz için benzersiz id: base + index. Pre için farklı base.
  Future<void> scheduleAllDay(
    DailyPrayerTimes day, {
    bool onTime = true,
    bool pre = false,
    int preMinutes = 10,
    Map<String, Map<String, dynamic>>? perPrayerOverrides,
  }) async {
    if (!onTime && !pre) return;
    await init();
    if (!_initializedTz) await _ensureTimezone();
    // Önce iptal (sadece ilgili id aralığı). Kolaylık için hepsini iptal.
    await cancelRange(1000, 1300); // güvenli geniş aralık
    int index = 0;
    for (final p in day.times) {
      final scheduled = tz.TZDateTime.from(p.time, tz.local);
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final l10n = lookupAppLocalizations(locale);
      final override = perPrayerOverrides?[p.name];
      final onTimeEnabled = override?['onTime'] as bool? ?? onTime;
      final preEnabled = override?['pre'] as bool? ?? pre;
      final preMinutesVal = override?['preMinutes'] as int? ?? preMinutes;
      final soundOnTimeId =
          (override?['soundOnTime'] as String?) ??
          (override?['sound'] as String?);
      final soundPreId =
          (override?['soundPre'] as String?) ?? (override?['sound'] as String?);

      if (onTimeEnabled && scheduled.isAfter(DateTime.now())) {
        try {
          final prev = selectedSound;
          if (soundOnTimeId != null) {
            final s = PrayerNotificationSound.values.firstWhere(
              (e) => e.id == soundOnTimeId,
              orElse: () => prev,
            );
            selectedSound = s;
          }
          await _plugin.zonedSchedule(
            1000 + index,
            l10n.notificationTitleOnTime(p.name),
            l10n.notificationBodyOnTime(_fmt(p.time)),
            scheduled,
            NotificationDetails(
              android: _androidDetails(),
              iOS: _iosDetails(),
              windows: const WindowsNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
          selectedSound = prev;
        } on PlatformException catch (e) {
          if (e.code == 'exact_alarms_not_permitted') {
            final diff = scheduled.difference(DateTime.now());
            if (diff.inMinutes <= 1 && diff.isNegative == false) {
              final prev = selectedSound;
              if (soundOnTimeId != null) {
                final s = PrayerNotificationSound.values.firstWhere(
                  (e) => e.id == soundOnTimeId,
                  orElse: () => prev,
                );
                selectedSound = s;
              }
              await _plugin.show(
                1000 + index,
                l10n.notificationTitleOnTime(p.name),
                l10n.notificationBodyOnTime(_fmt(p.time)),
                NotificationDetails(
                  android: _androidDetails(),
                  iOS: _iosDetails(),
                  windows: const WindowsNotificationDetails(),
                ),
              );
              selectedSound = prev;
            }
          }
        } catch (_) {}
      }
      if (preEnabled) {
        final preTime = p.time.subtract(Duration(minutes: preMinutesVal));
        if (preTime.isAfter(DateTime.now())) {
          final preScheduled = tz.TZDateTime.from(preTime, tz.local);
          try {
            final prev = selectedSound;
            if (soundPreId != null) {
              final s = PrayerNotificationSound.values.firstWhere(
                (e) => e.id == soundPreId,
                orElse: () => prev,
              );
              selectedSound = s;
            }
            await _plugin.zonedSchedule(
              1200 + index,
              l10n.notificationTitlePre(p.name),
              l10n.notificationBodyPre(preMinutesVal),
              preScheduled,
              NotificationDetails(
                android: _androidDetails(),
                iOS: _iosDetails(),
                windows: const WindowsNotificationDetails(),
              ),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
            selectedSound = prev;
          } on PlatformException catch (e) {
            if (e.code == 'exact_alarms_not_permitted') {
              final diff = preScheduled.difference(DateTime.now());
              if (diff.inMinutes <= 1 && diff.isNegative == false) {
                final prev = selectedSound;
                if (soundPreId != null) {
                  final s = PrayerNotificationSound.values.firstWhere(
                    (e) => e.id == soundPreId,
                    orElse: () => prev,
                  );
                  selectedSound = s;
                }
                await _plugin.show(
                  1200 + index,
                  l10n.notificationTitlePre(p.name),
                  l10n.notificationBodyPre(preMinutesVal),
                  NotificationDetails(
                    android: _androidDetails(),
                    iOS: _iosDetails(),
                    windows: const WindowsNotificationDetails(),
                  ),
                );
                selectedSound = prev;
              }
            }
          } catch (_) {}
        }
      }
      index++;
    }
  }

  Future<void> cancelRange(int start, int end) async {
    for (int i = start; i <= end; i++) {
      await _plugin.cancel(i);
    }
  }

  AndroidNotificationDetails _androidDetails() {
    final rawName = selectedSound.androidRawName;
    final systemUri = selectedSound.systemSoundUri;

    AndroidNotificationSound? notificationSound;

    if (rawName != null) {
      // Prefer raw resource (if developer added to android/app/src/main/res/raw)
      notificationSound = RawResourceAndroidNotificationSound(rawName);
    } else if (_assetSoundFiles.containsKey(selectedSound)) {
      // Use copied asset file as a file:// URI for platforms that accept it
      final path = _assetSoundFiles[selectedSound]!;
      try {
        notificationSound = UriAndroidNotificationSound(path);
      } catch (_) {
        // Fallback to null -> default system sound
        notificationSound = null;
      }
    } else if (systemUri != null) {
      // System sound
      notificationSound = systemUri;
    }
    // else null for default system sound

    return AndroidNotificationDetails(
      'prayer_times_${selectedSound.id}',
      'Prayer Times',
      channelDescription: 'Prayer time alerts',
      importance: Importance.high,
      priority: Priority.high,
      sound: notificationSound,
      playSound: true,
    );
  }

  // Map of sound enum -> temp file path (file:// URI string or absolute path)
  final Map<PrayerNotificationSound, String> _assetSoundFiles = {};

  Future<void> _prepareAssetSounds() async {
    // Copy known asset files to temporary directory so native plugins can access them.
    try {
      final tempDir = await io.Directory.systemTemp.createTemp(
        'prayly_sounds_',
      );
      for (final s in PrayerNotificationSound.values) {
        final assetName = _assetFileNameFor(s);
        if (assetName == null) continue;
        try {
          final byteData = await rootBundle.load('assets/sounds/$assetName');
          final file = io.File('${tempDir.path}/$assetName');
          await file.writeAsBytes(byteData.buffer.asUint8List());
          // On Windows/Linux the plugin expects absolute file path; on Android a file:// URI may be accepted.
          _assetSoundFiles[s] = file.path;
        } catch (_) {
          // ignore missing asset
        }
      }
    } catch (_) {}
  }

  String? _assetFileNameFor(PrayerNotificationSound s) {
    switch (s) {
      case PrayerNotificationSound.softBell:
        return '0.4_second_soft_8-bi-#2-1757184395518.wav';
      case PrayerNotificationSound.softBellAlt:
        return '0.4_second_soft_8-bi-#3-1757184395483.wav';
      case PrayerNotificationSound.shortAdhan:
        return '1_second_warm_8-bit_-1757184359004.wav';
      case PrayerNotificationSound.natureBell:
        return '0.5_second_cheerful_-#2-1757184376408.wav';
      case PrayerNotificationSound.gentleChime:
        return '0.6_second_airy_8-bi-#3-1757184382045.wav';
      case PrayerNotificationSound.qanun:
        return '0.5_second_qanun_str-#2-1757184432228.wav';
      case PrayerNotificationSound.single8:
        return '0.5_second_single_8--#3-1757184394621.wav';
      case PrayerNotificationSound.twoNoteA:
        return '0.7_second_two-note_-#1-1757184381080.wav';
      case PrayerNotificationSound.twoNoteB:
        return '0.7_second_two-note_-#2-1757184380970.wav';
      case PrayerNotificationSound.softMix:
        return '1_second_soft_mix_of-#3-1757184417575.wav';
      case PrayerNotificationSound.warm8bitAlt:
        return '1_second_warm_8-bit_-#2-1757184359010.wav';
      case PrayerNotificationSound.clearSound:
        return '4_second_clear_sound-#3-1757184424196.wav';
      default:
        return null;
    }
  }

  DarwinNotificationDetails _iosDetails() {
    final file = selectedSound.iosFileName;
    return DarwinNotificationDetails(
      sound: file,
      presentSound: true,
      presentAlert: true,
    );
  }

  void setSound(PrayerNotificationSound sound) {
    selectedSound = sound;
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  bool get _pluginInitializedSafely =>
      _initialized; // future hook if platform-specific disable needed

  static bool _initializedTz = false;
  Future<void> _ensureTimezone() async {
    if (_initializedTz) return;
    tzdata.initializeTimeZones();
    try {
      // Attempt to derive local timezone; fallback to UTC if not found.
      final localName =
          DateTime.now().timeZoneName; // e.g. "GMT+3" or abbreviation
      // Simple heuristic: if tz has location, set; else default to UTC.
      if (tz.timeZoneDatabase.locations.containsKey(localName)) {
        tz.setLocalLocation(tz.getLocation(localName));
      } else {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    _initializedTz = true;
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
