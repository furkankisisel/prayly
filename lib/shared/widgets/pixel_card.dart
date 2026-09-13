import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../gen_l10n/app_localizations.dart';

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

class PixelCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final IconData? overlayIcon;
  final PixelRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const PixelCard({
    super.key,
    required this.title,
    required this.icon,
    this.overlayIcon,
    required this.rarity,
    required this.xpValue,
    required this.progressValue,
    this.progressType = 'streak',
    this.onTap,
    this.width,
    this.height,
  });

  @override
  State<PixelCard> createState() => _PixelCardState();
}

class _PixelCardState extends State<PixelCard> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.width ?? 200.0;
    final cardHeight = widget.height ?? 300.0;

    return GestureDetector(
      onTapDown: (_) => _onPressed(true),
      onTapUp: (_) => _onPressed(false),
      onTapCancel: () => _onPressed(false),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final bounceScale = 1.0 - (_bounceController.value * 0.05);
          final colors = _getRarityColors(widget.rarity);

          return Transform.scale(
            scale: bounceScale,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                children: [
                  // Pixel background
                  _buildPixelBackground(),
                  // Rarity frame
                  _buildPixelFrame(),
                  // Content
                  _buildPixelContent(),
                  // optional overlay icon (type badge)
                  if (widget.overlayIcon != null)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: colors.frameLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.frameDark, width: 1),
                        ),
                        child: Icon(
                          widget.overlayIcon,
                          size: 14,
                          color: colors.frameDark,
                        ),
                      ),
                    ),
                  // Sparkle effects for higher rarities
                  if (_shouldShowSparkles()) _buildPixelSparkles(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onPressed(bool pressed) {
    if (pressed) {
      _bounceController.forward();
    } else {
      _bounceController.reverse();
    }
  }

  bool _shouldShowSparkles() {
    return [
      PixelRarity.gizemli,
      PixelRarity.efsane,
      PixelRarity.epik,
    ].contains(widget.rarity);
  }

  Widget _buildPixelBackground() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          4,
        ), // Minimal rounding for pixel feel
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.backgroundTop, colors.backgroundBottom],
        ),
      ),
      child: CustomPaint(
        painter: PixelBackgroundPainter(colors.backgroundPattern),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildPixelFrame() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.frameDark, width: 4),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: colors.frameLight, width: 2),
        ),
      ),
    );
  }

  Widget _buildPixelContent() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Pixel rarity badge
          _buildPixelRarityBadge(),

          const SizedBox(height: 3),

          // Pixel title
          _buildPixelTitle(),

          const SizedBox(height: 4),

          // Central pixel icon
          _buildPixelIcon(),

          const Spacer(),

          // Pixel stats chips
          _buildPixelStats(),

          const SizedBox(height: 3),

          // Pixel progress bar
          _buildPixelProgress(),
        ],
      ),
    );
  }

  Widget _buildPixelRarityBadge() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.frameDark,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: colors.frameLight, width: 2),
      ),
      child: Text(
        widget.rarity.displayName(context).toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          fontFamily: 'monospace', // Pixel-like font
          shadows: [Shadow(color: Colors.black, offset: const Offset(1, 1))],
        ),
      ),
    );
  }

  Widget _buildPixelTitle() {
    return Text(
      widget.title.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        height: 1.1,
        fontFamily: 'monospace',
        shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
      ),
    );
  }

  Widget _buildPixelIcon() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: colors.iconBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.frameDark, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 0, // No blur for sharp pixel effect
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colors.iconInner,
          borderRadius: BorderRadius.circular(2),
        ),
        child: CustomPaint(
          painter: PixelIconPainter(widget.icon, colors.frameLight),
          size: const Size(46, 46),
        ),
      ),
    );
  }

  Widget _buildPixelStats() {
    final colors = _getRarityColors(widget.rarity);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Row(
          children: [
            Expanded(
              child: _buildPixelChip(
                l10n.xp,
                widget.xpValue.toString(),
                colors,
                Icons.star,
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _buildPixelChip(
                widget.progressType == 'streak'
                    ? l10n.streak.toUpperCase()
                    : l10n.statisticsTotal.toUpperCase(),
                widget.progressValue.toString(),
                colors,
                widget.progressType == 'streak'
                    ? Icons.local_fire_department
                    : Icons.trending_up,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPixelChip(
    String label,
    String value,
    PixelColors colors,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.chipBackground,
        borderRadius: BorderRadius.circular(1),
        border: Border.all(color: colors.frameDark, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(1, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors.frameLight,
              borderRadius: BorderRadius.circular(1),
            ),
            child: Icon(icon, size: 6, color: colors.frameDark),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              shadows: [
                Shadow(color: Colors.black, offset: const Offset(1, 1)),
              ],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: colors.frameLight,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelProgress() {
    final colors = _getRarityColors(widget.rarity);
    final progress = (widget.progressValue / 100).clamp(0.0, 1.0);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.progressLabel,
                  style: TextStyle(
                    color: colors.frameLight,
                    fontSize: 6,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(1, 1)),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: colors.chipBackground,
                borderRadius: BorderRadius.circular(1),
                border: Border.all(color: colors.frameDark, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: (progress * 100).toInt(),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: colors.frameLight,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 100 - (progress * 100).toInt(),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPixelSparkles() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final angle =
                (_sparkleController.value * 2 * math.pi) +
                (index * math.pi / 3);
            final radius = 60.0 + (index * 15);
            final x = 100 + radius * math.cos(angle) * 0.5;
            final y = 150 + radius * math.sin(angle) * 0.3;
            final opacity = (math.sin(angle * 2) + 1) / 2;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _getRarityColors(
                    widget.rarity,
                  ).frameLight.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  PixelColors _getRarityColors(PixelRarity rarity) {
    switch (rarity) {
      case PixelRarity.siradan:
        return PixelColors(
          frameDark: const Color(0xFF8B4513),
          frameLight: const Color(0xFFCD853F),
          backgroundTop: const Color(0xFF2F1B14),
          backgroundBottom: const Color(0xFF1A0F0A),
          backgroundPattern: const Color(0xFF3D2817),
          iconBackground: const Color(0xFF654321),
          iconInner: const Color(0xFF8B4513),
          chipBackground: const Color(0xFF2F1B14),
        );
      case PixelRarity.nadir:
        return PixelColors(
          frameDark: const Color(0xFF708090),
          frameLight: const Color(0xFFC0C0C0),
          backgroundTop: const Color(0xFF2F2F2F),
          backgroundBottom: const Color(0xFF1A1A1A),
          backgroundPattern: const Color(0xFF404040),
          iconBackground: const Color(0xFF808080),
          iconInner: const Color(0xFF708090),
          chipBackground: const Color(0xFF2F2F2F),
        );
      case PixelRarity.pro:
        return PixelColors(
          frameDark: const Color(0xFFB8860B),
          frameLight: const Color(0xFFFFD700),
          backgroundTop: const Color(0xFF3D3D1A),
          backgroundBottom: const Color(0xFF1F1F0D),
          backgroundPattern: const Color(0xFF4D4D20),
          iconBackground: const Color(0xFFDAA520),
          iconInner: const Color(0xFFB8860B),
          chipBackground: const Color(0xFF3D3D1A),
        );
      case PixelRarity.gizemli:
        return PixelColors(
          frameDark: const Color(0xFF1E3A8A),
          frameLight: const Color(0xFF3B82F6),
          backgroundTop: const Color(0xFF1E293B),
          backgroundBottom: const Color(0xFF0F172A),
          backgroundPattern: const Color(0xFF334155),
          iconBackground: const Color(0xFF2563EB),
          iconInner: const Color(0xFF1E3A8A),
          chipBackground: const Color(0xFF1E293B),
        );
      case PixelRarity.efsane:
        return PixelColors(
          frameDark: const Color(0xFF7C3AED),
          frameLight: const Color(0xFFA855F7),
          backgroundTop: const Color(0xFF2E1065),
          backgroundBottom: const Color(0xFF1E1B4B),
          backgroundPattern: const Color(0xFF4C1D95),
          iconBackground: const Color(0xFF8B5CF6),
          iconInner: const Color(0xFF7C3AED),
          chipBackground: const Color(0xFF2E1065),
        );
      case PixelRarity.epik:
        return PixelColors(
          frameDark: const Color(0xFFDC2626),
          frameLight: const Color(0xFFEF4444),
          backgroundTop: const Color(0xFF7F1D1D),
          backgroundBottom: const Color(0xFF450A0A),
          backgroundPattern: const Color(0xFF991B1B),
          iconBackground: const Color(0xFFF87171),
          iconInner: const Color(0xFFDC2626),
          chipBackground: const Color(0xFF7F1D1D),
        );
    }
  }
}

class PixelColors {
  final Color frameDark;
  final Color frameLight;
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color backgroundPattern;
  final Color iconBackground;
  final Color iconInner;
  final Color chipBackground;

  PixelColors({
    required this.frameDark,
    required this.frameLight,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.backgroundPattern,
    required this.iconBackground,
    required this.iconInner,
    required this.chipBackground,
  });
}

class PixelBackgroundPainter extends CustomPainter {
  final Color patternColor;

  PixelBackgroundPainter(this.patternColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = patternColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw pixel pattern
    const blockSize = 8.0;
    for (double x = 0; x < size.width; x += blockSize * 2) {
      for (double y = 0; y < size.height; y += blockSize * 2) {
        canvas.drawRect(Rect.fromLTWH(x, y, blockSize, blockSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PixelIconPainter extends CustomPainter {
  final IconData icon;
  final Color color;

  PixelIconPainter(this.icon, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw pixelated icon representation
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Simple pixelated icon blocks
    const blockSize = 4.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw a simple pixelated icon pattern
    final blocks = [
      Offset(centerX - blockSize, centerY - blockSize),
      Offset(centerX, centerY - blockSize),
      Offset(centerX + blockSize, centerY - blockSize),
      Offset(centerX - blockSize, centerY),
      Offset(centerX, centerY),
      Offset(centerX + blockSize, centerY),
      Offset(centerX, centerY + blockSize),
    ];

    for (final block in blocks) {
      canvas.drawRect(
        Rect.fromLTWH(block.dx, block.dy, blockSize, blockSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
