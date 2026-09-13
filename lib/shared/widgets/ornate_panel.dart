import 'package:flutter/material.dart';
import '../../core/theme/extensions/panel_theme.dart';

/// Panel with gold border and slightly ornate corner effect using segmented border.
class OrnatePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? background;
  final Color? borderColor;

  const OrnatePanel({
    super.key,
    required this.child,
    this.padding,
    this.background,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PanelTheme>()!;
    final color = background ?? theme.backgroundColor;
    final bColor = borderColor ?? theme.borderColor;
    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: _OrnateBorder(
          color: bColor,
          radius: theme.radius,
          strokeWidth: 2,
        ),
      ),
      padding: padding ?? theme.padding,
      child: child,
    );
  }
}

class _OrnateBorder extends OutlinedBorder {
  final Color color;
  final double radius;
  final double strokeWidth;

  const _OrnateBorder({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  OutlinedBorder copyWith({BorderSide? side}) => _OrnateBorder(
    color: side?.color ?? color,
    radius: radius,
    strokeWidth: side?.width ?? strokeWidth,
  );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _buildPath(rect.deflate(strokeWidth));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _buildPath(rect);

  Path _buildPath(Rect rect) {
    final r = Radius.circular(radius);
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: r,
        topRight: r,
        bottomLeft: r,
        bottomRight: r,
      ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is _OrnateBorder &&
      other.color == color &&
      other.radius == radius &&
      other.strokeWidth == strokeWidth;

  @override
  int get hashCode => Object.hash(color, radius, strokeWidth);

  @override
  ShapeBorder scale(double t) => _OrnateBorder(
    color: color,
    radius: radius * t,
    strokeWidth: strokeWidth * t,
  );
}
