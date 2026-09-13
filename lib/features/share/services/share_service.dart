import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  // Temel paylaşım metodu (widget'ı resim olarak)
  static Future<void> shareWidget({
    required GlobalKey repaintBoundaryKey,
    required String fileName,
    String? text,
  }) async {
    try {
      debugPrint('🔍 Paylaşım başlıyor... RepaintBoundary kontrolü yapılıyor');

      final context = repaintBoundaryKey.currentContext;
      if (context == null) {
        debugPrint('❌ RepaintBoundary context bulunamadı');
        throw Exception(
          'RepaintBoundary context bulunamadı. Widget henüz render edilmemiş olabilir.',
        );
      }

      final renderObject = context.findRenderObject();
      if (renderObject == null) {
        debugPrint('❌ RenderObject bulunamadı');
        throw Exception('RenderObject bulunamadı');
      }

      if (renderObject is! RenderRepaintBoundary) {
        debugPrint('❌ RenderObject bir RenderRepaintBoundary değil');
        throw Exception('Widget RepaintBoundary ile sarılmamış');
      }

      debugPrint('✅ RepaintBoundary bulundu, resim oluşturuluyor...');

      final boundary = renderObject as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      debugPrint('✅ Resim oluşturuldu: ${image.width}x${image.height}');

      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        debugPrint('✅ PNG verileri hazırlandı: ${pngBytes.length} bytes');

        // Geçici dosya oluştur
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$fileName.png';
        final file = await File(filePath).create();
        await file.writeAsBytes(pngBytes);

        debugPrint('✅ Dosya kaydedildi: $filePath');

        // Paylaş
        await Share.shareXFiles([XFile(filePath)], text: text ?? '');
        debugPrint('✅ Paylaşım başarılı!');
      } else {
        debugPrint('❌ ByteData null döndü');
        throw Exception('Resim verisi alınamadı');
      }
    } catch (e) {
      debugPrint('❌ Paylaşım hatası: $e');
      rethrow;
    }
  }

  // Kullanıcı profili paylaşımı (resim)
  static Future<void> shareUserProfile(
    Map<String, dynamic> userProfile, {
    GlobalKey? repaintBoundaryKey,
  }) async {
    if (repaintBoundaryKey != null) {
      await shareWidget(
        repaintBoundaryKey: repaintBoundaryKey,
        fileName: 'prayly_profile',
        text: _buildUserProfileText(userProfile),
      );
    } else {
      await Share.share(_buildUserProfileText(userProfile));
    }
  }

  // Seri kartı paylaşımı (resim)
  static Future<void> shareSeriesCard(
    Map<String, dynamic> seriesData, {
    GlobalKey? repaintBoundaryKey,
  }) async {
    if (repaintBoundaryKey != null) {
      await shareWidget(
        repaintBoundaryKey: repaintBoundaryKey,
        fileName: 'prayly_series',
        text: _buildSeriesCardText(seriesData),
      );
    } else {
      await Share.share(_buildSeriesCardText(seriesData));
    }
  }

  // Başarı paylaşımı
  static Future<void> shareAchievement({
    required GlobalKey repaintBoundaryKey,
    required String achievementText,
  }) async {
    await shareWidget(
      repaintBoundaryKey: repaintBoundaryKey,
      fileName: 'prayly_achievement',
      text:
          '🏆 Prayly\'de yeni bir başarı! 🌟\n\n$achievementText\n\n#Prayly #Başarı #Namaz #İbadet #Motivasyon',
    );
  }

  // Hızlı paylaşım metodları
  Future<void> shareUserProfileQuick(Map<String, dynamic> userProfile) async {
    final text = ShareService._buildUserProfileText(userProfile);
    await Share.share(text);
  }

  Future<void> shareSeriesCardQuick(Map<String, dynamic> seriesData) async {
    final text = ShareService._buildSeriesCardText(seriesData);
    await Share.share(text);
  }

  // Zengin içerik metinleri oluşturma
  static String _buildUserProfileText(Map<String, dynamic> userProfile) {
    final name = userProfile['name'] ?? 'Kullanıcı';
    final level = userProfile['level'] ?? 1;
    final totalPrayers = userProfile['totalPrayers'] ?? 0;
    final completedSeries = userProfile['completedSeries'] ?? 0;
    final currentStreak = userProfile['currentStreak'] ?? 0;

    final progressEmoji = _getProgressEmoji(level);
    final levelEmoji = _getLevelEmoji(level);

    return '$progressEmoji $name\'in Dua Yolculuğu $progressEmoji\n\n'
        '$levelEmoji Seviye: $level\n'
        '🤲 Toplam Dua: $totalPrayers\n'
        '✅ Tamamlanan Seri: $completedSeries\n'
        '🔥 Güncel Seri: $currentStreak gün\n\n'
        '${_getMotivationalMessage(level)}\n\n'
        '${_getHashtags(['dua', 'maneviyat', 'gelişim', 'motivasyon'])}';
  }

  static String _buildSeriesCardText(Map<String, dynamic> seriesData) {
    final seriesName = seriesData['name'] ?? 'Dua Serisi';
    final progress = seriesData['progress'] ?? 0;
    final total = seriesData['total'] ?? 30;
    final completedDays = seriesData['completedDays'] ?? 0;

    final progressEmoji = _getProgressEmoji((progress * 10).round());
    final percentage = total > 0 ? ((completedDays / total) * 100).round() : 0;

    return '$progressEmoji $seriesName Yolculuğum $progressEmoji\n\n'
        '📈 İlerleme: $completedDays/$total gün (%$percentage)\n'
        '🎯 Hedef: $total günlük dua serisi\n'
        '${_getProgressBar(percentage)}\n\n'
        '${_getSeriesMotivation(percentage)}\n\n'
        '${_getHashtags(['dua', 'maneviyat', seriesName.toLowerCase(), 'hedef'])}';
  }

  // Emoji ve motivasyon mesajları
  static String _getProgressEmoji(int level) {
    if (level >= 7) return '🌟';
    if (level >= 5) return '⭐';
    if (level >= 3) return '✨';
    return '🌱';
  }

  static String _getLevelEmoji(int level) {
    const emojis = ['🌱', '🌿', '🍃', '🌳', '🏔️', '👑', '💎'];
    return emojis[level.clamp(1, 7) - 1];
  }

  static String _getMotivationalMessage(int level) {
    final messages = [
      'Dua yolculuğuna yeni başladın! 🌱',
      'Güzel bir ilerleme gösteriyorsun! 🌿',
      'Kararlılığın takdir edilesi! 🍃',
      'Maneviyatında büyük gelişim var! 🌳',
      'Örnek bir dua hayatı yaşıyorsun! 🏔️',
      'Dua konusunda üstün bir seviyedesin! 👑',
      'Manevi mükemmeliyetin zirvesinde! 💎',
    ];
    return messages[level.clamp(1, 7) - 1];
  }

  static String _getSeriesMotivation(int percentage) {
    if (percentage >= 80) return 'Harika! Hedefe çok yaklaştın! 🎉';
    if (percentage >= 60) return 'Muhteşem ilerleme! Devam et! 💪';
    if (percentage >= 40) return 'Güzel gidiyorsun! 🌟';
    if (percentage >= 20) return 'İyi bir başlangıç! ⭐';
    return 'Yolculuğun başında! Azimle devam! 🌱';
  }

  static String _getProgressBar(int percentage) {
    final filled = (percentage / 10).round();
    final empty = 10 - filled;
    return '[${'█' * filled}${'░' * empty}] $percentage%';
  }

  static String _getHashtags(List<String> tags) {
    final defaultTags = ['PrayApp', 'dua', 'maneviyat'];
    final allTags = {...defaultTags, ...tags};
    return allTags.map((tag) => '#${tag.replaceAll(' ', '')}').join(' ');
  }
}
