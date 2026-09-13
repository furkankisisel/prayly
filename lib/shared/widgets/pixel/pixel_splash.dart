import 'package:flutter/material.dart';

/// Simple pixel-art splash painter: a blocky crescent and pixel text below.
class PixelSplash extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? textColor;
  const PixelSplash({super.key, this.size = 140, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      // taller area previously hosted text; now we keep it tighter
      size: Size(size, size * 0.95),
      painter: _PixelSplashPainter(
        color: color ?? scheme.primary,
        textColor: textColor ?? scheme.onSurface,
      ),
    );
  }
}

class _PixelSplashPainter extends CustomPainter {
  final Color color;
  final Color textColor;
  _PixelSplashPainter({required this.color, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // textPaint previously used for pixel text which was removed.

    // Pixel grid parameters
    final grid = (size.width / 24).clamp(2.0, 12.0);
    final px = grid;

    // Draw a more recognizable pixel mosque
    final centerX = size.width / 2;
    final centerY = size.height * 0.42;

    // Determine grid origin so mosque is centered
    final totalWidth = px * 18; // width of mosque in pixels
    final originX = centerX - totalWidth / 2;
    final originY = centerY - px * 6;

    // Layered dome rows (wider at bottom, narrower at top)
    final domePattern = [8, 10, 12, 14]; // number of blocks per row
    for (int r = 0; r < domePattern.length; r++) {
      final cols = domePattern[r];
      final startCol = (18 - cols) ~/ 2;
      for (int c = 0; c < cols; c++) {
        final dx = originX + (startCol + c) * px;
        final dy = originY + r * px;
        canvas.drawRect(Rect.fromLTWH(dx, dy, px - 1, px - 1), paint);
      }
    }

    // Dome central finial (small crescent-like cap)
    final finialX = originX + 9 * px;
    final finialY = originY - px;
    canvas.drawRect(Rect.fromLTWH(finialX, finialY, px - 1, px - 1), paint);
    canvas.drawRect(
      Rect.fromLTWH(finialX + px / 2, finialY - px, px - 1, px - 1),
      paint,
    );

    // Base / walls under dome
    final baseTop = originY + domePattern.length * px + px;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 18; c++) {
        final dx = originX + c * px;
        final dy = baseTop + r * px;
        canvas.drawRect(Rect.fromLTWH(dx, dy, px - 1, px - 1), paint);
      }
    }

    // Central arched entrance: a vertical gap of 2 blocks, with an arch block above
    final entrCol = 8; // column index for left entrance block
    final entrX = originX + entrCol * px;
    // Clear two blocks for entrance (draw with transparent paint by skipping)
    // Draw arch (one block above the base top centered)
    final archX = originX + 9 * px;
    canvas.drawRect(
      Rect.fromLTWH(archX, baseTop - px, px - 1, px - 1),
      Paint()..color = color.withOpacity(0.95),
    );
    // Erase entrance blocks by drawing background-colored rectangles (approximation)
    canvas.drawRect(
      Rect.fromLTWH(entrX + px, baseTop, px - 1, px - 1),
      Paint()..color = Colors.transparent,
    );
    canvas.drawRect(
      Rect.fromLTWH(entrX + px, baseTop + px, px - 1, px - 1),
      Paint()..color = Colors.transparent,
    );

    // Tall minaret on the right with a balcony
    final minaretX = originX + 15 * px;
    final minaretTop = originY - px * 2;
    // minaret shaft
    for (int r = 0; r < 9; r++) {
      final dx = minaretX;
      final dy = minaretTop + r * px;
      canvas.drawRect(Rect.fromLTWH(dx, dy, px - 1, px - 1), paint);
    }
    // minaret balcony (wider band)
    final balconyY = minaretTop + 4 * px;
    for (int c = -1; c <= 1; c++) {
      canvas.drawRect(
        Rect.fromLTWH(minaretX + c * px, balconyY, px - 1, px - 1),
        paint,
      );
    }
    // minaret cap
    canvas.drawRect(
      Rect.fromLTWH(minaretX, minaretTop - px, px - 1, px - 1),
      paint,
    );
  }
  // No pixel text data here anymore.

  @override
  bool shouldRepaint(covariant _PixelSplashPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.textColor != textColor;
}
