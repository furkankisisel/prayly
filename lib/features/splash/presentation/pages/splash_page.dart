import 'dart:async';
import 'package:flutter/material.dart';
// ...existing code...

/// Kısa süreli açılış (splash) ekranı.
class SplashPage extends StatefulWidget {
  final Duration duration;
  const SplashPage({
    super.key,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    // Check whether onboarding theme is selected.
    _decideNext();
  }

  Future<void> _decideNext() async {
    // For testing: always show onboarding first.
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding/theme');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgAsset = theme.brightness == Brightness.dark
        ? 'assets/images/splashscreen_dark.png'
        : 'assets/images/splashscreen_light.png';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bgAsset), fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withValues(alpha: .95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Only show the background image; old PixelSplash overlay removed to avoid visual conflicts.
        child: const SizedBox.shrink(),
      ),
    );
  }
}
