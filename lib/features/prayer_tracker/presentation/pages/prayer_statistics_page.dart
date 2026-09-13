import 'package:flutter/material.dart';
import '../../../../gen_l10n/app_localizations.dart';
import '../../data/prayer_tracker_storage.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../../shared/widgets/pixel/pixel_tab_bar.dart';

class PrayerStatisticsPage extends StatefulWidget {
  final PrayerTrackerStorage storage;
  const PrayerStatisticsPage({super.key, required this.storage});
  @override
  State<PrayerStatisticsPage> createState() => _PrayerStatisticsPageState();
}

class _PrayerStatisticsPageState extends State<PrayerStatisticsPage>
    with SingleTickerProviderStateMixin {
  late Future<_StatsBundle> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_StatsBundle> _load() async {
    final today = DateTime.now();
    final w = await _aggregate(days: 7, end: today);
    final m = await _aggregate(days: 30, end: today);
    final y = await _aggregate(days: 365, end: today);
    return _StatsBundle(week: w, month: m, year: y);
  }

  Future<_AggregatedStats> _aggregate({
    required int days,
    required DateTime end,
  }) async {
    final today = DateTime.now();
    if (end.isAfter(today)) end = today;
    final start = end.subtract(Duration(days: days - 1));
    final recorded = await widget.storage.listRecordedDates();
    final prayers = const ['Sabah', 'Öğle', 'İkindi', 'Akşam', 'Yatsı'];
    final counts = <PrayerStatus, int>{
      for (final s in PrayerStatus.values) s: 0,
    };
    final perPrayer = <String, Map<PrayerStatus, int>>{
      for (final p in prayers) p: {for (final s in PrayerStatus.values) s: 0},
    };
    final perPrayerDayStatuses = <String, List<PrayerStatus>>{
      for (final p in prayers) p: <PrayerStatus>[],
    };
    var total = 0;
    bool sameDate(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    for (int i = 0; i < days; i++) {
      final day = DateTime(
        start.year,
        start.month,
        start.day,
      ).add(Duration(days: i));
      if (day.isAfter(today)) break; // future stop
      final map = await widget.storage.loadForDate(day);
      final hasRecord = recorded.contains(
        DateTime(day.year, day.month, day.day),
      );
      final include =
          hasRecord || sameDate(day, today); // her zaman bugünü dahil et
      if (!include) continue;
      for (final p in prayers) {
        final status = map[p] ?? PrayerStatus.none;
        counts[status] = (counts[status] ?? 0) + 1;
        perPrayer[p]![status] = (perPrayer[p]![status] ?? 0) + 1;
        perPrayerDayStatuses[p]!.add(status);
        total++;
      }
    }
    return _AggregatedStats(
      days: days,
      total: total,
      counts: counts,
      perPrayer: perPrayer,
      perPrayerDayStatuses: perPrayerDayStatuses,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PixelAppBar(
          title: AppLocalizations.of(context)!.statisticsTitle,
          bottom: PixelTabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.statisticsTabWeekly),
              Tab(text: AppLocalizations.of(context)!.statisticsTabMonthly),
              Tab(text: AppLocalizations.of(context)!.statisticsTabYearly),
            ],
            height: 72,
          ),
        ),
        body: FutureBuilder<_StatsBundle>(
          future: _future,
          builder: (context, snap) {
            if (!snap.hasData) {
              if (snap.hasError)
                return Center(child: Text('Hata: ${snap.error}'));
              return const Center(child: CircularProgressIndicator());
            }
            final data = snap.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _future = _load();
                });
                await _future;
              },
              child: TabBarView(
                children: [
                  _StatsTabContent(
                    label: AppLocalizations.of(context)!.statisticsLast7Days,
                    stats: data.week,
                  ),
                  _StatsTabContent(
                    label: AppLocalizations.of(context)!.statisticsLast30Days,
                    stats: data.month,
                  ),
                  _StatsTabContent(
                    label: AppLocalizations.of(context)!.statisticsLast365Days,
                    stats: data.year,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _ViewMode { squares, summary }

class _StatsTabContent extends StatefulWidget {
  final String label;
  final _AggregatedStats stats;
  const _StatsTabContent({required this.label, required this.stats});

  @override
  State<_StatsTabContent> createState() => _StatsTabContentState();
}

class _StatsTabContentState extends State<_StatsTabContent> {
  _ViewMode _mode = _ViewMode.squares;

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionHeader(label: widget.label),
        const SizedBox(height: 8),
        _ViewModeToggle(
          mode: _mode,
          onChanged: (m) => setState(() => _mode = m),
        ),
        const SizedBox(height: 18),
        _OverallSegmentedBar(stats: stats),
        const SizedBox(height: 24),
        if (_mode == _ViewMode.squares) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              // Legend içeriği dar ekranlarda taşma yapıyordu; esnek yerleşim.
              if (constraints.maxWidth < 420) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.statisticsSquares,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    _Legend(),
                  ],
                );
              }
              return Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.statisticsSquares,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _Legend(),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          for (final prayer in stats.perPrayerDayStatuses.keys) ...[
            PixelPanel(
              child: _PrayerSquaresRow(
                name: prayer,
                statuses: stats.perPrayerDayStatuses[prayer]!,
              ),
            ),
            const SizedBox(height: 14),
          ],
        ] else ...[
          PixelLabel(
            AppLocalizations.of(context)!.statisticsSummary,
            fontSize: 12,
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          _PrayerSummaryGrid(stats: stats),
          const SizedBox(height: 14),
          _Legend(),
        ],
        const SizedBox(height: 44),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: PixelLabel(
      label,
      fontSize: 12,
      color: Colors.white,
      textAlign: TextAlign.left,
    ),
  );
}

class _PrayerSquaresRow extends StatelessWidget {
  final String name;
  final List<PrayerStatus> statuses;
  const _PrayerSquaresRow({required this.name, required this.statuses});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color colorFor(PrayerStatus s) {
      return switch (s) {
        PrayerStatus.none => scheme.outlineVariant,
        PrayerStatus.kaza => scheme.error,
        PrayerStatus.kilindi => scheme.primary,
        PrayerStatus.cemaat => Colors.green,
      };
    }

    final squareSize = statuses.length > 120
        ? 10.0
        : statuses.length > 60
        ? 12.0
        : 16.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final itemSpace = squareSize + 4; // width + spacing
        int cols = (maxW / itemSpace).floor();
        if (cols < 4) cols = 4; // minimum
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PixelLabel(name, fontSize: 11, color: Colors.white),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i < statuses.length; i++)
                  AnimatedContainer(
                    key: ValueKey('$name-$i'),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      color: colorFor(statuses[i]).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            _RowCounts(statuses: statuses),
          ],
        );
      },
    );
  }
}

class _RowCounts extends StatelessWidget {
  final List<PrayerStatus> statuses;
  const _RowCounts({required this.statuses});
  @override
  Widget build(BuildContext context) {
    int count(PrayerStatus s) => statuses.where((e) => e == s).length;
    final total = statuses.length;
    final l10n = AppLocalizations.of(context)!;
    final text =
        '${l10n.statusPrayed} ${count(PrayerStatus.kilindi)}/$total • ${l10n.statusCongregation} ${count(PrayerStatus.cemaat)}/$total • ${l10n.statusMakeup} ${count(PrayerStatus.kaza)}/$total • ${l10n.statusNotPrayed} ${count(PrayerStatus.none)}/$total';
    return PixelLabel(text, fontSize: 9, color: Colors.white70);
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget item(Color c, String t) => PixelBox(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          PixelLabel(t, fontSize: 9, color: Colors.white70),
        ],
      ),
    );
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        item(scheme.primary, l10n.statusPrayed),
        item(Colors.green, l10n.statusCongregation),
        item(scheme.error, l10n.statusMakeup),
        item(scheme.outlineVariant, l10n.statusNotPrayed),
      ],
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  final _ViewMode mode;
  final ValueChanged<_ViewMode> onChanged;
  const _ViewModeToggle({required this.mode, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        InkWell(
          onTap: () => onChanged(_ViewMode.squares),
          child: PixelBox(
            color: (mode == _ViewMode.squares)
                ? scheme.primary.withValues(alpha: .15)
                : scheme.surface.withValues(alpha: .6),
            borderColor: (mode == _ViewMode.squares)
                ? scheme.primary
                : scheme.outline,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: PixelLabel(
              AppLocalizations.of(context)!.statisticsSquares,
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => onChanged(_ViewMode.summary),
          child: PixelBox(
            color: (mode == _ViewMode.summary)
                ? scheme.primary.withValues(alpha: .15)
                : scheme.surface.withValues(alpha: .6),
            borderColor: (mode == _ViewMode.summary)
                ? scheme.primary
                : scheme.outline,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: PixelLabel(
              AppLocalizations.of(context)!.statisticsSummary,
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _OverallSegmentedBar extends StatelessWidget {
  final _AggregatedStats stats;
  const _OverallSegmentedBar({required this.stats});
  @override
  Widget build(BuildContext context) {
    final total = stats.total == 0 ? 1 : stats.total;
    final scheme = Theme.of(context).colorScheme;
    int c(PrayerStatus s) => stats.counts[s] ?? 0;
    final segments = [
      (c(PrayerStatus.kilindi), scheme.primary),
      (c(PrayerStatus.cemaat), Colors.green),
      (c(PrayerStatus.kaza), scheme.error),
      (c(PrayerStatus.none), scheme.outlineVariant),
    ];
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PixelLabel(
            AppLocalizations.of(context)!.statisticsOverall,
            fontSize: 12,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                for (final seg in segments)
                  Expanded(
                    flex: (seg.$1 == 0 ? 1 : seg.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      height: 18,
                      margin: EdgeInsets.only(
                        right: seg == segments.last ? 0 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: seg.$2.withValues(alpha: seg.$1 == 0 ? .15 : .9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _miniStat(
                context,
                AppLocalizations.of(context)!.statisticsMiniLabelDone,
                c(PrayerStatus.kilindi),
                total,
                scheme.primary,
              ),
              _miniStat(
                context,
                AppLocalizations.of(context)!.statisticsMiniLabelCongregation,
                c(PrayerStatus.cemaat),
                total,
                Colors.green,
              ),
              _miniStat(
                context,
                AppLocalizations.of(context)!.statisticsMiniLabelMakeup,
                c(PrayerStatus.kaza),
                total,
                scheme.error,
              ),
              _miniStat(
                context,
                AppLocalizations.of(context)!.statisticsMiniLabelNotPrayed,
                c(PrayerStatus.none),
                total,
                scheme.outlineVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
    BuildContext context,
    String label,
    int count,
    int total,
    Color c,
  ) {
    final pct = total == 0 ? 0 : (count / total * 100);
    final text = '$label: $count (${pct.toStringAsFixed(0)}%)';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerSummaryGrid extends StatelessWidget {
  final _AggregatedStats stats;
  const _PrayerSummaryGrid({required this.stats});
  @override
  Widget build(BuildContext context) {
    final prayers = stats.perPrayer.keys.toList();
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final p in prayers)
          SizedBox(
            width: 150,
            child: PixelPanel(
              child: _PrayerSummaryCard(
                prayer: p,
                statuses: stats.perPrayerDayStatuses[p]!,
              ),
            ),
          ),
      ],
    );
  }
}

class _PrayerSummaryCard extends StatelessWidget {
  final String prayer;
  final List<PrayerStatus> statuses;
  const _PrayerSummaryCard({required this.prayer, required this.statuses});
  @override
  Widget build(BuildContext context) {
    int count(PrayerStatus s) => statuses.where((e) => e == s).length;
    final total = statuses.length == 0 ? 1 : statuses.length;
    final scheme = Theme.of(context).colorScheme;
    final kilindi = count(PrayerStatus.kilindi);
    final cemaat = count(PrayerStatus.cemaat);
    final combined = kilindi + cemaat; // successful
    final successPct = combined / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PixelLabel(prayer, fontSize: 11, color: Colors.white),
        const SizedBox(height: 8),
        SizedBox(
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  value: successPct,
                  backgroundColor: scheme.outlineVariant.withValues(alpha: .3),
                  valueColor: AlwaysStoppedAnimation(
                    successPct > .66
                        ? Colors.green
                        : (successPct > .33 ? scheme.primary : scheme.error),
                  ),
                ),
              ),
              Text(
                '${(successPct * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        PixelLabel(
          '${AppLocalizations.of(context)!.statusPrayed} ${kilindi + cemaat}/$total',
          fontSize: 9,
          color: Colors.white70,
        ),
        PixelLabel(
          '${AppLocalizations.of(context)!.statusMakeup} ${count(PrayerStatus.kaza)}',
          fontSize: 9,
          color: Colors.white70,
        ),
        PixelLabel(
          '${AppLocalizations.of(context)!.statusNotPrayed} ${count(PrayerStatus.none)}',
          fontSize: 9,
          color: Colors.white70,
        ),
      ],
    );
  }
}

class _AggregatedStats {
  final int days;
  final int total;
  final Map<PrayerStatus, int> counts;
  final Map<String, Map<PrayerStatus, int>> perPrayer;
  final Map<String, List<PrayerStatus>> perPrayerDayStatuses;
  _AggregatedStats({
    required this.days,
    required this.total,
    required this.counts,
    required this.perPrayer,
    required this.perPrayerDayStatuses,
  });
}

class _StatsBundle {
  final _AggregatedStats week;
  final _AggregatedStats month;
  final _AggregatedStats year;
  _StatsBundle({required this.week, required this.month, required this.year});
}
