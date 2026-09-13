import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';

/// After choosing a theme, pick one of two visual variations for that theme.
class OnboardingVariationPage extends StatefulWidget {
  const OnboardingVariationPage({super.key});

  @override
  State<OnboardingVariationPage> createState() =>
      _OnboardingVariationPageState();
}

class _OnboardingVariationPageState extends State<OnboardingVariationPage> {
  String themeChoice = 'light';

  @override
  void initState() {
    super.initState();
    _loadThemeChoice();
  }

  Future<void> _loadThemeChoice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getString('onboarding_theme_choice_v1');
      if (v != null && mounted) {
        setState(() {
          themeChoice = v;
        });
      }
    } catch (_) {}
  }

  Future<void> _chooseVariation(
    BuildContext context,
    String variationKey,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_theme_variation_v1', variationKey);
      await prefs.setBool('onboarding_theme_selected_v1', true);
    } catch (_) {}
    if (context.mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool isLightChoice = themeChoice == 'light';
    final Color textColor = isLightChoice ? Colors.white : scheme.onSurface;
    final locale = Localizations.localeOf(context);
    final isTr = locale.languageCode.toLowerCase().startsWith('tr');
    final chooseVariant = isTr ? 'Bir varyasyon seçin' : 'Choose a variation';
    final headerTitle = isTr ? 'Tema ayarları' : 'Theme settings';
    final selectLabel = isTr ? 'Seç' : 'Select';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.18)
              : Colors.transparent,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PixelLabel(headerTitle, fontSize: 14, color: textColor),
                const SizedBox(height: 12),
                PixelLabel(
                  chooseVariant,
                  fontSize: 10,
                  color: isLightChoice
                      ? Colors.white70
                      : scheme.onSurface.withValues(alpha: .75),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PixelBox(
                        padding: const EdgeInsets.all(12),
                        borderColor: scheme.primary,
                        child: Column(
                          children: [
                            // Example preview (replace with real preview image assets later)
                            // Example preview; adapt tint by chosen theme
                            Container(
                              height: 120,
                              color: themeChoice == 'dark'
                                  ? Colors.black
                                  : scheme.surface,
                            ),
                            const SizedBox(height: 8),
                            PixelLabel(
                              isTr ? 'Varyasyon A' : 'Variant A',
                              fontSize: 12,
                              color: textColor,
                            ),
                            const SizedBox(height: 6),
                            PixelButton(
                              selectLabel,
                              textColor: isLightChoice ? Colors.white : null,
                              onPressed: () => _chooseVariation(context, 'a'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PixelBox(
                        padding: const EdgeInsets.all(12),
                        borderColor: scheme.primary,
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              color: themeChoice == 'dark'
                                  ? Colors.grey[900]
                                  : scheme.surface.withValues(alpha: .95),
                            ),
                            const SizedBox(height: 8),
                            PixelLabel(
                              isTr ? 'Varyasyon B' : 'Variant B',
                              fontSize: 12,
                              color: textColor,
                            ),
                            const SizedBox(height: 6),
                            PixelButton(
                              selectLabel,
                              textColor: isLightChoice ? Colors.white : null,
                              onPressed: () => _chooseVariation(context, 'b'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
