import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A pixel-styled TabBar replacement.
///
/// This widget keeps the same surface API as before but paints a pixel-art
/// indicator (small square "pixels") and uses the theme's ColorScheme for
/// borders and indicator colors so it adapts to light/dark themes.
class PixelTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? controller;
  final List<Tab> tabs;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? height;

  const PixelTabBar({
    super.key,
    this.controller,
    required this.tabs,
    this.backgroundColor,
    this.indicatorColor,
    this.height,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? 72);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? Colors.transparent;
    final color = indicatorColor ?? scheme.primary;

    // readable label colors
    final selectedLabelColor = color;
    final unselectedLabelColor = scheme.onSurface.withAlpha(
      (0.72 * 255).round(),
    );

    // try to resolve an active TabController: prefer provided controller,
    // otherwise fall back to DefaultTabController in the tree.
    final TabController? ctrl = controller ?? DefaultTabController.of(context);

    // taller tab bar supports icon + label stacked layout

    return Container(
      // allow the bar to be at most the preferred height but permit it to
      // shrink when the app's layout provides a smaller height to avoid
      // RenderFlex overflow errors.
      constraints: BoxConstraints(maxHeight: preferredSize.height),
      // no horizontal padding so items can reach the very edges
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: scheme.primary, width: 2)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(tabs.length, (i) {
            final Tab t = tabs[i];

            return Expanded(
              child: _PixelTabItem(
                index: i,
                controller: ctrl,
                label: (t.text ?? '').toUpperCase(),
                icon: t.icon,
                selectedColor: selectedLabelColor,
                unselectedColor: unselectedLabelColor,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _PixelTabItem extends StatelessWidget {
  final int index;
  final TabController? controller;
  final String label;
  final Widget? icon;
  final Color selectedColor;
  final Color unselectedColor;

  const _PixelTabItem({
    required this.index,
    required this.controller,
    required this.label,
    this.icon,
    required this.selectedColor,
    required this.unselectedColor,
  });

  bool get _isInteractive => controller != null;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScaleFactorOf(context);

    return GestureDetector(
      onTap: () {
        if (controller != null) {
          controller!.animateTo(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: AnimatedBuilder(
          animation: controller ?? ValueNotifier<int>(0),
          builder: (ctx, _) {
            final current = controller?.index ?? 0;
            final selected = current == index;

            final labelColor = selected ? selectedColor : unselectedColor;

            return LayoutBuilder(
              builder: (ctx2, constraints) {
                final availH =
                    (constraints.maxHeight.isFinite &&
                        constraints.maxHeight > 0)
                    ? constraints.maxHeight
                    : 72.0;

                // compute a scale factor relative to a target comfortable height
                final scaleFactor = math.min(1.0, availH / 40.0);

                // slightly smaller base sizes for a more compact bar
                final iconSize = icon != null
                    ? (18.0 * scaleFactor).clamp(12.0, 18.0)
                    : 0.0;
                final fontSize = (11.0 * scaleFactor).clamp(9.0, 11.0) * scale;

                // stacked layout: icon on top, label below. Use fixed spacing so the
                // taller bar shows both comfortably.
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      IconTheme(
                        data: IconThemeData(color: labelColor, size: iconSize),
                        child: icon!,
                      ),
                      SizedBox(height: math.max(2.0, 4.0 * scaleFactor)),
                    ],
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 96),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          fontSize: fontSize,
                          color: labelColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
