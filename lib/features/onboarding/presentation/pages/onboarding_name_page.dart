import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';

/// Simple onboarding page to collect the user's display name.
class OnboardingNamePage extends StatefulWidget {
  const OnboardingNamePage({super.key});

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  final TextEditingController _controller = TextEditingController();
  bool _saving = false;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\u00fctfen bir isim girin.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_user_name_v1', name);
      // Also set profile name so the avatar displays it immediately
      await prefs.setString('profile_name', name);
      await prefs.setBool('onboarding_name_chosen_v1', true);
      if (!mounted) return;
      // Finish onboarding and go to home
      Navigator.of(context).pushReplacementNamed('/home');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool isLightChoice = themeChoice == 'light';
    final Color textColor = isLightChoice ? Colors.white : scheme.onSurface;
    final bgAsset = themeChoice == 'dark'
        ? 'assets/images/onboarding_account_dark.png'
        : 'assets/images/onboarding_account_light.png';
    return Scaffold(
      appBar: const PixelAppBar(title: 'İsim girin'),
      body: Stack(
        children: [
          // full-screen background image
          Positioned.fill(child: Image.asset(bgAsset, fit: BoxFit.cover)),
          // overlay to ensure readable contrast
          Positioned.fill(
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.18),
            ),
          ),
          // Make the content scrollable so the keyboard doesn't cause an overflow
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PixelLabel('Adınız', fontSize: 18, color: textColor),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        style: isLightChoice
                            ? const TextStyle(color: Colors.white)
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Adınız...',
                          hintStyle: isLightChoice
                              ? const TextStyle(color: Colors.white70)
                              : null,
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: PixelButton(
                              _saving ? 'Kaydediliyor...' : 'Kaydet ve devam',
                              onPressed: _saving ? null : _saveAndContinue,
                              textColor: isLightChoice ? Colors.white : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
