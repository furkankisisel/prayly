import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'shared/widgets/pixel/pixel_app_bar.dart';
import 'gen_l10n/app_localizations.dart';

enum PixelRarity {
  siradan,
  nadir,
  pro,
  gizemli,
  efsane,
  epik;

  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case PixelRarity.siradan:
        return l10n?.raritySiradan ?? 'Sıradan';
      case PixelRarity.nadir:
        return l10n?.rarityNadir ?? 'Nadir';
      case PixelRarity.pro:
        return l10n?.rarityPro ?? 'Pro';
      case PixelRarity.gizemli:
        return l10n?.rarityGizemli ?? 'Gizemli';
      case PixelRarity.efsane:
        return l10n?.rarityEfsane ?? 'Efsane';
      case PixelRarity.epik:
        return l10n?.rarityEpik ?? 'Epik';
    }
  }
}

class PixelFrameShowcase extends StatefulWidget {
  const PixelFrameShowcase({super.key});

  @override
  State<PixelFrameShowcase> createState() => _PixelFrameShowcaseState();
}

class _PixelFrameShowcaseState extends State<PixelFrameShowcase>
    with TickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Frame Showcase',
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: const PixelAppBar(title: '8-BIT RARITY FRAMES'),
        body: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.75,
              ),
              itemCount: PixelRarity.values.length,
              itemBuilder: (context, index) {
                final rarity = PixelRarity.values[index];
                return _buildPixelFrame(rarity);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPixelFrame(PixelRarity rarity) {
    final colors = _getRarityColors(rarity);
    final shouldGlow = [
      PixelRarity.gizemli,
      PixelRarity.efsane,
      PixelRarity.epik,
    ].contains(rarity);
    final glowIntensity = shouldGlow ? _glowController.value : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: shouldGlow
            ? [
                BoxShadow(
                  color: colors.frameLight.withOpacity(
                    0.3 + (glowIntensity * 0.4),
                  ),
                  blurRadius: 20 + (glowIntensity * 20),
                  spreadRadius: 5 + (glowIntensity * 10),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Frame display area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  // Outer chunky frame
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: colors.frameDark, width: 6),
                    ),
                  ),
                  // Middle frame layer
                  Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: colors.frameLight, width: 4),
                    ),
                  ),
                  // Inner frame accent
                  Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(color: colors.frameAccent, width: 2),
                    ),
                  ),
                  // Background pattern
                  Container(
                    margin: const EdgeInsets.all(18),
                    child: CustomPaint(
                      painter: PixelPatternPainter(
                        colors.backgroundPattern,
                        glowIntensity,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                  // Corner decorations for higher rarities
                  if (shouldGlow)
                    _buildCornerDecorations(colors, glowIntensity),
                  // Rarity effect overlay
                  if (rarity == PixelRarity.epik)
                    _buildFireEffect(colors, glowIntensity),
                  if (rarity == PixelRarity.efsane)
                    _buildShimmerEffect(colors, glowIntensity),
                  if (rarity == PixelRarity.gizemli)
                    _buildMysticalEffect(colors, glowIntensity),
                ],
              ),
            ),
          ),
          // Rarity label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: colors.frameDark,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              border: Border.all(color: colors.frameLight, width: 2),
            ),
            child: Text(
              rarity.displayName(context).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1,
                shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerDecorations(FrameColors colors, double glowIntensity) {
    return Stack(
      children: [
        // Top-left corner
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors.frameLight.withOpacity(0.8 + (glowIntensity * 0.2)),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        // Top-right corner
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors.frameLight.withOpacity(0.8 + (glowIntensity * 0.2)),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        // Bottom-left corner
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors.frameLight.withOpacity(0.8 + (glowIntensity * 0.2)),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        // Bottom-right corner
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors.frameLight.withOpacity(0.8 + (glowIntensity * 0.2)),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFireEffect(FrameColors colors, double glowIntensity) {
    return Positioned.fill(
      child: CustomPaint(
        painter: FireEffectPainter(colors.frameLight, glowIntensity),
      ),
    );
  }

  Widget _buildShimmerEffect(FrameColors colors, double glowIntensity) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ShimmerEffectPainter(colors.frameLight, glowIntensity),
      ),
    );
  }

  Widget _buildMysticalEffect(FrameColors colors, double glowIntensity) {
    return Positioned.fill(
      child: CustomPaint(
        painter: MysticalEffectPainter(colors.frameLight, glowIntensity),
      ),
    );
  }

  FrameColors _getRarityColors(PixelRarity rarity) {
    switch (rarity) {
      case PixelRarity.siradan:
        return FrameColors(
          frameDark: const Color(0xFF8B4513),
          frameLight: const Color(0xFFCD853F),
          frameAccent: const Color(0xFFDEB887),
          backgroundPattern: const Color(0xFF654321),
        );
      case PixelRarity.nadir:
        return FrameColors(
          frameDark: const Color(0xFF708090),
          frameLight: const Color(0xFFC0C0C0),
          frameAccent: const Color(0xFFE6E6FA),
          backgroundPattern: const Color(0xFF778899),
        );
      case PixelRarity.pro:
        return FrameColors(
          frameDark: const Color(0xFFB8860B),
          frameLight: const Color(0xFFFFD700),
          frameAccent: const Color(0xFFFFFACD),
          backgroundPattern: const Color(0xFFDAA520),
        );
      case PixelRarity.gizemli:
        return FrameColors(
          frameDark: const Color(0xFF1E3A8A),
          frameLight: const Color(0xFF3B82F6),
          frameAccent: const Color(0xFF93C5FD),
          backgroundPattern: const Color(0xFF2563EB),
        );
      case PixelRarity.efsane:
        return FrameColors(
          frameDark: const Color(0xFF7C3AED),
          frameLight: const Color(0xFFA855F7),
          frameAccent: const Color(0xFFD8B4FE),
          backgroundPattern: const Color(0xFF8B5CF6),
        );
      case PixelRarity.epik:
        return FrameColors(
          frameDark: const Color(0xFFDC2626),
          frameLight: const Color(0xFFEF4444),
          frameAccent: const Color(0xFFFCA5A5),
          backgroundPattern: const Color(0xFFF87171),
        );
    }
  }
}

class FrameColors {
  final Color frameDark;
  final Color frameLight;
  final Color frameAccent;
  final Color backgroundPattern;

  FrameColors({
    required this.frameDark,
    required this.frameLight,
    required this.frameAccent,
    required this.backgroundPattern,
  });
}

class PixelPatternPainter extends CustomPainter {
  final Color color;
  final double intensity;

  PixelPatternPainter(this.color, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1 + (intensity * 0.1))
      ..style = PaintingStyle.fill;

    const blockSize = 6.0;
    for (double x = 0; x < size.width; x += blockSize * 2) {
      for (double y = 0; y < size.height; y += blockSize * 2) {
        if ((x / blockSize + y / blockSize) % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(x, y, blockSize, blockSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FireEffectPainter extends CustomPainter {
  final Color color;
  final double intensity;

  FireEffectPainter(this.color, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 + (intensity * 0.4))
      ..style = PaintingStyle.fill;

    // Draw flame-like pixels around the border
    const pixelSize = 4.0;
    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i;
      final y = 4 + (math.sin(intensity * math.pi * 2 + i) * 8);
      canvas.drawRect(Rect.fromLTWH(x, y, pixelSize, pixelSize), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerEffectPainter extends CustomPainter {
  final Color color;
  final double intensity;

  ShimmerEffectPainter(this.color, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4 + (intensity * 0.6))
      ..style = PaintingStyle.fill;

    // Draw diagonal shimmer pixels
    const pixelSize = 3.0;
    for (int i = 0; i < 12; i++) {
      final offset = (intensity * size.width * 2) - size.width;
      final x = (i * 20.0) + offset;
      final y = (i * 15.0) % size.height;

      if (x >= 0 && x < size.width) {
        canvas.drawRect(Rect.fromLTWH(x, y, pixelSize, pixelSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MysticalEffectPainter extends CustomPainter {
  final Color color;
  final double intensity;

  MysticalEffectPainter(this.color, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2 + (intensity * 0.3))
      ..style = PaintingStyle.fill;

    // Draw mysterious aura pixels
    const pixelSize = 5.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (intensity * math.pi * 2) + (i * math.pi / 3);
      final radius = 30 + (intensity * 20);
      final x = centerX + math.cos(angle) * radius - pixelSize / 2;
      final y = centerY + math.sin(angle) * radius - pixelSize / 2;

      canvas.drawRect(Rect.fromLTWH(x, y, pixelSize, pixelSize), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  runApp(const PixelFrameShowcase());
}
