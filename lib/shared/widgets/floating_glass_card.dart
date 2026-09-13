import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../gen_l10n/app_localizations.dart';
import 'dart:ui';
import 'card_rarity.dart';

class FloatingGlassCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final CardRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const FloatingGlassCard({
    super.key,
    required this.title,
    required this.icon,
    required this.rarity,
    required this.xpValue,
    required this.progressValue,
    this.progressType = 'streak',
    this.onTap,
    this.width,
    this.height,
  });

  @override
  State<FloatingGlassCard> createState() => _FloatingGlassCardState();
}

class _FloatingGlassCardState extends State<FloatingGlassCard>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late AnimationController _hoverController;
  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _breathController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _glowController.dispose();
    _hoverController.dispose();
    _breathController.dispose();
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
          animation: Listenable.merge([
            _floatingController,
            _glowController,
            _hoverController,
            _breathController,
          ]),
          builder: (context, child) {
            final floatingOffset =
                math.sin(_floatingController.value * 2 * math.pi) * 8;
            final hoverScale = 1.0 + (_hoverController.value * 0.05);
            final breathScale =
                1.0 + (math.sin(_breathController.value * 2 * math.pi) * 0.02);

            return Transform.translate(
              offset: Offset(0, floatingOffset),
              child: Transform.scale(
                scale: hoverScale * breathScale,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: Stack(
                    children: [
                      // Glow effect background
                      _buildGlowBackground(),
                      // Glass card
                      _buildGlassCard(),
                      // Content
                      _buildCardContent(),
                      // Floating particles
                      _buildFloatingParticles(),
                    ],
                  ),
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

  Widget _buildGlowBackground() {
    final colors = _getRarityColors(widget.rarity);
    final glowIntensity = 0.3 + (_glowController.value * 0.4);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(glowIntensity),
            blurRadius: 40 + (_hoverController.value * 20),
            spreadRadius: 8 + (_hoverController.value * 12),
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colors.secondary.withOpacity(glowIntensity * 0.7),
            blurRadius: 80,
            spreadRadius: 15,
            offset: const Offset(0, 20),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Rarity indicator
          _buildRarityIndicator(),

          const SizedBox(height: 16),

          // Title
          _buildFloatingTitle(),

          const SizedBox(height: 24),

          // Main icon with floating effect
          _buildFloatingIcon(),

          const Spacer(),

          // Stats in glass containers
          _buildGlassStats(),

          const SizedBox(height: 16),

          // Progress with liquid effect
          _buildLiquidProgress(),
        ],
      ),
    );
  }

  Widget _buildRarityIndicator() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colors.primary.withOpacity(0.8),
            colors.secondary.withOpacity(0.6),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        widget.rarity.displayName(context).toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTitle() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final titleFloat =
            math.sin((_floatingController.value + 0.3) * 2 * math.pi) * 3;

        return Transform.translate(
          offset: Offset(0, titleFloat),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.3,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
                Shadow(
                  color: _getRarityColors(
                    widget.rarity,
                  ).primary.withOpacity(0.6),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcon() {
    final colors = _getRarityColors(widget.rarity);

    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final iconFloat =
            math.sin((_floatingController.value + 0.6) * 2 * math.pi) * 5;
        final iconScale =
            1.0 + (math.sin(_breathController.value * 2 * math.pi) * 0.1);

        return Transform.translate(
          offset: Offset(0, iconFloat),
          child: Transform.scale(
            scale: iconScale,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.primary.withOpacity(0.4),
                    colors.secondary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                size: 40,
                color: Colors.white,
                shadows: [Shadow(color: colors.primary, blurRadius: 20)],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassStats() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Row(
          children: [
            Expanded(
              child: _buildGlassStat(
                l10n.xp,
                widget.xpValue.toString(),
                Icons.auto_awesome,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGlassStat(
                widget.progressType == 'streak'
                    ? l10n.streak.toUpperCase()
                    : l10n.statisticsTotal.toUpperCase(),
                widget.progressValue.toString(),
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

  Widget _buildGlassStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(0.9)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidProgress() {
    final colors = _getRarityColors(widget.rarity);
    final progress = (widget.progressValue / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'İlerleme',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: colors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.2),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary,
                              colors.secondary,
                              colors.primary,
                            ],
                            stops: [0.0, _glowController.value, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final angle =
                (_floatingController.value * 2 * math.pi) +
                (index * math.pi / 3);
            final radius = 60.0 + (index * 20);
            final x = 100 + radius * math.cos(angle) * 0.3;
            final y = 150 + radius * math.sin(angle) * 0.2;
            final opacity = (math.sin(angle * 2) + 1) / 2 * 0.6;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 3 + (index % 2),
                height: 3 + (index % 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(opacity),
                  boxShadow: [
                    BoxShadow(
                      color: _getRarityColors(
                        widget.rarity,
                      ).primary.withOpacity(0.5),
                      blurRadius: 6,
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
        );
      case CardRarity.silver:
        return CardColors(
          primary: const Color(0xFFC0C0C0),
          secondary: const Color(0xFF708090),
        );
      case CardRarity.gold:
        return CardColors(
          primary: const Color(0xFFFFD700),
          secondary: const Color(0xFFB8860B),
        );
      case CardRarity.platinum:
        return CardColors(
          primary: const Color(0xFF00CED1),
          secondary: const Color(0xFF20B2AA),
        );
      case CardRarity.diamond:
        return CardColors(
          primary: const Color(0xFFB9F2FF),
          secondary: const Color(0xFF87CEEB),
        );
      case CardRarity.nur:
        return CardColors(
          primary: const Color(0xFFF0E68C),
          secondary: const Color(0xFFFFE4B5),
        );
      case CardRarity.sidre:
        return CardColors(
          primary: const Color(0xFF9400D3),
          secondary: const Color(0xFF8A2BE2),
        );
    }
  }
}

class CardColors {
  final Color primary;
  final Color secondary;

  CardColors({required this.primary, required this.secondary});
}
