import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../prayer_times/data/services/place_suggestions_service.dart';

/// Onboarding location page: choose automatic (device) or manual (search/input with autofill).
class OnboardingLocationPage extends StatefulWidget {
  const OnboardingLocationPage({super.key});

  @override
  State<OnboardingLocationPage> createState() => _OnboardingLocationPageState();
}

class _OnboardingLocationPageState extends State<OnboardingLocationPage> {
  bool _loading = false;
  String themeChoice = 'light';
  final TextEditingController _manualController = TextEditingController();
  List<(String, String)> _suggestions = [];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _manualController.dispose();
    super.dispose();
  }

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

  Future<void> _chooseAutomatic() async {
    setState(() => _loading = true);
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      // Persist basic fallback coordinates as strings
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('onboarding_location_lat_v1', pos.latitude);
      await prefs.setDouble('onboarding_location_lng_v1', pos.longitude);
      // mark onboarding location chosen
      await prefs.setBool('onboarding_location_chosen_v1', true);
      // Clear manual city/country cache so GPS mode is used
      await prefs.remove('prayer_last_city');
      await prefs.remove('prayer_last_country');
      // Navigate to name step. Use mounted guard after awaits.
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/onboarding/name');
    } catch (e) {
      // Ignore but show a minimal error (guarded by mounted)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum alınamadı. Lütfen manuel girin.')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _chooseManual(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_location_manual_v1', value);
    await prefs.setBool('onboarding_location_chosen_v1', true);
    // Try to parse and persist city/country for prayer cache
    if (value.isNotEmpty) {
      final parts = value.split(',');
      final city = parts.isNotEmpty ? parts.first.trim() : value.trim();
      final country = parts.length > 1
          ? parts.sublist(1).join(',').trim()
          : 'Turkey';
      await prefs.setString('onboarding_location_manual_city_v1', city);
      await prefs.setString('onboarding_location_manual_country_v1', country);
      await prefs.setString('prayer_last_city', city);
      await prefs.setString('prayer_last_country', country);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding/name');
  }

  Future<void> _chooseManualSuggestion((String, String) opt) async {
    final city = opt.$1;
    final country = opt.$2;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_location_manual_v1', '$city, $country');
    await prefs.setString('onboarding_location_manual_city_v1', city);
    await prefs.setString('onboarding_location_manual_country_v1', country);
    await prefs.setBool('onboarding_location_chosen_v1', true);
    await prefs.setString('prayer_last_city', city);
    await prefs.setString('prayer_last_country', country);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding/name');
  }

  // Debounced fetch using in-repo PlaceSuggestionsService
  void _onManualChanged(String v) {
    _debounce?.cancel();
    final q = v.trim();
    if (q.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        final list = await PlaceSuggestionsService.instance.fetch(
          q,
          language: 'tr',
        );
        if (!mounted) return;
        setState(() {
          _suggestions = list;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool isLightChoice = themeChoice == 'light';
    final Color textColor = isLightChoice ? Colors.white : scheme.onSurface;
    final bgAsset = themeChoice == 'dark'
        ? 'assets/images/onboarding_location_dark.png'
        : 'assets/images/onboarding_location_light.png';
    return Scaffold(
      appBar: PixelAppBar(title: 'Konum seçimi'),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(bgAsset, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.18),
            ),
          ),
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
                      PixelLabel(
                        'Konumunuzu seçin',
                        fontSize: 18,
                        color: textColor,
                      ),
                      const SizedBox(height: 12),
                      PixelBox(
                        padding: const EdgeInsets.all(12),
                        borderColor: scheme.primary,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: PixelLabel(
                                    'Otomatik (cihaz konumu)',
                                    color: textColor,
                                  ),
                                ),
                                PixelButton(
                                  _loading ? 'Bekleniyor' : 'Kullan',
                                  onPressed: _loading ? null : _chooseAutomatic,
                                  textColor: isLightChoice
                                      ? Colors.white
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: PixelLabel('Manuel', color: textColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _manualController,
                              onChanged: _onManualChanged,
                              style: isLightChoice
                                  ? const TextStyle(color: Colors.white)
                                  : null,
                              decoration: InputDecoration(
                                hintText: 'Şehir veya adres yazın...',
                                hintStyle: isLightChoice
                                    ? const TextStyle(color: Colors.white70)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // suggestions - limit max height so keyboard doesn't push everything off-screen
                            if (_suggestions.isNotEmpty)
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  // allow the suggestions list to grow but cap it to half the screen height
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: _suggestions
                                      .map(
                                        (s) => ListTile(
                                          title: Text(
                                            s.$1,
                                            style: isLightChoice
                                                ? const TextStyle(
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          subtitle: Text(
                                            s.$2,
                                            style: isLightChoice
                                                ? const TextStyle(
                                                    color: Colors.white70,
                                                  )
                                                : null,
                                          ),
                                          onTap: () {
                                            _manualController.text =
                                                '${s.$1}, ${s.$2}';
                                            _chooseManualSuggestion(s);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: PixelButton(
                                    'Kaydet ve devam',
                                    onPressed: () =>
                                        _chooseManual(_manualController.text),
                                    textColor: isLightChoice
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
