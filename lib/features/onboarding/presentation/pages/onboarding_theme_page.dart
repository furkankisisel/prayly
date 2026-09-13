import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_controller.dart';
import '../../../../gen_l10n/app_localizations.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';

/// First step of onboarding: theme selection (light or dark).
class OnboardingThemePage extends StatelessWidget {
  const OnboardingThemePage({super.key});

  Future<void> _choose(BuildContext context, AppThemeMode mode) async {
    final controller = AppControllerProvider.of(context);
    controller.setThemeMode(mode);

    // Persist temporary selection and continue to variation picker.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'onboarding_theme_choice_v1',
        mode == AppThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {}

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/onboarding/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isTr = locale.languageCode.toLowerCase().startsWith('tr');
    final selectLabel = isTr ? 'Seç' : 'Select';
    final helperText = isTr
        ? 'Koyu mu yoksa açık tema mı tercih edersiniz?'
        : 'Which theme do you prefer: dark or light?';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Use a single shared onboarding background image for the theme picker.
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/onboarding_theme_bg.png'),
            fit: BoxFit.cover,
            // Darken the image to ensure good contrast for text in light theme.
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.18),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PixelLabel(
                    // Reuse profile theme title for brevity
                    l10n.profileThemeSettings,
                    fontSize: 14,
                    color: scheme.onSurface,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  PixelLabel(
                    // Simple helper text
                    helperText,
                    fontSize: 10,
                    color: scheme.onSurface.withValues(alpha: .75),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Light theme option
                  PixelBox(
                    padding: const EdgeInsets.all(12),
                    color: scheme.surface.withValues(alpha: 0.9),
                    borderColor: scheme.primary,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny,
                          color: Colors.amber,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: PixelLabel(
                            l10n.profileThemeLight,
                            fontSize: 12,
                            color: scheme.onSurface,
                          ),
                        ),
                        PixelButton(
                          selectLabel,
                          onPressed: () => _choose(context, AppThemeMode.light),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dark theme option
                  PixelBox(
                    padding: const EdgeInsets.all(12),
                    color: scheme.surface.withValues(alpha: 0.9),
                    borderColor: scheme.primary,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.nightlight_round,
                          color: Colors.blueGrey,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: PixelLabel(
                            l10n.profileThemeDark,
                            fontSize: 12,
                            color: scheme.onSurface,
                          ),
                        ),
                        PixelButton(
                          selectLabel,
                          onPressed: () => _choose(context, AppThemeMode.dark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Background instructions:
// - Add your onboarding background images to assets, e.g.:
//   assets/images/onboarding_bg_light.png
//   assets/images/onboarding_bg_dark.png
// - Register them under flutter: assets: in pubspec.yaml
// - In the BoxDecoration above, uncomment the DecorationImage and set the paths.
