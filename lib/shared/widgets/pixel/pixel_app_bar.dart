import 'package:flutter/material.dart';

import 'pixel_primitives.dart';

/// A pixel-styled AppBar replacement.
class PixelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? borderColor;

  const PixelAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.bottom,
    this.backgroundColor,
    this.borderColor,
  });

  // Keep preferred height in sync with actual header height (72) to avoid
  // layout mismatches when combined with a bottom TabBar.
  double get _toolbarHeight => (title != null || titleWidget != null) ? 80 : 0;

  @override
  Size get preferredSize =>
      Size.fromHeight(_toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? Colors.transparent;
    final outline = borderColor ?? scheme.primary;

    final header = (title != null || titleWidget != null)
        ? Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: bg,
              border: Border(bottom: BorderSide(color: outline, width: 2)),
            ),
            child: PixelBackground(
              background: bg,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    // Leading (optional)
                    leading ?? const SizedBox(width: 8),
                    const SizedBox(width: 4),

                    // Title takes remaining space
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: titleWidget ?? PixelLabel(title!, fontSize: 13),
                      ),
                    ),

                    // Actions: place inside a flexible, horizontally scrollable
                    // container so excessive action widgets don't cause an overflow.
                    const SizedBox(width: 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: (actions ?? []).map((w) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 56,
                                ),
                                child: w,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    final bottomWidget = bottom != null
        ? Container(
            color: bg,
            child: PixelBackground(background: bg, child: bottom!),
          )
        : const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_toolbarHeight > 0) header,
        if (bottom != null) bottomWidget,
      ],
    );
  }
}
