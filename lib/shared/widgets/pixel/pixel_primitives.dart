import 'package:flutter/material.dart';

// Tiny pixel primitives to reuse across the app

/// Provides the effective background color for descendants so labels can
/// choose a readable foreground automatically.
class PixelBackground extends InheritedWidget {
  final Color background;
  const PixelBackground({
    super.key,
    required this.background,
    required super.child,
  });

  static Color? of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<PixelBackground>();
    return w?.background;
  }

  @override
  bool updateShouldNotify(covariant PixelBackground oldWidget) =>
      oldWidget.background != background;
}

class PixelBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final bool outlineOnly;

  const PixelBox({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(6),
    this.color,
    this.borderColor,
    this.borderWidth = 2,
    this.radius = 2,
    this.outlineOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = outlineOnly
        ? Colors.transparent
        : (color ?? Colors.black.withValues(alpha: 0.6));

    final decorated = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? scheme.primary,
          width: borderWidth,
        ),
        boxShadow: outlineOnly
            ? null
            : const [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.black,
                  blurRadius: 0,
                ),
              ],
      ),
      padding: padding,
      child: child == null
          ? null
          : PixelBackground(background: bgColor, child: child!),
    );

    return decorated;
  }
}

class PixelLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final TextAlign textAlign;

  const PixelLabel(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 10,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaler.scale(1.0);
    // Automatic color selection: explicit color wins. Otherwise try to
    // infer from nearest PixelBackground. If background is fully
    // transparent, fall back to theme's onSurface color.
    final bg = PixelBackground.of(context);
    Color resolved;
    if (color != null) {
      resolved = color!;
    } else if (bg != null && bg.opacity > 0) {
      // choose black or white depending on luminance for contrast
      resolved = bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    } else {
      resolved = Theme.of(context).colorScheme.onSurface;
    }

    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: resolved,
        fontFamily: 'monospace',
        height: 1.1,
        fontSize: fontSize * scale,
        fontWeight: FontWeight.w900,
        shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1))],
      ),
    );
  }
}

class PixelButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final Color? textColor;

  const PixelButton(
    this.label, {
    super.key,
    this.onPressed,
    this.busy = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final defaultText = brightness == Brightness.dark
        ? Colors.white
        : scheme.onPrimary;

    return InkWell(
      onTap: busy ? null : onPressed,
      child: PixelBox(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: scheme.primary.withValues(alpha: 0.15),
        borderColor: scheme.primary,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy) ...[
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 6),
            ],
            PixelLabel(label, color: textColor ?? defaultText, fontSize: 10),
          ],
        ),
      ),
    );
  }
}

class PixelPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool outlineOnly;

  const PixelPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.outlineOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PixelBox(
      padding: padding,
      color: outlineOnly
          ? Colors.transparent
          : scheme.surface.withValues(alpha: 0.7),
      borderColor: scheme.primary,
      outlineOnly: outlineOnly,
      child: child,
    );
  }
}

/// Reusable navigation tile that follows the app's pixel style.
class PixelNavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final Color? borderColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const PixelNavTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.color,
    this.borderColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = color ?? scheme.primary.withValues(alpha: .15);
    final bColor = borderColor ?? scheme.primary;

    return InkWell(
      onTap: onTap,
      child: PixelBox(
        padding: const EdgeInsets.all(12),
        borderColor: bColor,
        color: bg,
        child: Row(
          children: [
            Icon(icon, size: 18, color: bColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PixelLabel(title, fontSize: 12, color: titleColor),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    PixelLabel(
                      subtitle!,
                      fontSize: 9,
                      color:
                          subtitleColor ??
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.outline,
                ),
          ],
        ),
      ),
    );
  }
}
