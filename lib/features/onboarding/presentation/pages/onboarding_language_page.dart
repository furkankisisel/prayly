import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_controller.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';

/// Onboarding language choice: Turkish or English.
class OnboardingLanguagePage extends StatefulWidget {
  const OnboardingLanguagePage({super.key});

  @override
  State<OnboardingLanguagePage> createState() => _OnboardingLanguagePageState();
}

class _OnboardingLanguagePageState extends State<OnboardingLanguagePage> {
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
      if (v != null && mounted) setState(() => themeChoice = v);
    } catch (_) {}
  }

  Future<void> _chooseLanguage(Locale locale) async {
    try {
      // Capture controller synchronously to avoid using BuildContext after await
      final controller = AppControllerProvider.of(context);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_locale_v1', locale.languageCode);
      // mark onboarding language chosen; keep final onboarding_selected for after variation

      // Map simple locales to AppLanguage enum used by controller
      if (locale.languageCode.toLowerCase().startsWith('tr')) {
        controller.setLanguage(AppLanguage.turkish);
      } else {
        controller.setLanguage(AppLanguage.english);
      }
    } catch (_) {}

    if (!mounted) return;
    // Continue to location picker
    Navigator.of(context).pushReplacementNamed('/onboarding/location');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final isTr = locale.languageCode.toLowerCase().startsWith('tr');
    final bool isLightChoice = themeChoice == 'light';
    final Color textColor = isLightChoice ? Colors.white : scheme.onSurface;

    // Choose background image depending on previously chosen theme
    final bgAsset = themeChoice == 'dark'
        ? 'assets/images/onboarding_language_dark.png'
        : 'assets/images/onboarding_language_light.png';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgAsset),
            fit: BoxFit.cover,
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
                    isTr ? 'Dil seçimi' : 'Choose language',
                    fontSize: 16,
                    color: textColor,
                  ),
                  const SizedBox(height: 16),
                  PixelBox(
                    padding: const EdgeInsets.all(12),
                    borderColor: scheme.primary,
                    child: Row(
                      children: [
                        Expanded(
                          child: PixelLabel(
                            'Türkçe',
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        PixelButton(
                          'Seç',
                          textColor: isLightChoice ? Colors.white : null,
                          onPressed: () => _chooseLanguage(const Locale('tr')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PixelBox(
                    padding: const EdgeInsets.all(12),
                    borderColor: scheme.primary,
                    child: Row(
                      children: [
                        Expanded(
                          child: PixelLabel(
                            'English',
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        PixelButton(
                          'Select',
                          textColor: isLightChoice ? Colors.white : null,
                          onPressed: () =>
                              _chooseLanguage(const Locale('en', 'US')),
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
