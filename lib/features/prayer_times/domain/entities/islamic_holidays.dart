import 'package:flutter/material.dart';

/// Kandil günlerini ve özel günleri yönetir
class IslamicHolidays {
  static const Map<String, String> _kandillar = {
    '2025-01-13': 'Mevlid Kandili',
    '2025-01-27': 'Regaip Kandili',
    '2025-02-14': 'Miraç Kandili',
    '2025-02-28': 'Berat Kandili',
    '2025-05-16': 'Kadir Gecesi',
    // 2026 kandilleri
    '2026-01-02': 'Mevlid Kandili',
    '2026-01-16': 'Regaip Kandili',
    '2026-02-03': 'Miraç Kandili',
    '2026-02-17': 'Berat Kandili',
    '2026-05-06': 'Kadir Gecesi',
  };

  /// Bugün kandil günü mü kontrol eder
  static String? getTodaysKandil() {
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _kandillar[dateKey];
  }

  /// Bugün özel bir gün mü kontrol eder
  static bool isSpecialDay() {
    return getTodaysKandil() != null;
  }
}

/// Kerahat vakitlerini hesaplar
class KerahatVakitleri {
  /// Güneş doğumundan sonraki kerahat vakti (dakika)
  static const int gunesdogumSonrasi = 60;

  /// Güneş batımından önceki kerahat vakti (dakika)
  // replaced: we use ikindi (asr) öncesi kerahat
  static const int ikindiOncesiKerahat = 45;

  /// Güneş tam tepede kerahat vakti (öğle vaktinden önceki dakika)
  static const int guntepeKerahat = 60;

  /// Şu anda kerahat vakti mi kontrol eder
  static bool isKerahatTime(DateTime now, List<DateTime> prayerTimes) {
    if (prayerTimes.length < 5) return false;

    final sunrise = prayerTimes[0]; // Sabah ezanı (güneş doğumu yaklaşık)
    final dhuhr = prayerTimes[1]; // Öğle
    final asr = prayerTimes[2]; // İkindi

    // Güneş doğumundan sonraki kerahat
    final sunriseKerahat = sunrise.add(Duration(minutes: gunesdogumSonrasi));
    if (now.isAfter(sunrise) && now.isBefore(sunriseKerahat)) {
      return true;
    }

    // Güneş tepede kerahat (öğle ezanından önceki 1 saat)
    final dhuhrKerahat = dhuhr.subtract(Duration(minutes: guntepeKerahat));
    if (now.isAfter(dhuhrKerahat) && now.isBefore(dhuhr)) {
      return true;
    }

    // İkindi öncesi kerahat (son 45 dakika before Asr)
    final asrKerahat = asr.subtract(Duration(minutes: ikindiOncesiKerahat));
    if (now.isAfter(asrKerahat) && now.isBefore(asr)) {
      return true;
    }

    return false;
  }

  /// Kerahat vakti açıklaması
  static String getKerahatReason(DateTime now, List<DateTime> prayerTimes) {
    if (prayerTimes.length < 5) return '';

    final sunrise = prayerTimes[0];
    final dhuhr = prayerTimes[1];
    final asr = prayerTimes[2];

    final sunriseKerahat = sunrise.add(Duration(minutes: gunesdogumSonrasi));
    if (now.isAfter(sunrise) && now.isBefore(sunriseKerahat)) {
      return 'Kerahat vakti';
    }

    final dhuhrKerahat = dhuhr.subtract(Duration(minutes: guntepeKerahat));
    if (now.isAfter(dhuhrKerahat) && now.isBefore(dhuhr)) {
      return 'Kerahat vakti';
    }

    final asrKerahat = asr.subtract(Duration(minutes: ikindiOncesiKerahat));
    if (now.isAfter(asrKerahat) && now.isBefore(asr)) {
      return 'Kerahat vakti';
    }

    return '';
  }
}

/// Kandil günü gösterimi için kullanılacak widget
class KandilDisplay extends StatelessWidget {
  final String kandilName;

  const KandilDisplay({super.key, required this.kandilName});

  @override
  Widget build(BuildContext context) {
    return Text(
      kandilName,
      style: TextStyle(
        color: Colors.indigo.shade700,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
