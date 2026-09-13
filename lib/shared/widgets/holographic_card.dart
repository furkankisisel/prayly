import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../gen_l10n/app_localizations.dart';
import 'card_rarity.dart';

class HolographicCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final CardRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const HolographicCard({
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
  State<HolographicCard> createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard>
    with TickerProviderStateMixin {
  late AnimationController _rainbowController;
  late AnimationController _waveController;
  late AnimationController _hoverController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();

    _rainbowController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rainbowController.dispose();
    _waveController.dispose();
    _hoverController.dispose();
    _sparkleController.dispose();
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
            _rainbowController,
            _waveController,
            _hoverController,
            _sparkleController,
          ]),
          builder: (context, child) {
            final hoverScale = 1.0 + (_hoverController.value * 0.08);

            return Transform.scale(
              scale: hoverScale,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                child: Stack(
                  children: [
                    // Holographic background
                    _buildHolographicBackground(),
                    // Card content area
                    _buildCardContentArea(),
                    // Wave overlay
                    _buildWaveOverlay(),
                    // Content
                    _buildCardContent(),
                    // Sparkles
                    _buildSparkles(),
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

  Widget _buildHolographicBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: SweepGradient(
          center: Alignment.center,
          startAngle: _rainbowController.value * 2 * math.pi,
          colors: const [
            Color(0xFFFF6B6B),
            Color(0xFFFFE66D),
            Color(0xFF4ECDC4),
            Color(0xFF45B7D1),
            Color(0xFF9B59B6),
            Color(0xFFE74C3C),
            Color(0xFFFF6B6B),
          ],
          stops: const [0.0, 0.15, 0.3, 0.45, 0.6, 0.85, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 30 + (_hoverController.value * 20),
            spreadRadius: 5 + (_hoverController.value * 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContentArea() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E).withOpacity(0.95),
            const Color(0xFF16213E).withOpacity(0.95),
            const Color(0xFF0F1419).withOpacity(0.95),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveOverlay() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_waveController.value * 2 * math.pi),
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
                Colors.white.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top group: badge + title
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnimatedRarityBadge(),
              const SizedBox(height: 12),
              _buildRainbowTitle(),
            ],
          ),

          // Middle icon (reduced size to avoid overflow)
          SizedBox(height: 96, child: Center(child: _buildHolographicIcon())),

          // Bottom group: stats + progress
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGlowingStats(),
              const SizedBox(height: 12),
              _buildRainbowProgress(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRarityBadge() {
    return AnimatedBuilder(
      animation: _rainbowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: GradientRotation(
                _rainbowController.value * 2 * math.pi,
              ),
              colors: const [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            widget.rarity.displayName(context).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRainbowTitle() {
    return AnimatedBuilder(
      animation: _rainbowController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: GradientRotation(_rainbowController.value * math.pi),
              colors: const [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
                Color(0xFF9B59B6),
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolographicIcon() {
    return AnimatedBuilder(
      animation: _rainbowController,
      builder: (context, child) {
        return Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              center: Alignment.center,
              startAngle: _rainbowController.value * 2 * math.pi,
              colors: const [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
                Color(0xFF9B59B6),
                Color(0xFFFF6B6B),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
            child: Icon(
              widget.icon,
              size: 36,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.white, blurRadius: 20)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowingStats() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Row(
          children: [
            Expanded(
              child: _buildGlowingStat(
                l10n.xp,
                widget.xpValue.toString(),
                Icons.auto_awesome,
                const Color(0xFFFFE66D),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGlowingStat(
                widget.progressType == 'streak'
                    ? l10n.streak.toUpperCase()
                    : l10n.statisticsTotal.toUpperCase(),
                widget.progressValue.toString(),
                widget.progressType == 'streak'
                    ? Icons.local_fire_department
                    : Icons.trending_up,
                const Color(0xFF4ECDC4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlowingStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        final sparkle = _sparkleController.value;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.2 + (sparkle * 0.1)),
                color.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.5 + (sparkle * 0.3)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
                shadows: [Shadow(color: color, blurRadius: 10)],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: color, blurRadius: 10)],
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRainbowProgress() {
    final progress = (widget.progressValue / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'İlerleme',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
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
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                AnimatedBuilder(
                  animation: _rainbowController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            transform: GradientRotation(
                              _rainbowController.value * math.pi,
                            ),
                            colors: const [
                              Color(0xFFFF6B6B),
                              Color(0xFFFFE66D),
                              Color(0xFF4ECDC4),
                              Color(0xFF45B7D1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
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

  Widget _buildSparkles() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final angle =
                (_sparkleController.value * 2 * math.pi) +
                (index * math.pi / 4);
            final radius = 80.0 + (index * 15);
            final x = 100 + radius * math.cos(angle) * 0.4;
            final y = 150 + radius * math.sin(angle) * 0.3;
            final opacity = (math.sin(angle * 3) + 1) / 2;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(opacity),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(opacity * 0.8),
                      blurRadius: 8,
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
}
