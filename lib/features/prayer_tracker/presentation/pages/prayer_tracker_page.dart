import 'package:flutter/material.dart';
import '../../data/prayer_tracker_storage.dart';
import '../../domain/special_prayer_calendar.dart';
import 'prayer_statistics_page.dart';
import '../widgets/prayer_status_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../../gamification/data/repositories/local_gamification_repository.dart';
import '../../../gamification/data/services/prayer_event_adapter.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/widgets/gamification_animations.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../gen_l10n/app_localizations.dart';

// Map internal/stored prayer identifiers or legacy localized names to the
// short, localized prayer name for display. This avoids showing mixed
// translations like "Sabah Prayer" when the UI locale is English.
String _localizedPrayerShortName(AppLocalizations l10n, String name) {
  final key = name.toLowerCase();
  switch (key) {
    // Turkish canonical names
    case 'sabah':
      return l10n.prayerMorning;
    case 'öğle':
    case 'oğle':
    case 'ogle':
      return l10n.prayerDhuhr;
    case 'ikindi':
      return l10n.prayerAsr;
    case 'akşam':
    case 'aksam':
      return l10n.prayerMaghrib;
    case 'yatsı':
    case 'yatsi':
      return l10n.prayerIsha;

    // Turkish/Arabic terms that might appear
    case 'imsak':
    case 'ımsak':
      return l10n.prayerFajr;

    // English/standard identifiers
    case 'fajr':
      return l10n.prayerFajr;
    case 'dawn':
      return l10n.prayerMorning;
    case 'sunrise':
      return l10n.prayerSunrise;
    case 'dhuhr':
    case 'zuhr':
      return l10n.prayerDhuhr;
    case 'asr':
      return l10n.prayerAsr;
    case 'maghrib':
      return l10n.prayerMaghrib;
    case 'isha':
      return l10n.prayerIsha;

    default:
      // Unknown/extra prayer names: return as-is so special prayers remain visible.
      return name;
  }
}

class PrayerTrackerPage extends StatefulWidget {
  const PrayerTrackerPage({super.key});
  @override
  State<PrayerTrackerPage> createState() => _PrayerTrackerPageState();
}

class _PrayerTrackerPageState extends State<PrayerTrackerPage>
    with TickerProviderStateMixin {
  final storage = PrayerTrackerStorage();
  final gamificationRepo = LocalGamificationRepository();
  Map<String, PrayerRecord> records = {};
  DateTime? day;
  bool loading = true;
  DateTime selectedDate = DateTime.now();
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  Future<void> _persistTrackerWidget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prayers = _computePrayersForDate(selectedDate);
      final completed = records.values
          .where(
            (e) =>
                e.status == PrayerStatus.kilindi ||
                e.status == PrayerStatus.cemaat,
          )
          .length;
      await prefs.setInt('widget_tracker_completed', completed);
      await prefs.setInt('widget_tracker_total', prayers.length);
      await prefs.setString('widget_tracker_first', prayers.first);
      await prefs.setString(
        'widget_tracker_first_status',
        (records[prayers.first]?.status ?? PrayerStatus.none).code,
      );
      for (final p in prayers) {
        await prefs.setString(
          'tracker_status_$p',
          (records[p]?.status ?? PrayerStatus.none).code,
        );
      }
      const ch = MethodChannel('home_widgets');
      await ch.invokeMethod('refreshPrayerTracker');
    } catch (_) {}
  }

  Future<void> _sync() async {
    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (day != date) {
      final loaded = await storage.loadRecordsForDate(date);
      final profile = await gamificationRepo.getUserProfile();
      setState(() {
        day = date;
        records = loaded;
        userProfile = profile;
        loading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    // Replace platform date picker with a fully pixel-art Calendar dialog.
    DateTime temp = selectedDate;
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: PixelBox(
            padding: const EdgeInsets.all(10),
            color: scheme.surface.withValues(alpha: 0.98),
            borderColor: scheme.primary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360, maxHeight: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PixelLabel(
                        AppLocalizations.of(context)!.trackerSelectDate,
                        fontSize: 12,
                        color: scheme.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Calendar body
                  Flexible(
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      onDateChanged: (d) {
                        temp = d;
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PixelButton(
                        AppLocalizations.of(context)!.trackerCancel,
                        onPressed: () => Navigator.of(context).pop(null),
                      ),
                      const SizedBox(width: 8),
                      PixelButton(
                        AppLocalizations.of(context)!.trackerSelect,
                        onPressed: () => Navigator.of(context).pop(temp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        loading = true;
      });
      await _sync();
    }
  }

  Future<void> _showPrayerDialog(String prayerName) async {
    final currentRecord = records[prayerName];

    await showDialog(
      context: context,
      builder: (context) => PrayerStatusDialog(
        prayerName: prayerName,
        currentRecord: currentRecord,
        onRecordUpdated: (newRecord) async {
          // Keep a reference to the previous record to decide whether
          // we should call the gamification pipeline. This prevents
          // re-applying XP when the user edits and re-saves the same
          // prayer entry.
          final oldRecord = records[prayerName];

          setState(() {
            records[prayerName] = newRecord;
          });

          if (day != null) {
            await storage.saveRecordsForDate(day!, records);

            // Decide whether this change should trigger gamification.
            var shouldProcess = false;

            if (oldRecord == null) {
              // No previous record -> this is the first time; process if not 'none'.
              shouldProcess = newRecord.status != PrayerStatus.none;
            } else {
              // If the status is unchanged and location is unchanged -> skip.
              final sameStatus = oldRecord.status == newRecord.status;
              final oldLocId = oldRecord.location?.uniqueId ?? '';
              final newLocId = newRecord.location?.uniqueId ?? '';
              final sameLocation = oldLocId == newLocId;

              if (!sameStatus) {
                // Status changed. Only treat as a new award when the
                // previous status was 'none' -> avoid double-awarding on edits.
                if (oldRecord.status == PrayerStatus.none &&
                    newRecord.status != PrayerStatus.none) {
                  shouldProcess = true;
                }
              } else if (!sameLocation &&
                  newRecord.status != PrayerStatus.none) {
                // Location changed (e.g., switched to a mosque) - this may
                // warrant additional awards like mosque discovery.
                shouldProcess = true;
              }
            }

            if (shouldProcess && newRecord.status != PrayerStatus.none) {
              try {
                // If there was a previous non-none record for the same prayer/day,
                // revert its applied gamification effects first so we don't
                // double-count when applying the new record.
                if (oldRecord != null &&
                    oldRecord.status != PrayerStatus.none) {
                  try {
                    final oldEvent = PrayerEventAdapter.adaptFromRecord(
                      prayerName,
                      oldRecord,
                      day!,
                    );
                    debugPrint(
                      'Prayer Tracker: Reverting old event for $prayerName - ${oldRecord.status}',
                    );
                    await gamificationRepo.revertPrayerEvent(oldEvent);
                  } catch (e) {
                    debugPrint(
                      'Prayer Tracker: Error while reverting old event: $e',
                    );
                    // Continue - we don't want revert failure to block saving new record
                  }
                }
                debugPrint(
                  'Prayer Tracker: Gamification event oluşturuluyor - $prayerName, ${newRecord.status}',
                );
                final event = PrayerEventAdapter.adaptFromRecord(
                  prayerName,
                  newRecord,
                  day!,
                );
                debugPrint(
                  'Prayer Tracker: Event oluşturuldu - Mode: ${event.mode}, Flags: ${event.flags}',
                );

                final result = await gamificationRepo.processPrayerEvent(event);
                debugPrint(
                  'Prayer Tracker: XP kazanıldı: ${result.xpGained}, Yeni level: ${result.updatedProfile.level}',
                );

                // Profili güncelle
                final oldLevel = userProfile?.level ?? 0;
                setState(() {
                  userProfile = result.updatedProfile;
                });

                // XP kazanım animasyonu göster
                if (mounted && result.xpGained > 0) {
                  debugPrint(
                    'Prayer Tracker: XP animasyonu gösteriliyor: ${result.xpGained}',
                  );
                  _showXpGainAnimation(result.xpGained);

                  // Level atladı mı kontrol et
                  if (result.updatedProfile.level > oldLevel) {
                    debugPrint(
                      'Prayer Tracker: Level atlama animasyonu: ${result.updatedProfile.level}',
                    );
                    _showLevelUpCelebration(result.updatedProfile.level);
                  }

                  // Yeni milestone var mı kontrol et
                  if (result.newMilestones.isNotEmpty) {
                    debugPrint(
                      'Prayer Tracker: ${result.newMilestones.length} yeni milestone',
                    );
                    for (final milestone in result.newMilestones) {
                      _showMilestoneAchievement(milestone);
                    }
                  }
                }
              } catch (e) {
                // Gamification hatası - sessizce devam et
                debugPrint('Gamification error: $e');
              }
            }
          }
          _persistTrackerWidget();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    final prayers = _computePrayersForDate(selectedDate);
    final completed = records.values
        .where(
          (e) =>
              e.status == PrayerStatus.kilindi ||
              e.status == PrayerStatus.cemaat,
        )
        .length;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Tarih seçici row
        _buildDateSelector(),
        const SizedBox(height: 16),

        // Kullanıcı profil bilgisi
        if (userProfile != null) ...[
          _buildProfileCard(userProfile!),
          const SizedBox(height: 16),
        ],

        Text('$completed / ${prayers.length} tamamlandı'),
        // Persist snapshot whenever build runs (cheap) to keep widget fresh
        FutureBuilder(
          future: _persistTrackerWidget(),
          builder: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
        _StatsShortcut(
          storage: storage,
          onBeforeOpen: () async {
            if (day != null) {
              // Save both new and old format for compatibility
              await storage.saveRecordsForDate(day!, records);
              final statusMap = records.map((k, v) => MapEntry(k, v.status));
              await storage.saveForDate(day!, statusMap);
              // gamification kaldırıldı
            }
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            // Dinamik sütun sayısı (max 5, min 2) küçük ekranlarda taşmayı engeller
            int crossAxisCount = (width / 140).floor();
            if (crossAxisCount > 5) crossAxisCount = 5;
            if (crossAxisCount < 2) crossAxisCount = 2;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: prayers.length,
              itemBuilder: (context, i) {
                final p = prayers[i];
                return _PrayerStatusCard(
                  name: p,
                  record: records[p],
                  onTap: () => _showPrayerDialog(p),
                );
              },
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          AppLocalizations.of(context)!.trackerHint,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final isYesterday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day - 1;

    String dateText;
    if (isToday) {
      dateText = AppLocalizations.of(context)!.trackerToday;
    } else if (isYesterday) {
      dateText = AppLocalizations.of(context)!.trackerYesterday;
    } else {
      dateText =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    }

    return PixelBox(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: scheme.surface.withValues(alpha: 0.7),
      borderColor: scheme.primary,
      child: Row(
        children: [
          // Önceki gün butonu (pixel)
          PixelButton(
            '<',
            onPressed: () {
              if (selectedDate.isAfter(DateTime(2020, 1, 1))) {
                setState(() {
                  selectedDate = selectedDate.subtract(const Duration(days: 1));
                  loading = true;
                });
                _sync();
              }
            },
          ),

          // Tarih gösterici (tıklanabilir)
          Expanded(
            child: GestureDetector(
              onTap: _selectDate,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: scheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        PixelLabel(
                          dateText,
                          fontSize: 12,
                          color: scheme.onSurface,
                        ),
                      ],
                    ),
                    if (!isToday && !isYesterday) ...[
                      const SizedBox(height: 2),
                      PixelLabel(
                        _formatWeekday(selectedDate),
                        fontSize: 9,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Sonraki gün butonu (pixel)
          PixelButton(
            '>',
            onPressed: () {
              if (selectedDate.isBefore(now)) {
                setState(() {
                  selectedDate = selectedDate.add(const Duration(days: 1));
                  loading = true;
                });
                _sync();
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatWeekday(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final weekdays = [
      l10n.weekdayMonday,
      l10n.weekdayTuesday,
      l10n.weekdayWednesday,
      l10n.weekdayThursday,
      l10n.weekdayFriday,
      l10n.weekdaySaturday,
      l10n.weekdaySunday,
    ];
    return weekdays[date.weekday - 1];
  }

  // Günün farz 5 vakti + özel gün ekleri
  List<String> _computePrayersForDate(DateTime date) {
    const base = ['Sabah', 'Öğle', 'İkindi', 'Akşam', 'Yatsı'];
    final extras = SpecialPrayerCalendar.specialPrayersFor(date);
    // Çiftleri engelle
    return [...base, ...extras.where((e) => !base.contains(e))];
  }

  /// Kullanıcı profil bilgilerini gösteren kart
  Widget _buildProfileCard(UserProfile profile) {
    final frameColor = _getFrameColor(profile.frame);
    return PixelBox(
      padding: const EdgeInsets.all(12),
      borderColor: frameColor.withOpacity(0.8),
      child: Row(
        children: [
          // Level rozeti
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: frameColor,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.black,
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: PixelLabel(
                '${profile.level}',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Profil bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PixelLabel(profile.title, fontSize: 12, color: frameColor),
                const SizedBox(height: 2),
                PixelLabel(
                  '${profile.totalXp.toInt()} XP',
                  fontSize: 10,
                  color: Colors.white70,
                ),
                const SizedBox(height: 6),

                // Level progress bar (compact)
                PixelBox(
                  padding: const EdgeInsets.all(2),
                  color: Colors.black.withOpacity(0.2),
                  borderColor: frameColor.withOpacity(0.8),
                  child: SizedBox(
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: profile.levelProgress,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation(frameColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                PixelLabel(
                  AppLocalizations.of(context)!.profileXpToNextLevel(
                    profile.level + 1,
                    (profile.nextLevelXp - profile.totalXp).toInt(),
                  ),
                  fontSize: 9,
                  color: Colors.white60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Profil çerçevesi rengini döndür
  Color _getFrameColor(ProfileFrame frame) {
    switch (frame) {
      case ProfileFrame.basic:
        return Colors.grey;
      case ProfileFrame.bronze:
        return const Color(0xFFCD7F32);
      case ProfileFrame.silver:
        return const Color(0xFFC0C0C0);
      case ProfileFrame.gold:
        return const Color(0xFFFFD700);
      case ProfileFrame.diamond:
        return const Color(0xFFB9F2FF);
      case ProfileFrame.platinum:
        return const Color(0xFFE5E4E2);
      case ProfileFrame.divine:
        return const Color(0xFFFFB6C1);
      case ProfileFrame.cosmic:
        return const Color(0xFF9370DB);
      case ProfileFrame.aurora:
        return const Color(0xFF00FF7F);
    }
  }

  /// XP kazanım animasyonu göster
  void _showXpGainAnimation(double xpAmount) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.5 - 50,
        child: XpGainAnimation(
          xpAmount: xpAmount,
          onAnimationComplete: () => overlayEntry.remove(),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Level atlama kutlaması göster
  void _showLevelUpCelebration(int newLevel) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: LevelUpCelebration(
              newLevel: newLevel,
              onAnimationComplete: () => overlayEntry.remove(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Milestone başarı göster
  void _showMilestoneAchievement(dynamic milestone) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: MilestoneAchievement(
          title: milestone.title ?? 'Başarı',
          description: milestone.description ?? 'Yeni bir başarı kazandınız!',
          xpReward: milestone.xpContributed ?? 0,
          onAnimationComplete: () => overlayEntry.remove(),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _StatsShortcut extends StatelessWidget {
  final PrayerTrackerStorage storage;
  final Future<void> Function()? onBeforeOpen;
  const _StatsShortcut({required this.storage, this.onBeforeOpen});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        if (onBeforeOpen != null) await onBeforeOpen!();
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PrayerStatisticsPage(storage: storage),
          ),
        );
      },
      child: PixelBox(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        color: scheme.surface.withOpacity(0.7),
        borderColor: scheme.primary,
        child: Row(
          children: [
            const Icon(Icons.insights, color: Colors.white70, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: PixelLabel(
                AppLocalizations.of(context)!.gamificationStatistics,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _PrayerStatusCard extends StatelessWidget {
  final String name;
  final PrayerRecord? record;
  final VoidCallback onTap;
  const _PrayerStatusCard({
    required this.name,
    this.record,
    required this.onTap,
  });

  (Color, IconData, String, String?) _visual(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = record?.status ?? PrayerStatus.none;
    final location = record?.location;

    String? subtitle;
    if (location != null) {
      subtitle = location.name;
    }

    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case PrayerStatus.none:
        return (
          scheme.surfaceContainerHighest,
          Icons.radio_button_unchecked,
          l10n.statusNotPrayed,
          null,
        );
      case PrayerStatus.kaza:
        return (
          scheme.errorContainer,
          Icons.refresh,
          l10n.statusMakeup,
          subtitle ??
              (location != null ? l10n.locationAtMosque : l10n.locationAtHome),
        );
      case PrayerStatus.kilindi:
        return (
          scheme.primaryContainer,
          Icons.check_circle,
          l10n.statusPrayed,
          subtitle ??
              (location != null ? l10n.locationAtMosque : l10n.locationAtHome),
        );
      case PrayerStatus.cemaat:
        return (
          Colors.green.shade300,
          Icons.groups,
          l10n.statusCongregation,
          subtitle ??
              (location != null ? l10n.locationAtMosque : l10n.locationAtHome),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon, label, subtitle) = _visual(context);
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - 24 * 2 - 12 * 1) /
          2, // 2 columns
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: PixelBox(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            color: color.withOpacity(0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Choose an icon color that contrasts with the tile background so
                // the round mark adapts to theme-aware container colors.
                Builder(
                  builder: (ctx) {
                    final iconColor = color.computeLuminance() > 0.5
                        ? Colors.black87
                        : Colors.white;
                    return Icon(icon, size: 26, color: iconColor);
                  },
                ),
                const SizedBox(height: 6),
                PixelLabel(
                  // Convert the stored prayer name into a short, localized
                  // prayer label before formatting with the tracker template
                  // (e.g. "Dawn Prayer" instead of "Sabah Prayer").
                  AppLocalizations.of(context)!.trackerPrayerName(
                    _localizedPrayerShortName(
                      AppLocalizations.of(context)!,
                      name,
                    ),
                  ),
                  fontSize: 11,
                  color: Colors.white,
                ),
                const SizedBox(height: 2),
                PixelLabel(label, fontSize: 9, color: Colors.white70),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  PixelLabel(subtitle, fontSize: 8, color: Colors.white70),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
