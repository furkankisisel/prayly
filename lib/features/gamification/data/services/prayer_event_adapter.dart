import '../../../prayer_tracker/data/prayer_tracker_storage.dart';
import '../../../prayer_tracker/domain/special_prayer_calendar.dart';
import '../../domain/entities/prayer_event.dart';

/// Prayer tracker verilerini gamification event'lerine dönüştürür
class PrayerEventAdapter {
  /// PrayerRecord'u PrayerEvent'e dönüştür
  static PrayerEvent adaptFromRecord(
    String prayerName,
    PrayerRecord record,
    DateTime date,
  ) {
    final mode = _mapStatusToMode(record.status, record.location != null);
    final flags = _detectEventFlags(date, prayerName);

    // If this record indicates a newly added location, mark it for mosque discovery
    if (record.isNewLocation) {
      flags.add(EventFlag.mosqueAdded);
    }

    return PrayerEvent(
      prayerType: _mapPrayerName(prayerName),
      mode: mode,
      timestamp: record.recordedAt ?? date,
      mosqueId: record.location?.uniqueId,
      flags: flags,
      latitude: null, // Şimdilik coordinate yok
      longitude: null,
    );
  }

  /// PrayerStatus'u PrayerMode'a dönüştür
  static PrayerMode _mapStatusToMode(PrayerStatus status, bool inMosque) {
    switch (status) {
      case PrayerStatus.none:
        return PrayerMode.normal; // Bu durumda event oluşturulmaz normalde
      case PrayerStatus.kaza:
        return PrayerMode.qada;
      case PrayerStatus.kilindi:
        return inMosque ? PrayerMode.mosqueSingle : PrayerMode.normal;
      case PrayerStatus.cemaat:
        return inMosque
            ? PrayerMode.mosqueCongregation
            : PrayerMode.congregation;
    }
  }

  /// Türkçe namaz isimlerini standart kodlara çevir
  static String _mapPrayerName(String turkishName) {
    switch (turkishName.toLowerCase()) {
      case 'sabah':
        return 'fajr';
      case 'öğle':
        return 'dhuhr';
      case 'ikindi':
        return 'asr';
      case 'akşam':
        return 'maghrib';
      case 'yatsı':
        return 'isha';
      case 'cuma':
        return 'jumu\'ah';
      case 'bayram':
        return 'eid';
      case 'teravih':
        return 'tarawih';
      default:
        return turkishName.toLowerCase();
    }
  }

  /// Tarih ve namaz adına göre özel bayrakları tespit et
  static Set<EventFlag> _detectEventFlags(DateTime date, String prayerName) {
    final flags = <EventFlag>{};

    // Cuma kontrolü: sadece öğle (öğle veya explicit 'cuma') namazı işaretlensin
    final lowerName = prayerName.toLowerCase();
    final isFriday = date.weekday == DateTime.friday;
    if (isFriday && (lowerName == 'öğle' || lowerName == 'cuma')) {
      flags.add(
        EventFlag.friday,
      ); // Sadece bu tek event gün içinde Friday olarak sayılır
    }

    // Özel günleri SpecialPrayerCalendar'dan al
    final specialPrayers = SpecialPrayerCalendar.specialPrayersFor(date);

    if (specialPrayers.contains('Teravih')) {
      flags.add(EventFlag.ramadan);
    }

    if (specialPrayers.contains('Bayram') ||
        prayerName.toLowerCase() == 'bayram') {
      flags.add(EventFlag.eid);
    }

    // Kandil geceleri tespiti (basit implementasyon)
    if (_isKandilNight(date)) {
      flags.add(EventFlag.kandil);
    }

    return flags;
  }

  /// Kandil gecesi tespiti (basit implementasyon)
  static bool _isKandilNight(DateTime date) {
    // TODO: Gerçek kandil gecesi hesaplama
    // Şimdilik sadece bazı sabit tarihler
    final kandilDates = [
      DateTime(2025, 2, 26), // Regaip Kandili (örnek)
      DateTime(2025, 3, 8), // Miraç Kandili (örnek)
      DateTime(2025, 4, 23), // Berat Kandili (örnek)
      DateTime(2025, 7, 3), // Kadir Gecesi (örnek)
    ];

    return kandilDates.any(
      (kandil) =>
          kandil.year == date.year &&
          kandil.month == date.month &&
          kandil.day == date.day,
    );
  }
}
