import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'card_rarity.dart';
import '../../../../gen_l10n/app_localizations.dart';

class ModernCollectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final IconData? overlayIcon;
  final CardRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ModernCollectionCard({
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
  State<ModernCollectionCard> createState() => _ModernCollectionCardState();
}

class _ModernCollectionCardState extends State<ModernCollectionCard>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _glowController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.width ?? 200.0;
    final cardHeight = widget.height ?? 300.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _glowController]),
          builder: (context, child) {
            final hoverValue = _hoverController.value;
            final glowValue = _glowController.value;

            return Transform.scale(
              scale: 1.0 + (hoverValue * 0.05),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                child: Stack(
                  children: [
                    // Arka plan gradient orbital
                    _buildOrbitalBackground(),
                    // Ana kart gövdesi
                    _buildCardBody(hoverValue, glowValue),
                    // Neon border efekti
                    _buildNeonBorder(glowValue),
                    // İçerik
                    _buildCardContent(),
                    if (widget.overlayIcon != null)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Icon(
                            widget.overlayIcon,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    // Floating partiküller
                    _buildFloatingParticles(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  Widget _buildOrbitalBackground() {
    final colors = _getRarityColors(widget.rarity);

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: SweepGradient(
              center: Alignment.center,
              startAngle: _rotationController.value * 2 * math.pi,
              colors: [
                colors.primary,
                colors.secondary,
                colors.accent,
                colors.primary,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBody(double hoverValue, double glowValue) {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF1A1A1A),
            const Color(0xFF0F0F0F),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.3 + (glowValue * 0.4)),
            blurRadius: 20 + (hoverValue * 20),
            spreadRadius: 2 + (hoverValue * 5),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.transparent,
              Colors.white.withOpacity(0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonBorder(double glowValue) {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.accent.withOpacity(0.5 + (glowValue * 0.5)),
          width: 1 + (glowValue * 2),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Rarity hexagon
          _buildHexagonRarity(),
          const SizedBox(height: 12),

          // Başlık
          _buildNeonTitle(),

          const SizedBox(height: 12),

          // Ana ikon orbital (smaller to avoid overflow)
          _buildOrbitalIcon(),

          // Small spacer instead of large flexible space so content stays within card
          const SizedBox(height: 8),

          // Stats grid (flexible to shrink when needed)
          _buildStatsGrid(),

          const SizedBox(height: 10),

          // Progress bar
          _buildNeonProgressBar(),
        ],
      ),
    );
  }

  Widget _buildHexagonRarity() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(50, 50),
            painter: HexagonPainter(
              color: colors.primary,
              glowColor: colors.accent,
            ),
          ),
          Builder(
            builder: (context) {
              final t = Theme.of(context).textTheme;
              return Text(
                widget.rarity.displayName(context)[0].toUpperCase(),
                style: t.titleSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: colors.accent, blurRadius: 10)],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeonTitle() {
    final colors = _getRarityColors(widget.rarity);

    return Builder(
      builder: (context) {
        final t = Theme.of(context).textTheme;
        final style = t.titleMedium?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
          height: 1.2,
          shadows: [
            Shadow(color: colors.accent.withOpacity(0.8), blurRadius: 15),
            Shadow(
              color: Colors.black,
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        );

        return Text(
          widget.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      },
    );
  }

  Widget _buildOrbitalIcon() {
    final colors = _getRarityColors(widget.rarity);

    // Render a square icon area under the title. Keeps the same outer size
    // but places the icon inside a bordered square for a clearer layout.
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.accent, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.accent.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Icon(widget.icon, size: 28, color: colors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final colors = _getRarityColors(widget.rarity);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: _buildStatCube(
                  'XP',
                  widget.xpValue.toString(),
                  Icons.auto_awesome,
                  colors,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: Center(
                child: _buildStatCube(
                  widget.progressType == 'streak'
                      ? l10n.streak.toUpperCase()
                      : l10n.statisticsTotal.toUpperCase(),
                  widget.progressValue.toString(),
                  widget.progressType == 'streak'
                      ? Icons.local_fire_department
                      : Icons.format_list_numbered,
                  colors,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCube(
    String label,
    String value,
    IconData icon,
    CardColors colors,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 40,
        maxWidth: 56,
        minHeight: 40,
        maxHeight: 48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withOpacity(0.2),
            colors.secondary.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: colors.accent.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: colors.accent),
          const SizedBox(height: 2),
          Builder(
            builder: (context) {
              final t = Theme.of(context).textTheme;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: t.titleSmall?.copyWith(
                      fontSize: 12,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    label,
                    style: t.labelSmall?.copyWith(
                      fontSize: 9,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeonProgressBar() {
    final colors = _getRarityColors(widget.rarity);
    final progress = (widget.progressValue / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                final t = Theme.of(context).textTheme;
                final l10n = AppLocalizations.of(context)!;
                return Text(
                  l10n.detailProgress,
                  style: t.labelMedium?.copyWith(color: colors.textSecondary),
                );
              },
            ),
            Builder(
              builder: (context) {
                final t = Theme.of(context).textTheme;
                return Text(
                  '${(progress * 100).toInt()}%',
                  style: t.labelMedium?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(5, (index) {
            final angle =
                (_rotationController.value * 2 * math.pi) +
                (index * math.pi / 2.5);
            final radius = 80.0 + (index * 15);
            final x = 100 + radius * math.cos(angle);
            final y = 150 + radius * math.sin(angle) * 0.5;
            final color = _getRarityColors(
              widget.rarity,
            ).accent.withOpacity(0.6);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: _getRarityColors(widget.rarity).accent,
                      blurRadius: 8,
                      spreadRadius: 1,
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

  CardColors _getRarityColors(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.bronze:
        return CardColors(
          primary: const Color(0xFFCD853F),
          secondary: const Color(0xFF8B4513),
          accent: const Color(0xFFFFE4B5),
          textPrimary: const Color(0xFFFFE4B5),
          textSecondary: const Color(0xFFCD853F),
        );
      case CardRarity.silver:
        return CardColors(
          primary: const Color(0xFFC0C0C0),
          secondary: const Color(0xFF708090),
          accent: const Color(0xFFFFFFFF),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFFC0C0C0),
        );
      case CardRarity.gold:
        return CardColors(
          primary: const Color(0xFFFFD700),
          secondary: const Color(0xFFB8860B),
          accent: const Color(0xFFFFE55C),
          textPrimary: const Color(0xFF2F2F2F),
          textSecondary: const Color(0xFFB8860B),
        );
      case CardRarity.platinum:
        return CardColors(
          primary: const Color(0xFF00CED1),
          secondary: const Color(0xFF4A5568),
          accent: const Color(0xFF00FFFF),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFF00CED1),
        );
      case CardRarity.diamond:
        return CardColors(
          primary: const Color(0xFFB9F2FF),
          secondary: const Color(0xFF1A202C),
          accent: const Color(0xFFE0F7FF),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFFB9F2FF),
        );
      case CardRarity.nur:
        return CardColors(
          primary: const Color(0xFFF0E68C),
          secondary: const Color(0xFFFFF8DC),
          accent: const Color(0xFFFFFFE0),
          textPrimary: const Color(0xFF8B4513),
          textSecondary: const Color(0xFFDEB887),
        );
      case CardRarity.sidre:
        return CardColors(
          primary: const Color(0xFF9400D3),
          secondary: const Color(0xFF00CED1),
          accent: const Color(0xFFFFD700),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFFFFD700),
        );
    }
  }
}

class CardColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;

  CardColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color glowColor;

  HexagonPainter({required this.color, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = _createHexagonPath(size);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  Path _createHexagonPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
