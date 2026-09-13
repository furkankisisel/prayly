import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'card_rarity.dart';

class NeonOutlineCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final CardRarity rarity;
  final int xpValue;
  final int progressValue;
  final String progressType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const NeonOutlineCard({
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
  State<NeonOutlineCard> createState() => _NeonOutlineCardState();
}

class _NeonOutlineCardState extends State<NeonOutlineCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late AnimationController _hoverController;
  late AnimationController _glitchController;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    _hoverController.dispose();
    _glitchController.dispose();
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
        onTap: () {
          widget.onTap?.call();
          _triggerGlitch();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseController,
            _scanController,
            _hoverController,
            _glitchController,
          ]),
          builder: (context, child) {
            final hoverScale = 1.0 + (_hoverController.value * 0.03);
            final glitchOffset = _glitchController.value * 2;

            return Transform.scale(
              scale: hoverScale,
              child: Transform.translate(
                offset: Offset(
                  math.sin(_glitchController.value * 20) * glitchOffset,
                  0,
                ),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: Stack(
                    children: [
                      // Neon outline layers
                      _buildNeonOutlines(),
                      // Card body
                      _buildCardBody(),
                      // Scan line effect
                      _buildScanLine(),
                      // Content
                      _buildCardContent(),
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
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _triggerGlitch() {
    _glitchController.forward().then((_) {
      _glitchController.reverse();
    });
  }

  Widget _buildNeonOutlines() {
    final colors = _getRarityColors(widget.rarity);
    final pulseValue = _pulseController.value;
    final hoverIntensity = _hoverController.value;

    return Stack(
      children: [
        // Outer glow
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withOpacity(
                  0.3 + (pulseValue * 0.4) + (hoverIntensity * 0.3),
                ),
                blurRadius: 30 + (pulseValue * 20) + (hoverIntensity * 15),
                spreadRadius: 5 + (pulseValue * 8) + (hoverIntensity * 5),
              ),
            ],
          ),
        ),
        // Main border
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.primary.withOpacity(0.8 + (pulseValue * 0.2)),
              width: 2 + (hoverIntensity * 1),
            ),
          ),
        ),
        // Inner bright line
        Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: colors.accent.withOpacity(0.6 + (pulseValue * 0.4)),
              width: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardBody() {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF000000),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF000000),
            const Color(0xFF050505),
          ],
        ),
      ),
    );
  }

  Widget _buildScanLine() {
    final colors = _getRarityColors(widget.rarity);

    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        final scanPosition = _scanController.value;

        return Positioned(
          top: (widget.height ?? 300) * scanPosition - 2,
          left: 6,
          right: 6,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  colors.accent.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: colors.accent.withOpacity(0.6), blurRadius: 8),
              ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rarity chip
          _buildRarityChip(),

          const SizedBox(height: 16),

          // Title with glitch effect
          _buildGlitchTitle(),

          const SizedBox(height: 20),

          // Minimalist icon
          _buildMinimalIcon(),

          const Spacer(),

          // Clean stats
          _buildCleanStats(),

          const SizedBox(height: 16),

          // Progress line
          _buildProgressLine(),
        ],
      ),
    );
  }

  Widget _buildRarityChip() {
    final colors = _getRarityColors(widget.rarity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colors.primary.withOpacity(0.8), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.rarity.displayName(context).toUpperCase(),
        style: TextStyle(
          color: colors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildGlitchTitle() {
    final colors = _getRarityColors(widget.rarity);

    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        final glitchIntensity = _glitchController.value;

        return Stack(
          children: [
            // Main text
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            // Glitch layers
            if (glitchIntensity > 0) ...[
              Transform.translate(
                offset: Offset(-2 * glitchIntensity, 0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: colors.primary.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(2 * glitchIntensity, 0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: colors.accent.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMinimalIcon() {
    final colors = _getRarityColors(widget.rarity);

    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = _pulseController.value;

          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primary.withOpacity(0.5 + (pulse * 0.3)),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 36,
                color: colors.primary.withOpacity(0.9),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCleanStats() {
    final colors = _getRarityColors(widget.rarity);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('XP', widget.xpValue.toString(), colors),
        Container(width: 1, height: 30, color: colors.primary.withOpacity(0.3)),
        _buildStatItem(
          widget.progressType.toUpperCase(),
          widget.progressValue.toString(),
          colors,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, CardColors colors) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: colors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine() {
    final colors = _getRarityColors(widget.rarity);
    final progress = (widget.progressValue / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROGRESS',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: colors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (progress * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.6),
                        blurRadius: 4,
                      ),
                    ],
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
  }

  CardColors _getRarityColors(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.bronze:
        return CardColors(
          primary: const Color(0xFFFF6B35),
          accent: const Color(0xFFFF9F1C),
        );
      case CardRarity.silver:
        return CardColors(
          primary: const Color(0xFF64FFDA),
          accent: const Color(0xFF1DE9B6),
        );
      case CardRarity.gold:
        return CardColors(
          primary: const Color(0xFFFFD700),
          accent: const Color(0xFFFFF176),
        );
      case CardRarity.platinum:
        return CardColors(
          primary: const Color(0xFF00E5FF),
          accent: const Color(0xFF84FFFF),
        );
      case CardRarity.diamond:
        return CardColors(
          primary: const Color(0xFFE1BEE7),
          accent: const Color(0xFFF3E5F5),
        );
      case CardRarity.nur:
        return CardColors(
          primary: const Color(0xFFFFF59D),
          accent: const Color(0xFFFFFDE7),
        );
      case CardRarity.sidre:
        return CardColors(
          primary: const Color(0xFF9C27B0),
          accent: const Color(0xFFE1BEE7),
        );
    }
  }
}

class CardColors {
  final Color primary;
  final Color accent;

  CardColors({required this.primary, required this.accent});
}
