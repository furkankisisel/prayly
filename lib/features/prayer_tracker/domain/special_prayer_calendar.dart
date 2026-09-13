/// Ramazan ve Bayram günlerine göre ekstra namaz (Teravih, Bayram) listesi sağlar.
/// Gelecekte kandil geceleri veya kullanıcı konumuna göre dinamik güncellemeler eklenebilir.
class SpecialPrayerCalendar {
  static final List<(_DateRange, _SpecialPeriod)> _periods = [
    // 2025 tahmini Ramazan ve bayramlar
    (
      _DateRange(DateTime(2025, 3, 1), DateTime(2025, 3, 30)),
      _SpecialPeriod.ramazan,
    ),
    (
      _DateRange(DateTime(2025, 3, 31), DateTime(2025, 4, 2)),
      _SpecialPeriod.ramazanBayram,
    ),
    (
      _DateRange(DateTime(2025, 6, 6), DateTime(2025, 6, 9)),
      _SpecialPeriod.kurbanBayram,
    ),
    // 2024 geçmiş verisi
    (
      _DateRange(DateTime(2024, 3, 11), DateTime(2024, 4, 9)),
      _SpecialPeriod.ramazan,
    ),
    (
      _DateRange(DateTime(2024, 4, 10), DateTime(2024, 4, 12)),
      _SpecialPeriod.ramazanBayram,
    ),
    (
      _DateRange(DateTime(2024, 6, 16), DateTime(2024, 6, 19)),
      _SpecialPeriod.kurbanBayram,
    ),
  ];

  static List<String> specialPrayersFor(DateTime date) {
    final norm = DateTime(date.year, date.month, date.day);
    final periodsForDay = _periods
        .where((p) => p.$1.contains(norm))
        .map((p) => p.$2)
        .toSet();

    final extras = <String>[];
    if (periodsForDay.contains(_SpecialPeriod.ramazan)) {
      extras.add('Teravih');
    }
    if (periodsForDay.contains(_SpecialPeriod.ramazanBayram) ||
        periodsForDay.contains(_SpecialPeriod.kurbanBayram)) {
      extras.add('Bayram');
    }
    return extras;
  }
}

enum _SpecialPeriod { ramazan, ramazanBayram, kurbanBayram }

class _DateRange {
  final DateTime start;
  final DateTime end;
  const _DateRange(this.start, this.end);
  bool contains(DateTime d) => !d.isBefore(start) && !d.isAfter(end);
}
