import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema modları
enum AppThemeMode { light, dark, amoled, system }

/// Basit tema modu yöneticisi (kalıcı değil – istenirse SharedPreferences ile genişletilebilir)
class ThemeController extends ChangeNotifier {
  static const String _prefsKey = 'theme_mode_v1';

  AppThemeMode _mode = AppThemeMode.system;
  AppThemeMode get mode => _mode;

  ThemeController();

  /// Async factory to create controller with persisted value loaded.
  static Future<ThemeController> create() async {
    final controller = ThemeController();
    try {
      final prefs = await SharedPreferences.getInstance();
      final idx = prefs.getInt(_prefsKey);
      if (idx != null && idx >= 0 && idx < AppThemeMode.values.length) {
        controller._mode = AppThemeMode.values[idx];
      }
    } catch (_) {
      // ignore and use default
    }
    return controller;
  }

  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    // persist asynchronously, don't block UI
    _persistMode();
    notifyListeners();
  }

  Future<void> _persistMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKey, _mode.index);
    } catch (_) {
      // ignore persistence errors
    }
  }

  /// Flutter'ın ThemeMode'una çevir
  ThemeMode get flutterThemeMode {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
      case AppThemeMode.amoled:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// AMOLED tema mı?
  bool get isAmoled => _mode == AppThemeMode.amoled;

  void toggleLightDark() {
    if (_mode == AppThemeMode.light) {
      setMode(AppThemeMode.dark);
    } else {
      setMode(AppThemeMode.light);
    }
  }
}

class ThemeControllerProvider extends InheritedNotifier<ThemeController> {
  const ThemeControllerProvider({
    super.key,
    required ThemeController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static ThemeController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerProvider>();
    assert(provider != null, 'ThemeControllerProvider not found in context');
    return provider!.notifier!;
  }
}
