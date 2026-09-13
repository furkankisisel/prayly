import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'card_rarity.dart';
import '../../gen_l10n/app_localizations.dart';

class CollectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final IconData? overlayIcon;
  final CardRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType; // 'streak' veya 'total'
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const CollectionCard({
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
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.width ?? 180.0;
    final cardHeight = widget.height ?? 280.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Ana kart konteyneri
            _buildCardBase(),
            // Holografik shimmer efekti
            _buildShimmerEffect(),
            // İçerik
            _buildCardContent(),
            if (widget.overlayIcon != null)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    widget.overlayIcon,
                    size: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            // Geometrik motifler
            _buildGeometricPattern(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBase() {
    final rarityColors = _getRarityColors(widget.rarity);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: rarityColors.backgroundGradient,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        border: Border.all(color: rarityColors.borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: rarityColors.shadowColor,
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: rarityColors.glowColor,
            blurRadius: 40,
            spreadRadius: -5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomPaint(
              painter: HolographicShimmerPainter(
                animation: _shimmerController.value,
                rarity: widget.rarity,
              ),
              size: Size.infinite,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rarity badge
          _buildRarityBadge(),
          const SizedBox(height: 12),

          // Başlık
          _buildTitle(),

          const Spacer(),

          // Ana ikon
          _buildMainIcon(),

          const Spacer(),

          // XP ve Progress
          _buildStatsRow(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRarityBadge() {
    final rarityColors = _getRarityColors(widget.rarity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: rarityColors.badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rarityColors.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: rarityColors.glowColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Builder(
        builder: (context) {
          final t = Theme.of(context).textTheme;
          return Text(
            widget.rarity.displayName(context).toUpperCase(),
            style: t.labelSmall?.copyWith(
              color: rarityColors.textColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    final rarityColors = _getRarityColors(widget.rarity);

    return Builder(
      builder: (context) {
        final t = Theme.of(context).textTheme;
        return Text(
          widget.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: t.titleMedium?.copyWith(
            color: rarityColors.textColor,
            fontWeight: FontWeight.w700,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainIcon() {
    final rarityColors = _getRarityColors(widget.rarity);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        final glowIntensity = 0.3 + (pulseValue * 0.4);

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                rarityColors.iconBgColor.withOpacity(0.8),
                rarityColors.iconBgColor.withOpacity(0.4),
              ],
            ),
            border: Border.all(
              color: rarityColors.borderColor.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: rarityColors.glowColor.withOpacity(glowIntensity),
                blurRadius: 20 + (pulseValue * 10),
                spreadRadius: 2 + (pulseValue * 3),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 40,
            color: rarityColors.iconColor,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    final rarityColors = _getRarityColors(widget.rarity);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // XP Chip
            _buildStatChip(
              icon: Icons.star,
              value: widget.xpValue.toString(),
              label: l10n.xp,
              rarityColors: rarityColors,
            ),
            // Progress Chip
            _buildStatChip(
              icon: widget.progressType == 'streak'
                  ? Icons.local_fire_department
                  : Icons.format_list_numbered,
              value: widget.progressValue.toString(),
              label: widget.progressType == 'streak'
                  ? l10n.streak
                  : l10n.statisticsTotal,
              rarityColors: rarityColors,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required String label,
    required RarityColorScheme rarityColors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: rarityColors.chipBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rarityColors.borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: rarityColors.chipIconColor),
          const SizedBox(width: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  final t = Theme.of(context).textTheme;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: t.titleSmall?.copyWith(
                          color: rarityColors.chipTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        label,
                        style: t.labelSmall?.copyWith(
                          color: rarityColors.chipTextColor.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeometricPattern() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: IslamicPatternPainter(rarity: widget.rarity, opacity: 0.1),
        ),
      ),
    );
  }

  RarityColorScheme _getRarityColors(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.bronze:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFF8B4513),
            const Color(0xFFCD853F),
            const Color(0xFFD2691E),
            const Color(0xFF8B4513),
          ],
          borderColor: const Color(0xFFFFDAB9),
          shadowColor: const Color(0xFF8B4513).withOpacity(0.3),
          glowColor: const Color(0xFFCD853F).withOpacity(0.4),
          textColor: const Color(0xFFFFE4B5),
          badgeColor: const Color(0xFF654321).withOpacity(0.8),
          iconBgColor: const Color(0xFFCD853F),
          iconColor: const Color(0xFFFFE4B5),
          chipBgColor: const Color(0xFF654321).withOpacity(0.6),
          chipTextColor: const Color(0xFFFFE4B5),
          chipIconColor: const Color(0xFFCD853F),
        );

      case CardRarity.silver:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFF708090),
            const Color(0xFFC0C0C0),
            const Color(0xFFE5E5E5),
            const Color(0xFF708090),
          ],
          borderColor: const Color(0xFFFFFFFF),
          shadowColor: const Color(0xFF708090).withOpacity(0.3),
          glowColor: const Color(0xFFC0C0C0).withOpacity(0.4),
          textColor: const Color(0xFFFFFFFF),
          badgeColor: const Color(0xFF4A4A4A).withOpacity(0.8),
          iconBgColor: const Color(0xFFC0C0C0),
          iconColor: const Color(0xFF2F2F2F),
          chipBgColor: const Color(0xFF4A4A4A).withOpacity(0.6),
          chipTextColor: const Color(0xFFFFFFFF),
          chipIconColor: const Color(0xFFC0C0C0),
        );

      case CardRarity.gold:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFFB8860B),
            const Color(0xFFFFD700),
            const Color(0xFFFFFacd),
            const Color(0xFFB8860B),
          ],
          borderColor: const Color(0xFFFFE55C),
          shadowColor: const Color(0xFFB8860B).withOpacity(0.4),
          glowColor: const Color(0xFFFFD700).withOpacity(0.5),
          textColor: const Color(0xFF2F2F2F),
          badgeColor: const Color(0xFF8B6914).withOpacity(0.8),
          iconBgColor: const Color(0xFFFFD700),
          iconColor: const Color(0xFF2F2F2F),
          chipBgColor: const Color(0xFF8B6914).withOpacity(0.7),
          chipTextColor: const Color(0xFFFFE55C),
          chipIconColor: const Color(0xFFFFD700),
        );

      case CardRarity.platinum:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFF4A5568),
            const Color(0xFFE2E8F0),
            const Color(0xFF00CED1),
            const Color(0xFF4A5568),
          ],
          borderColor: const Color(0xFF00FFFF),
          shadowColor: const Color(0xFF00CED1).withOpacity(0.4),
          glowColor: const Color(0xFF00FFFF).withOpacity(0.5),
          textColor: const Color(0xFFFFFFFF),
          badgeColor: const Color(0xFF2D3748).withOpacity(0.8),
          iconBgColor: const Color(0xFF00CED1),
          iconColor: const Color(0xFFFFFFFF),
          chipBgColor: const Color(0xFF2D3748).withOpacity(0.7),
          chipTextColor: const Color(0xFF00FFFF),
          chipIconColor: const Color(0xFF00CED1),
        );

      case CardRarity.diamond:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFF1A202C),
            const Color(0xFFB9F2FF),
            const Color(0xFFE0F7FF),
            const Color(0xFF1A202C),
          ],
          borderColor: const Color(0xFFCCF7FF),
          shadowColor: const Color(0xFFB9F2FF).withOpacity(0.5),
          glowColor: const Color(0xFFE0F7FF).withOpacity(0.6),
          textColor: const Color(0xFFFFFFFF),
          badgeColor: const Color(0xFF2D3748).withOpacity(0.9),
          iconBgColor: const Color(0xFFB9F2FF),
          iconColor: const Color(0xFF1A202C),
          chipBgColor: const Color(0xFF2D3748).withOpacity(0.8),
          chipTextColor: const Color(0xFFCCF7FF),
          chipIconColor: const Color(0xFFB9F2FF),
        );

      case CardRarity.nur:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFFFFF8DC),
            const Color(0xFFFFE4E1),
            const Color(0xFFF0E68C),
            const Color(0xFFFFF8DC),
          ],
          borderColor: const Color(0xFFFFFFE0),
          shadowColor: const Color(0xFFF0E68C).withOpacity(0.5),
          glowColor: const Color(0xFFFFFFE0).withOpacity(0.7),
          textColor: const Color(0xFF8B4513),
          badgeColor: const Color(0xFFDEB887).withOpacity(0.8),
          iconBgColor: const Color(0xFFFFE4E1),
          iconColor: const Color(0xFF8B4513),
          chipBgColor: const Color(0xFFDEB887).withOpacity(0.7),
          chipTextColor: const Color(0xFF8B4513),
          chipIconColor: const Color(0xFFF0E68C),
        );

      case CardRarity.sidre:
        return RarityColorScheme(
          backgroundGradient: [
            const Color(0xFF9400D3),
            const Color(0xFF00CED1),
            const Color(0xFFFFD700),
            const Color(0xFF9400D3),
          ],
          borderColor: const Color(0xFFFFFFFF),
          shadowColor: const Color(0xFF9400D3).withOpacity(0.6),
          glowColor: const Color(0xFFFFD700).withOpacity(0.7),
          textColor: const Color(0xFFFFFFFF),
          badgeColor: const Color(0xFF4B0082).withOpacity(0.9),
          iconBgColor: const Color(0xFFFFD700),
          iconColor: const Color(0xFF4B0082),
          chipBgColor: const Color(0xFF4B0082).withOpacity(0.8),
          chipTextColor: const Color(0xFFFFFFFF),
          chipIconColor: const Color(0xFFFFD700),
        );
    }
  }
}

class RarityColorScheme {
  final List<Color> backgroundGradient;
  final Color borderColor;
  final Color shadowColor;
  final Color glowColor;
  final Color textColor;
  final Color badgeColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color chipBgColor;
  final Color chipTextColor;
  final Color chipIconColor;

  RarityColorScheme({
    required this.backgroundGradient,
    required this.borderColor,
    required this.shadowColor,
    required this.glowColor,
    required this.textColor,
    required this.badgeColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.chipBgColor,
    required this.chipTextColor,
    required this.chipIconColor,
  });
}

class HolographicShimmerPainter extends CustomPainter {
  final double animation;
  final CardRarity rarity;

  HolographicShimmerPainter({required this.animation, required this.rarity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.overlay;

    // Holografik şerit efekti
    final stripWidth = size.width * 0.3;
    final stripX = (animation * (size.width + stripWidth)) - stripWidth;

    final rect = Rect.fromLTWH(stripX, 0, stripWidth, size.height);

    List<Color> shimmerColors;
    switch (rarity) {
      case CardRarity.sidre:
        shimmerColors = [
          Colors.transparent,
          const Color(0xFF9400D3).withOpacity(0.3),
          const Color(0xFF00CED1).withOpacity(0.3),
          const Color(0xFFFFD700).withOpacity(0.3),
          Colors.transparent,
        ];
        break;
      case CardRarity.nur:
        shimmerColors = [
          Colors.transparent,
          Colors.white.withOpacity(0.4),
          const Color(0xFFF0E68C).withOpacity(0.3),
          Colors.white.withOpacity(0.4),
          Colors.transparent,
        ];
        break;
      default:
        shimmerColors = [
          Colors.transparent,
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.2),
          Colors.transparent,
        ];
    }

    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: shimmerColors,
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Parıltı noktaları
    final sparkleCount = 3;
    for (int i = 0; i < sparkleCount; i++) {
      final localT = (animation + i / sparkleCount) % 1.0;
      final sparkleX = size.width * localT;
      final sparkleY = size.height * (0.2 + (i * 0.3));
      final radius = 2 + 4 * (1 - (localT - 0.5).abs() * 2).clamp(0.0, 1.0);

      final sparklePaint = Paint()
        ..shader =
            RadialGradient(
              colors: [Colors.white.withOpacity(0.6), Colors.transparent],
            ).createShader(
              Rect.fromCircle(
                center: Offset(sparkleX, sparkleY),
                radius: radius,
              ),
            );

      canvas.drawCircle(Offset(sparkleX, sparkleY), radius, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant HolographicShimmerPainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.rarity != rarity;
}

class IslamicPatternPainter extends CustomPainter {
  final CardRarity rarity;
  final double opacity;

  IslamicPatternPainter({required this.rarity, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Köşelerde minimal geometrik motifler
    _drawCornerPattern(canvas, size, paint);
  }

  void _drawCornerPattern(Canvas canvas, Size size, Paint paint) {
    final cornerSize = 20.0;

    // Sol üst köşe
    _drawPattern(canvas, const Offset(10, 10), cornerSize, paint);

    // Sağ üst köşe
    _drawPattern(canvas, Offset(size.width - 30, 10), cornerSize, paint);

    // Sol alt köşe
    _drawPattern(canvas, Offset(10, size.height - 30), cornerSize, paint);

    // Sağ alt köşe
    _drawPattern(
      canvas,
      Offset(size.width - 30, size.height - 30),
      cornerSize,
      paint,
    );
  }

  void _drawPattern(Canvas canvas, Offset center, double size, Paint paint) {
    // Basit oktagon/star motifi
    final path = Path();
    final angleStep = (2 * math.pi) / 8;

    for (int i = 0; i < 8; i++) {
      final angle = i * angleStep;
      final radius = i % 2 == 0 ? size * 0.5 : size * 0.3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) =>
      oldDelegate.rarity != rarity || oldDelegate.opacity != opacity;
}
