import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart' show rootBundle;
import '../../../prayer_times/presentation/controllers/prayer_times_controller.dart';
import '../../../prayer_times/data/services/notification_service.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../../gen_l10n/app_localizations.dart';

// Top-level helpers used by modal sheets/state classes (file-private)
IconData soundIconFor(PrayerNotificationSound sound) {
  switch (sound) {
    case PrayerNotificationSound.system:
      return Icons.volume_up;
    case PrayerNotificationSound.softBell:
      return Icons.notifications_outlined;
    case PrayerNotificationSound.shortAdhan:
      return Icons.mosque;
    case PrayerNotificationSound.natureBell:
      return Icons.nature;
    case PrayerNotificationSound.gentleChime:
      return Icons.music_note;
    case PrayerNotificationSound.softBellAlt:
      return Icons.notifications_none;
    case PrayerNotificationSound.qanun:
      return Icons.audiotrack;
    case PrayerNotificationSound.single8:
      return Icons.memory;
    case PrayerNotificationSound.twoNoteA:
    case PrayerNotificationSound.twoNoteB:
      return Icons.queue_music;
    case PrayerNotificationSound.softMix:
      return Icons.layers;
    case PrayerNotificationSound.warm8bitAlt:
      return Icons.bubble_chart;
    case PrayerNotificationSound.clearSound:
      return Icons.surround_sound;
    case PrayerNotificationSound.systemAlarm:
      return Icons.alarm;
    case PrayerNotificationSound.systemNotification:
      return Icons.notifications;
    case PrayerNotificationSound.systemRingtone:
      return Icons.ring_volume;
  }
}

// Mapping to local asset paths for preview (mirrors filenames in NotificationService)
const Map<PrayerNotificationSound, String> _soundAssetFile = {
  PrayerNotificationSound.softBell:
      'assets/sounds/0.4_second_soft_8-bi-#2-1757184395518.wav',
  PrayerNotificationSound.softBellAlt:
      'assets/sounds/0.4_second_soft_8-bi-#3-1757184395483.wav',
  PrayerNotificationSound.shortAdhan:
      'assets/sounds/1_second_warm_8-bit_-1757184359004.wav',
  PrayerNotificationSound.natureBell:
      'assets/sounds/0.5_second_cheerful_-#2-1757184376408.wav',
  PrayerNotificationSound.gentleChime:
      'assets/sounds/0.6_second_airy_8-bi-#3-1757184382045.wav',
  PrayerNotificationSound.qanun:
      'assets/sounds/0.5_second_qanun_str-#2-1757184432228.wav',
  PrayerNotificationSound.single8:
      'assets/sounds/0.5_second_single_8--#3-1757184394621.wav',
  PrayerNotificationSound.twoNoteA:
      'assets/sounds/0.7_second_two-note_-#1-1757184381080.wav',
  PrayerNotificationSound.twoNoteB:
      'assets/sounds/0.7_second_two-note_-#2-1757184380970.wav',
  PrayerNotificationSound.softMix:
      'assets/sounds/1_second_soft_mix_of-#3-1757184417575.wav',
  PrayerNotificationSound.warm8bitAlt:
      'assets/sounds/1_second_warm_8-bit_-#2-1757184359010.wav',
  PrayerNotificationSound.clearSound:
      'assets/sounds/4_second_clear_sound-#3-1757184424196.wav',
};

// Helper to exclude OS/system sounds from UI lists
bool _isSystemSound(PrayerNotificationSound s) {
  return s == PrayerNotificationSound.system ||
      s == PrayerNotificationSound.systemAlarm ||
      s == PrayerNotificationSound.systemNotification ||
      s == PrayerNotificationSound.systemRingtone;
}

/// Play a short preview of an asset sound (copies to temp and plays)
Future<void> _playAssetPreview(String assetPath) async {
  try {
    final bytes = await rootBundle.load(assetPath);
    final tmp = await io.Directory.systemTemp.createTemp('prayly_preview_');
    final file = io.File('${tmp.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    final player = AudioPlayer();
    await player.play(DeviceFileSource(file.path), volume: 1.0);
    // play briefly then stop
    await Future.delayed(const Duration(seconds: 2));
    await player.stop();
    await player.dispose();
  } catch (_) {
    // ignore preview failures
  }
}

class _SoundPickerSheet extends StatefulWidget {
  final PrayerTimesController controller;
  final ScrollController scrollController;

  const _SoundPickerSheet({
    required this.controller,
    required this.scrollController,
  });

  @override
  State<_SoundPickerSheet> createState() => _SoundPickerSheetState();
}

/// Top-level page that hosts notification settings. Provided the
/// PrayerTimesController via Provider in the navigation caller.
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PixelAppBar(title: l10n.screenTitleNotificationSettings),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            _buildGeneralSettings(context, controller),
            const SizedBox(height: 10),
            _buildSoundSettings(context, controller),
            const SizedBox(height: 10),
            _buildPerPrayerSettings(context, controller),
            const SizedBox(height: 10),
            _buildSpecialModes(context, controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SoundPickerSheetState extends State<_SoundPickerSheet> {
  final Map<PrayerNotificationSound, AudioPlayer> _players = {};
  PrayerNotificationSound? _playing;

  @override
  void dispose() {
    for (final p in _players.values) {
      try {
        p.stop();
        p.dispose();
      } catch (_) {}
    }
    _players.clear();
    super.dispose();
  }

  Future<void> _playPreview(PrayerNotificationSound sound) async {
    // stop currently playing other sound
    if (_playing != null && _playing != sound) {
      await _stopPreview(_playing!);
    }

    final asset = _soundAssetFile[sound];
    if (asset == null) return; // system sounds have no asset

    try {
      final bytes = await rootBundle.load(asset);
      final tmp = await io.Directory.systemTemp.createTemp('prayly_preview_');
      final file = io.File('${tmp.path}/${asset.split('/').last}');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      final player = AudioPlayer();
      _players[sound] = player;
      if (mounted) setState(() => _playing = sound);

      await player.play(DeviceFileSource(file.path), volume: 1.0);

      // ensure we clear state when playback completes
      player.onPlayerComplete.listen((_) async {
        await _stopPreview(sound);
      });
    } catch (_) {
      // ignore preview errors
    }
  }

  Future<void> _stopPreview(PrayerNotificationSound sound) async {
    final player = _players[sound];
    if (player == null) return;
    try {
      await player.stop();
      await player.dispose();
    } catch (_) {}
    _players.remove(sound);
    if (mounted) {
      setState(() {
        if (_playing == sound) _playing = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: PrayerNotificationSound.values
          .where((s) => !_isSystemSound(s))
          .map((sound) {
            final selected = widget.controller.currentSound == sound;
            final isPlaying = _playing == sound;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: PixelBox(
                padding: const EdgeInsets.all(12),
                color: selected
                    ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.3)
                    : Theme.of(context).colorScheme.surface.withOpacity(0.4),
                borderColor: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                child: Row(
                  children: <Widget>[
                    PixelBox(
                      padding: const EdgeInsets.all(6),
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderColor: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      child: Icon(
                        soundIconFor(sound),
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PixelLabel(sound.displayName(context), fontSize: 11),
                          const SizedBox(height: 2),
                          PixelLabel(soundDescriptionFor(context, sound)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await _stopPreview(sound);
                        } else {
                          await _playPreview(sound);
                        }
                      },
                      icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: TextButton(
                        onPressed: () async {
                          if (_playing != null) await _stopPreview(_playing!);
                          widget.controller.changeSound(sound);
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                        ),
                        child: PixelLabel(
                          AppLocalizations.of(context)!.dialogSelect,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    if (selected) const SizedBox(width: 6),
                    if (selected)
                      PixelBox(
                        padding: const EdgeInsets.all(6),
                        color: Theme.of(context).colorScheme.primary,
                        borderColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          })
          .toList(),
    );
  }
}

String soundDescriptionFor(
  BuildContext context,
  PrayerNotificationSound sound,
) {
  final l10n = AppLocalizations.of(context)!;
  switch (sound) {
    case PrayerNotificationSound.system:
      return l10n.soundDesc_system;
    case PrayerNotificationSound.softBell:
      return l10n.soundDesc_softBell;
    case PrayerNotificationSound.softBellAlt:
      return l10n.soundDesc_softBellAlt;
    case PrayerNotificationSound.shortAdhan:
      return l10n.soundDesc_shortAdhan;
    case PrayerNotificationSound.natureBell:
      return l10n.soundDesc_natureBell;
    case PrayerNotificationSound.gentleChime:
      return l10n.soundDesc_gentleChime;
    case PrayerNotificationSound.qanun:
      return l10n.soundDesc_qanun;
    case PrayerNotificationSound.single8:
      return l10n.soundDesc_single8;
    case PrayerNotificationSound.twoNoteA:
      return l10n.soundDesc_twoNoteA;
    case PrayerNotificationSound.twoNoteB:
      return l10n.soundDesc_twoNoteB;
    case PrayerNotificationSound.softMix:
      return l10n.soundDesc_softMix;
    case PrayerNotificationSound.warm8bitAlt:
      return l10n.soundDesc_warm8bitAlt;
    case PrayerNotificationSound.clearSound:
      return l10n.soundDesc_clearSound;
    case PrayerNotificationSound.systemAlarm:
      return l10n.soundDesc_systemAlarm;
    case PrayerNotificationSound.systemNotification:
      return l10n.soundDesc_systemNotification;
    case PrayerNotificationSound.systemRingtone:
      return l10n.soundDesc_systemRingtone;
  }
}

Widget _buildGeneralSettings(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final l10n = AppLocalizations.of(context)!;

  return PixelPanel(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            PixelLabel(
              l10n.notificationGeneralSettings,
              fontSize: 12,
              color: isLight ? Colors.white : null,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Vaktinde bildirim
        _buildSwitchTile(
          context,
          title: l10n.notificationOnTime,
          subtitle: l10n.notificationOnTimeSubtitle,
          icon: Icons.schedule,
          value: controller.notifyOnTime,
          onChanged: (value) =>
              controller.updateNotificationSettings(onTime: value),
        ),

        const SizedBox(height: 10),

        // Vakit öncesi bildirim
        _buildSwitchTile(
          context,
          title: l10n.notificationPreTime,
          subtitle: l10n.notificationPreTimeSubtitle,
          icon: Icons.timer,
          value: controller.notifyPre,
          onChanged: (value) =>
              controller.updateNotificationSettings(pre: value),
        ),

        // Vakit öncesi dakika seçimi
        if (controller.notifyPre) ...[
          const SizedBox(height: 10),
          _buildPreMinutesSelector(context, controller),
        ],
      ],
    ),
  );
}

Widget _buildPreMinutesSelector(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final l10n = AppLocalizations.of(context)!;
  return PixelBox(
    padding: const EdgeInsets.all(12),
    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
    borderColor: Theme.of(context).colorScheme.outline,
    child: Row(
      children: [
        Icon(
          Icons.access_time,
          color: Theme.of(context).colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        PixelLabel(
          l10n.notificationPreMinutesLabel,
          fontSize: 10,
          color: isLight ? Colors.white : null,
        ),
        const Spacer(),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 64, maxWidth: 140),
          child: DropdownButton<int>(
            value: controller.notifyPreMinutes,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: 5,
                child: PixelLabel(l10n.minutesShort(5), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 10,
                child: PixelLabel(l10n.minutesShort(10), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 15,
                child: PixelLabel(l10n.minutesShort(15), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 20,
                child: PixelLabel(l10n.minutesShort(20), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 30,
                child: PixelLabel(l10n.minutesShort(30), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 45,
                child: PixelLabel(l10n.minutesShort(45), fontSize: 10),
              ),
              DropdownMenuItem(
                value: 60,
                child: PixelLabel(l10n.minutesShort(60), fontSize: 10),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                controller.updateNotificationSettings(preMinutes: value);
              }
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildSoundSettings(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final l10n = AppLocalizations.of(context)!;
  return PixelPanel(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.volume_up,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            PixelLabel(
              l10n.notificationSoundLabel,
              fontSize: 12,
              color: isLight ? Colors.white : null,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Ses seçici
        _buildSoundSelector(context, controller),

        const SizedBox(height: 10),

        // Ses açıklaması
        PixelBox(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
          borderColor: Theme.of(context).colorScheme.primary,
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PixelLabel(
                  l10n.notificationDefaultSound,
                  fontSize: 9,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSoundSelector(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  return InkWell(
    onTap: () => _showSoundPicker(context, controller),
    child: PixelBox(
      padding: const EdgeInsets.all(12),
      borderColor: Theme.of(context).colorScheme.outline,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      child: Row(
        children: [
          Icon(
            soundIconFor(controller.currentSound),
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PixelLabel(
                  controller.currentSound.displayName(context),
                  fontSize: 11,
                  color: isLight ? Colors.white : null,
                ),
                const SizedBox(height: 2),
                PixelLabel(
                  soundDescriptionFor(context, controller.currentSound),
                  fontSize: 9,
                  color: isLight
                      ? Colors.white70
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    ),
  );
}

Widget _buildPerPrayerSettings(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final l10n = AppLocalizations.of(context)!;
  return PixelPanel(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            PixelLabel(
              l10n.notificationPerPrayerTitle,
              fontSize: 12,
              color: isLight ? Colors.white : null,
            ),
          ],
        ),
        const SizedBox(height: 6),
        PixelLabel(
          l10n.notificationPerPrayerSubtitle,
          fontSize: 9,
          color: isLight
              ? Colors.white70
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 10),

        // Per-prayer list (use localized prayer names)
        ...[
          l10n.prayerMorning,
          l10n.prayerDhuhr,
          l10n.prayerAsr,
          l10n.prayerMaghrib,
          l10n.prayerIsha,
        ].map(
          (prayerName) => _buildPerPrayerTile(context, controller, prayerName),
        ),
      ],
    ),
  );
}

Widget _buildPerPrayerTile(
  BuildContext context,
  PrayerTimesController controller,
  String prayerName,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final override = controller.perPrayerNotif[prayerName];
  final hasOverride =
      override != null &&
      (override['onTime'] != null ||
          override['pre'] != null ||
          override['preMinutes'] != null ||
          override['sound'] != null ||
          override['soundOnTime'] != null ||
          override['soundPre'] != null);

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () => _showPerPrayerSettings(context, controller, prayerName),
      child: PixelBox(
        padding: const EdgeInsets.all(12),
        color: hasOverride
            ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
            : Theme.of(context).colorScheme.surface.withOpacity(0.4),
        borderColor: hasOverride
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        child: Row(
          children: [
            Icon(
              Icons.mosque,
              color: hasOverride
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PixelLabel(
                    prayerName,
                    fontSize: 11,
                    color: isLight ? Colors.white : null,
                  ),
                  const SizedBox(height: 2),
                  PixelLabel(
                    hasOverride
                        ? AppLocalizations.of(
                            context,
                          )!.notificationCustomizedSettings
                        : AppLocalizations.of(
                            context,
                          )!.notificationUsingGlobalSettings,
                    fontSize: 9,
                    color: isLight
                        ? Colors.white70
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            if (hasOverride)
              PixelBox(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Theme.of(context).colorScheme.primary,
                borderColor: Theme.of(context).colorScheme.primary,
                child: PixelLabel(
                  AppLocalizations.of(context)!.notificationBadgeCustom,
                  fontSize: 9,
                  color: Colors.white,
                ),
              ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSpecialModes(
  BuildContext context,
  PrayerTimesController controller,
) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  final l10n = AppLocalizations.of(context)!;
  return PixelPanel(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.do_not_disturb,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            PixelLabel(
              l10n.notificationSpecialModes,
              fontSize: 12,
              color: isLight ? Colors.white : null,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Kadın özel modu
        _buildSwitchTile(
          context,
          title: l10n.notificationWomenModeTitle,
          subtitle: l10n.notificationMuteAllSubtitle,
          icon: Icons.pause_circle_outline,
          value: controller.notificationsPaused,
          onChanged: (_) => controller.togglePauseNotifications(),
        ),

        const SizedBox(height: 10),

        // Namazdayım modu
        _buildSwitchTile(
          context,
          title: l10n.notificationInPrayerMode,
          subtitle: l10n.notificationInPrayerModeSubtitle,
          icon: Icons.self_improvement,
          value: controller.inPrayerMode,
          onChanged: (value) => controller.toggleInPrayerMode(),
        ),

        // Açıklama
        if (controller.notificationsPaused || controller.inPrayerMode) ...[
          const SizedBox(height: 10),
          PixelBox(
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
            borderColor: Theme.of(context).colorScheme.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.notificationsPaused)
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PixelLabel(
                          l10n.notificationWomenModeInfo,
                          fontSize: 9,
                          color: isLight ? Colors.white70 : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                if (controller.inPrayerMode) ...[
                  if (controller.notificationsPaused) const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PixelLabel(
                          l10n.notificationInPrayerDelay(
                            controller.inPrayerDelayMinutes,
                          ),
                          fontSize: 9,
                          color: isLight
                              ? Colors.white70
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildSwitchTile(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
  return InkWell(
    onTap: () => onChanged(!value),
    child: PixelBox(
      padding: const EdgeInsets.all(12),
      color: value
          ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
          : Theme.of(context).colorScheme.surface.withOpacity(0.4),
      borderColor: value
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.outline,
      child: Row(
        children: [
          Icon(
            icon,
            color: value
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PixelLabel(
                  title,
                  fontSize: 11,
                  color: isLight ? Colors.white : null,
                ),
                const SizedBox(height: 2),
                PixelLabel(
                  subtitle,
                  fontSize: 9,
                  color: isLight
                      ? Colors.white70
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    ),
  );
}

// soundIconFor() and soundDescriptionFor() are defined at file top and used throughout.

void _showSoundPicker(BuildContext context, PrayerTimesController controller) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 1.0,
      expand: true,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (pixel style)
            Row(
              children: [
                PixelBox(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.volume_up,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PixelLabel(l10n.notificationSoundPicker, fontSize: 14),
                      const SizedBox(height: 6),
                      PixelLabel(l10n.notificationSoundNote, fontSize: 9),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sound list (pixelized)
            Expanded(
              child: ListView(
                controller: scrollController,
                children: PrayerNotificationSound.values
                    .where((s) => !_isSystemSound(s))
                    .map((sound) {
                      final selected = controller.currentSound == sound;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () async {
                            final asset = _soundAssetFile[sound];
                            if (asset != null) await _playAssetPreview(asset);
                            controller.changeSound(sound);
                            Navigator.pop(context);
                          },
                          child: PixelBox(
                            padding: const EdgeInsets.all(12),
                            color: selected
                                ? Theme.of(context).colorScheme.primaryContainer
                                      .withOpacity(0.3)
                                : Theme.of(
                                    context,
                                  ).colorScheme.surface.withOpacity(0.4),
                            borderColor: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.2),
                            child: Row(
                              children: [
                                PixelBox(
                                  padding: const EdgeInsets.all(6),
                                  color: selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                  borderColor: selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                  child: Icon(
                                    soundIconFor(sound),
                                    color: selected
                                        ? Colors.white
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PixelLabel(sound.label, fontSize: 11),
                                      const SizedBox(height: 2),
                                      PixelLabel(
                                        soundDescriptionFor(context, sound),
                                        fontSize: 9,
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  PixelBox(
                                    padding: const EdgeInsets.all(6),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showPerPrayerSettings(
  BuildContext context,
  PrayerTimesController controller,
  String prayerName,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        _PerPrayerSettingsSheet(controller: controller, prayerName: prayerName),
  );
}

class _PerPrayerSettingsSheet extends StatefulWidget {
  final PrayerTimesController controller;
  final String prayerName;

  const _PerPrayerSettingsSheet({
    required this.controller,
    required this.prayerName,
  });

  @override
  State<_PerPrayerSettingsSheet> createState() =>
      _PerPrayerSettingsSheetState();
}

class _PerPrayerSettingsSheetState extends State<_PerPrayerSettingsSheet> {
  Future<int?> _showCustomPreMinutesDialog(
    BuildContext context,
    int initial,
  ) async {
    final controller = TextEditingController(text: initial.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(ctx)!.notificationPreTime),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Minutes'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx)!.dialogCancel),
            ),
            ElevatedButton(
              onPressed: () {
                final v = int.tryParse(controller.text.trim());
                if (v == null || v < 0 || v > 180) {
                  Navigator.pop(ctx);
                } else {
                  Navigator.pop(ctx, v);
                }
              },
              child: Text(AppLocalizations.of(ctx)!.dialogOk),
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final override = widget.controller.perPrayerNotif[widget.prayerName];
    final onTime = override?['onTime'] as bool?;
    final pre = override?['pre'] as bool?;
    final soundOnTimeId =
        (override?['soundOnTime'] as String?) ??
        (override?['sound'] as String?);
    final soundPreId =
        (override?['soundPre'] as String?) ?? (override?['sound'] as String?);
    final currentSoundOnTime = soundOnTimeId != null
        ? PrayerNotificationSound.values.firstWhere(
            (e) => e.id == soundOnTimeId,
            orElse: () => widget.controller.currentSound,
          )
        : null;
    final currentSoundPre = soundPreId != null
        ? PrayerNotificationSound.values.firstWhere(
            (e) => e.id == soundPreId,
            orElse: () => widget.controller.currentSound,
          )
        : null;

    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 1.0,
      expand: true,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.mosque,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PixelLabel(
                        '${widget.prayerName} ${l10n.prayerLabelSuffix}',
                        fontSize: 12,
                      ),
                      const SizedBox(height: 2),
                      PixelLabel(
                        l10n.notificationPerPrayerDetail,
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  // Reset button
                  if (override != null) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await widget.controller.clearPerPrayerOverrides(
                            widget.prayerName,
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.notificationReturnToGlobal),
                      ),
                    ),
                  ],

                  // On time notification
                  _buildOverrideTile(
                    context,
                    title: l10n.notificationOnTime,
                    subtitle: onTime == null
                        ? '${l10n.notificationGlobal}: ${widget.controller.notifyOnTime ? l10n.dialogYes : l10n.dialogNo}'
                        : onTime
                        ? l10n.dialogYes
                        : l10n.dialogNo,
                    icon: Icons.schedule,
                    value: onTime,
                    globalValue: widget.controller.notifyOnTime,
                    onChanged: (value) {
                      widget.controller.updatePerPrayerNotification(
                        widget.prayerName,
                        onTime: value,
                      );
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 16),

                  // Pre notification
                  _buildOverrideTile(
                    context,
                    title: l10n.notificationPreTime,
                    subtitle: pre == null
                        ? '${l10n.notificationGlobal}: ${widget.controller.notifyPre ? l10n.dialogYes : l10n.dialogNo}'
                        : pre
                        ? l10n.dialogYes
                        : l10n.dialogNo,
                    icon: Icons.timer,
                    value: pre,
                    globalValue: widget.controller.notifyPre,
                    onChanged: (value) {
                      widget.controller.updatePerPrayerNotification(
                        widget.prayerName,
                        pre: value,
                      );
                      setState(() {});
                    },
                  ),

                  // Pre minutes
                  if (pre == true ||
                      (pre == null && widget.controller.notifyPre)) ...[
                    const SizedBox(height: 16),
                    _buildPreMinutesOverride(context),
                  ],

                  const SizedBox(height: 16),

                  // Sounds (on-time & pre-time)
                  _buildSoundOverrideOnTime(context, currentSoundOnTime),
                  const SizedBox(height: 10),
                  _buildSoundOverridePre(context, currentSoundPre),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverrideTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool? value,
    required bool globalValue,
    required ValueChanged<bool?> onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return PixelBox(
      padding: const EdgeInsets.all(8),
      borderColor: Theme.of(context).colorScheme.outline,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                PixelBox(
                  padding: const EdgeInsets.all(6),
                  color: value != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderColor: value != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  child: Icon(
                    icon,
                    size: 16,
                    color: value != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PixelLabel(title, fontSize: 11),
                      const SizedBox(height: 2),
                      PixelLabel(subtitle, fontSize: 9),
                    ],
                  ),
                ),
                if (value != null)
                  IconButton(
                    onPressed: () => onChanged(null),
                    icon: const Icon(Icons.close),
                    tooltip: l10n.notificationUseGlobalSoundTooltip,
                  ),
              ],
            ),
          ),
          if (value == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () => onChanged(globalValue),
                child: Text(l10n.notificationCustomizeButton),
              ),
            )
          else
            Row(
              children: [
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => onChanged(false),
                    child: PixelLabel(
                      l10n.notificationToggleOff,
                      fontSize: 11,
                      textAlign: TextAlign.center,
                      color: value == false
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => onChanged(true),
                    child: PixelLabel(
                      l10n.notificationToggleOn,
                      fontSize: 11,
                      textAlign: TextAlign.center,
                      color: value == true
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPreMinutesOverride(BuildContext context) {
    final isLight =
        Theme.of(context).colorScheme.brightness == Brightness.light;
    final l10n = AppLocalizations.of(context)!;
    final override = widget.controller.perPrayerNotif[widget.prayerName];
    final preMinutes = override?['preMinutes'] as int?;

    return PixelBox(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      borderColor: Theme.of(context).colorScheme.outline,
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          PixelLabel(
            preMinutes == null
                ? l10n.notificationPreTimeGlobal
                : l10n.notificationPreTime,
            fontSize: 10,
            color: isLight ? Colors.white : null,
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 64, maxWidth: 140),
            child: DropdownButton<int?>(
              value: preMinutes,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: PixelLabel(
                    l10n.notificationPreTimeGlobal,
                    fontSize: 10,
                  ),
                ),
                DropdownMenuItem(
                  value: 5,
                  child: PixelLabel(l10n.minutesShort(5), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 10,
                  child: PixelLabel(l10n.minutesShort(10), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 15,
                  child: PixelLabel(l10n.minutesShort(15), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: PixelLabel(l10n.minutesShort(20), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 30,
                  child: PixelLabel(l10n.minutesShort(30), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 45,
                  child: PixelLabel(l10n.minutesShort(45), fontSize: 10),
                ),
                DropdownMenuItem(
                  value: 60,
                  child: PixelLabel(l10n.minutesShort(60), fontSize: 10),
                ),
              ],
              onChanged: (value) {
                widget.controller.updatePerPrayerNotification(
                  widget.prayerName,
                  preMinutes: value,
                );
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: l10n.notificationCustomizeButton,
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final custom = await _showCustomPreMinutesDialog(
                context,
                preMinutes ?? widget.controller.notifyPreMinutes,
              );
              if (custom != null) {
                widget.controller.updatePerPrayerNotification(
                  widget.prayerName,
                  preMinutes: custom,
                );
                if (mounted) setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoundOverrideOnTime(
    BuildContext context,
    PrayerNotificationSound? currentSound,
  ) {
    final isLight =
        Theme.of(context).colorScheme.brightness == Brightness.light;
    final l10n = AppLocalizations.of(context)!;
    return PixelBox(
      padding: const EdgeInsets.all(8),
      borderColor: Theme.of(context).colorScheme.outline,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showSoundPicker(context, currentSound, forPre: false),
            child: Row(
              children: [
                PixelBox(
                  padding: const EdgeInsets.all(6),
                  color: currentSound != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderColor: currentSound != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  child: Icon(
                    Icons.volume_up,
                    size: 16,
                    color: currentSound != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PixelLabel(
                        '${l10n.notificationOnTime} - ${l10n.notificationSoundLabel}',
                        fontSize: 11,
                        color: isLight ? Colors.white : null,
                      ),
                      const SizedBox(height: 2),
                      PixelLabel(
                        currentSound != null
                            ? currentSound.displayName(context)
                            : '${l10n.notificationSoundGlobalPrefix}: ${widget.controller.currentSound.displayName(context)}',
                        fontSize: 9,
                        color: isLight ? Colors.white70 : null,
                      ),
                    ],
                  ),
                ),
                if (currentSound != null)
                  IconButton(
                    onPressed: () async {
                      await widget.controller.clearPerPrayerSoundOnTime(
                        widget.prayerName,
                      );
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.close),
                    tooltip: l10n.notificationUseGlobalSoundTooltip,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundOverridePre(
    BuildContext context,
    PrayerNotificationSound? currentSound,
  ) {
    final isLight =
        Theme.of(context).colorScheme.brightness == Brightness.light;
    final l10n = AppLocalizations.of(context)!;
    return PixelBox(
      padding: const EdgeInsets.all(8),
      borderColor: Theme.of(context).colorScheme.outline,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showSoundPicker(context, currentSound, forPre: true),
            child: Row(
              children: [
                PixelBox(
                  padding: const EdgeInsets.all(6),
                  color: currentSound != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderColor: currentSound != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  child: Icon(
                    Icons.notifications_active,
                    size: 16,
                    color: currentSound != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PixelLabel(
                        '${l10n.notificationPreTime} - ${l10n.notificationSoundLabel}',
                        fontSize: 11,
                        color: isLight ? Colors.white : null,
                      ),
                      const SizedBox(height: 2),
                      PixelLabel(
                        currentSound != null
                            ? currentSound.displayName(context)
                            : '${l10n.notificationSoundGlobalPrefix}: ${widget.controller.currentSound.displayName(context)}',
                        fontSize: 9,
                        color: isLight ? Colors.white70 : null,
                      ),
                    ],
                  ),
                ),
                if (currentSound != null)
                  IconButton(
                    onPressed: () async {
                      await widget.controller.clearPerPrayerSoundPre(
                        widget.prayerName,
                      );
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.close),
                    tooltip: l10n.notificationUseGlobalSoundTooltip,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSoundPicker(
    BuildContext context,
    PrayerNotificationSound? currentSound, {
    required bool forPre,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PixelLabel(
                '${widget.prayerName} - ${forPre ? l10n.notificationPreTime : l10n.notificationOnTime} - ${l10n.notificationSoundLabel}',
                fontSize: 12,
              ),
              const SizedBox(height: 10),

              // Global option (pixel)
              InkWell(
                onTap: () async {
                  if (forPre) {
                    await widget.controller.clearPerPrayerSoundPre(
                      widget.prayerName,
                    );
                  } else {
                    await widget.controller.clearPerPrayerSoundOnTime(
                      widget.prayerName,
                    );
                  }
                  if (mounted) setState(() {});
                  if (context.mounted) Navigator.pop(context);
                },
                child: PixelBox(
                  padding: const EdgeInsets.all(12),
                  borderColor: Theme.of(context).colorScheme.outline,
                  color: currentSound == null
                      ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withOpacity(0.3)
                      : Theme.of(context).colorScheme.surface.withOpacity(0.4),
                  child: Row(
                    children: [
                      PixelBox(
                        padding: const EdgeInsets.all(6),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderColor: Theme.of(context).colorScheme.outline,
                        child: const Icon(Icons.settings, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PixelLabel(
                              l10n.notificationUseGlobalSoundTooltip,
                              fontSize: 11,
                            ),
                            const SizedBox(height: 2),
                            PixelLabel(
                              '${l10n.notificationSoundGlobalPrefix}: ${widget.controller.currentSound.label}',
                              fontSize: 9,
                            ),
                          ],
                        ),
                      ),
                      if (currentSound == null)
                        PixelBox(
                          padding: const EdgeInsets.all(6),
                          color: Theme.of(context).colorScheme.primary,
                          borderColor: Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Per-prayer list (pixelized)
              ...PrayerNotificationSound.values
                  .where((s) => !_isSystemSound(s))
                  .map((sound) {
                    final selected = currentSound == sound;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () async {
                          final asset = _soundAssetFile[sound];
                          if (asset != null) await _playAssetPreview(asset);
                          if (forPre) {
                            widget.controller.updatePerPrayerNotification(
                              widget.prayerName,
                              soundPre: sound.id,
                            );
                          } else {
                            widget.controller.updatePerPrayerNotification(
                              widget.prayerName,
                              soundOnTime: sound.id,
                            );
                          }
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: PixelBox(
                          padding: const EdgeInsets.all(12),
                          color: selected
                              ? Theme.of(
                                  context,
                                ).colorScheme.primaryContainer.withOpacity(0.3)
                              : Theme.of(
                                  context,
                                ).colorScheme.surface.withOpacity(0.4),
                          borderColor: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.2),
                          child: Row(
                            children: [
                              PixelBox(
                                padding: const EdgeInsets.all(6),
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                borderColor: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                                child: Icon(
                                  soundIconFor(sound),
                                  size: 18,
                                  color: selected
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PixelLabel(
                                      sound.displayName(context),
                                      fontSize: 11,
                                    ),
                                    const SizedBox(height: 2),
                                    PixelLabel(
                                      soundDescriptionFor(context, sound),
                                      fontSize: 9,
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                PixelBox(
                                  padding: const EdgeInsets.all(6),
                                  color: Theme.of(context).colorScheme.primary,
                                  borderColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  // helpers are declared at file top: soundIconFor/soundDescriptionFor
}
