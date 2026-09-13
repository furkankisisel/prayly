import 'package:flutter/material.dart';
import 'dart:io';
import '../../gen_l10n/app_localizations.dart';

class PixelProfileCard extends StatefulWidget {
  final String displayName;
  final String? avatarPath;
  final int level;
  final double totalXp;
  final double nextLevelXp;
  final double levelProgress;
  final String title;
  final Map<String, int> stats;

  const PixelProfileCard({
    super.key,
    required this.displayName,
    this.avatarPath,
    required this.level,
    required this.totalXp,
    required this.nextLevelXp,
    required this.levelProgress,
    required this.title,
    required this.stats,
  });

  @override
  State<PixelProfileCard> createState() => _PixelProfileCardState();
}

class _PixelProfileCardState extends State<PixelProfileCard>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _xpController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _xpController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // XP bar animasyonunu başlat
    _xpController.animateTo(widget.levelProgress);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPrayers = widget.stats['TOP'] ?? 0;
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _xpController]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _getLevelColor().withOpacity(
                  0.3 + (_glowController.value * 0.4),
                ),
                blurRadius: 20 + (_glowController.value * 20),
                spreadRadius: 5 + (_glowController.value * 10),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getLevelColor().withOpacity(0.8),
                width: 4,
              ),
              color: Colors.black.withOpacity(0.85),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Avatar (square, fits image)
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _getLevelColor(), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _getLevelColor().withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _buildAvatar(),
                  ),
                ),

                const SizedBox(height: 8),

                // Name
                Text(
                  widget.displayName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(1, 1)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Level Badge (fill follows theme primary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withOpacity(0.55),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.levelAbbr} ${widget.level}',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // XP Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.progressLabel,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: scheme.primary, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: Stack(
                          children: [
                            Container(color: Colors.black.withOpacity(0.3)),
                            FractionallySizedBox(
                              widthFactor: _xpController.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      scheme.primary.withOpacity(0.85),
                                      scheme.primary,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Total Prayers
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getLevelColor().withOpacity(0.55),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TOPLAM NAMAZ',
                        style: TextStyle(
                          color: _getLevelColor(),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalPrayers',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    final scheme = Theme.of(context).colorScheme;
    ImageProvider? avatarImage;
    if (widget.avatarPath != null) {
      avatarImage = widget.avatarPath!.startsWith('assets/')
          ? AssetImage(widget.avatarPath!)
          : FileImage(File(widget.avatarPath!));
    }

    if (avatarImage != null) {
      return Image(image: avatarImage, fit: BoxFit.cover);
    } else {
      return Container(
        color: scheme.primary.withOpacity(0.2),
        child: Icon(Icons.person, color: scheme.primary, size: 25),
      );
    }
  }

  Color _getLevelColor() {
    // Level based colors
    if (widget.level >= 50) return const Color(0xFFFF4444); // Epic Red
    if (widget.level >= 30) return const Color(0xFFA855F7); // Legendary Purple
    if (widget.level >= 20) return const Color(0xFF3B82F6); // Mysterious Blue
    if (widget.level >= 10) return const Color(0xFFFFD700); // Pro Gold
    if (widget.level >= 5) return const Color(0xFFC0C0C0); // Nadir Silver
    return const Color(0xFFCD853F); // Sıradan Bronze
  }
}
