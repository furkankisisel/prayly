import 'package:flutter/material.dart';
import '../../core/theme/tokens/app_colors.dart';

/// Vektörel uygulama logosu (hilal + yıldızlar) - asset yerine geçici.
class AppLogo extends StatelessWidget {
  final double size;
  final bool glow;
  const AppLogo({super.key, this.size = 64, this.glow = false});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return CustomPaint(
      size: Size.square(size),
      painter: _CrescentPainter(
        gold: AppColors.gold,
        glow: glow,
        dark: brightness == Brightness.dark,
      ),
    );
  }
}

class _CrescentPainter extends CustomPainter {
  final Color gold;
  final bool glow;
  final bool dark;
  _CrescentPainter({
    required this.gold,
    required this.glow,
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * .48;
    final paint = Paint()..color = gold;

    if (glow) {
      canvas.drawCircle(
        center,
        radius * 1.05,
        Paint()
          ..color = gold.withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Outer circle (full)
    canvas.drawCircle(center, radius, paint);
    // Inner subtraction circle to carve crescent
    final cutPaint = Paint()..blendMode = BlendMode.dstOut;
    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: center.translate(radius * .35, 0),
          radius: radius * .9,
        ),
      );
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(center, radius, paint);
    canvas.drawPath(path, cutPaint);
    canvas.restore();

    // Stars
    void star(Offset o, double r) {
      final starPaint = Paint()..color = gold;
      final p = Path();
      for (int i = 0; i < 4; i++) {
        final angle = i * (3.14159265 / 2);
        p.moveTo(o.dx, o.dy);
        p.lineTo(
          o.dx + r * MathUtils.cos(angle),
          o.dy + r * MathUtils.sin(angle),
        );
      }
      canvas.drawPath(
        p,
        starPaint
          ..strokeWidth = r * .6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    star(center.translate(radius * .9, -radius * .1), radius * .28);
    star(center.translate(radius * .55, radius * .35), radius * .16);
    star(center.translate(radius * 1.15, radius * .45), radius * .12);
  }

  @override
  bool shouldRepaint(covariant _CrescentPainter oldDelegate) =>
      oldDelegate.gold != gold ||
      oldDelegate.glow != glow ||
      oldDelegate.dark != dark;
}

class MathUtils {
  static double sin(double v) => MathUtils._tableSinCos(v).$1;
  static double cos(double v) => MathUtils._tableSinCos(v).$2;

  // Simple approximation (Taylor truncated) - sufficient for decorative stars (avoid importing dart:math repeatedly in hot reload snippet)
  static (double, double) _tableSinCos(double x) {
    // Normalize
    const pi = 3.1415926535897932;
    x = x % (2 * pi);
    // Use dart:math would be simpler; kept lightweight.
    double sin = x - (x * x * x) / 6 + (x * x * x * x * x) / 120; // rough
    double cos = 1 - (x * x) / 2 + (x * x * x * x) / 24; // rough
    return (sin, cos);
  }
}
