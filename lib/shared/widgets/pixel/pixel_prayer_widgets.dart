import 'package:flutter/material.dart';
import 'pixel_primitives.dart';
import '../../../gen_l10n/app_localizations.dart';

class PixelCountdownPanel extends StatelessWidget {
  final String title;
  final String timeText;
  final String? subtitle;
  final bool danger;
  final Widget? extra;
  final Color? accentColor; // optional override for decorative lines/text

  const PixelCountdownPanel({
    super.key,
    required this.title,
    required this.timeText,
    this.subtitle,
    this.danger = false,
    this.extra,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaler.scale(1.0);
    final scheme = Theme.of(context).colorScheme;
    final color = danger
        ? Colors.red.shade400
        : (accentColor ?? scheme.primary);
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PixelLabel(
            title,
            color: danger ? Colors.red.shade400 : scheme.onSurface,
            fontSize: 10,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            timeText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontFamily: 'monospace',
              fontSize: 36 * scale,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: scheme.brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white.withValues(alpha: 0.6),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            PixelBox(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: (danger
                  ? Colors.red.shade50
                  : scheme.surface.withValues(alpha: 0.3)),
              borderColor: danger ? Colors.red.shade200 : scheme.outline,
              child: PixelLabel(
                subtitle!,
                // If the app is in light mode the semi-opaque surface can appear
                // as a light grey which makes default onSurface (black) hard to read.
                // Use white text on light theme here for contrast; keep scheme.onSurface
                // for dark theme and preserve danger color when applicable.
                color: danger
                    ? Colors.red.shade700
                    : (scheme.brightness == Brightness.light
                          ? Colors.white
                          : scheme.onSurface),
                fontSize: 9,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (extra != null) ...[const SizedBox(height: 10), extra!],
        ],
      ),
    );
  }
}

class PixelPrayerTile extends StatelessWidget {
  final String name;
  final String time;
  final bool highlight;
  final Color? lineColor;

  const PixelPrayerTile({
    super.key,
    required this.name,
    required this.time,
    this.highlight = false,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = highlight ? scheme.primary : scheme.onSurface;
    final outline = lineColor ?? scheme.outline;
    return PixelBox(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      color: Colors.transparent,
      borderColor: outline,
      outlineOnly: true,
      child: Row(
        children: [
          Expanded(child: PixelLabel(name, color: color, fontSize: 14)),
          PixelLabel(time, color: color, fontSize: 14),
        ],
      ),
    );
  }
}

class PixelSearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSubmit;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;
  const PixelSearchField({
    super.key,
    required this.controller,
    required this.loading,
    required this.onSubmit,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PixelBox(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            outlineOnly: true,
            child: Builder(
              builder: (context) {
                final code = Localizations.localeOf(context).languageCode;
                final hint = code == 'tr' ? 'Şehir, Ülke' : 'City, Country';
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                  onSubmitted: (s) {
                    if (onFieldSubmitted != null) {
                      onFieldSubmitted!();
                    } else {
                      onSubmit();
                    }
                  },
                  textInputAction: TextInputAction.search,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Builder(
          builder: (context) {
            final code = Localizations.localeOf(context).languageCode;
            final label = loading ? '...' : (code == 'tr' ? 'ARA' : 'Search');
            return PixelButton(
              label,
              onPressed: loading ? null : onSubmit,
              busy: loading,
            );
          },
        ),
      ],
    );
  }
}
