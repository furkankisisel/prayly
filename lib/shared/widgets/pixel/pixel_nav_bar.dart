import 'package:flutter/material.dart';
import 'pixel_primitives.dart';

class PixelNavItem {
  final IconData icon;
  final String label;
  const PixelNavItem({required this.icon, required this.label});
}

class PixelNavBar extends StatelessWidget {
  final int currentIndex;
  final List<PixelNavItem> items;
  final ValueChanged<int> onTap;

  const PixelNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = Colors.transparent;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          border: Border(top: BorderSide(color: scheme.primary, width: 2)),
        ),
        child: PixelBackground(
          background: bg,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    icon: items[i].icon,
                    label: items[i].label,
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = selected ? scheme.primary : scheme.onSurface;
    final scale = MediaQuery.of(context).textScaler.scale(1.0);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20 * scale, color: base),
            const SizedBox(height: 6),
            PixelLabel(label, fontSize: 10 * scale, color: base),
          ],
        ),
      ),
    );
  }
}
