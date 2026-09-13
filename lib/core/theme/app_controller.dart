import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema modları
enum AppThemeMode { light, dark, amoled, system }

/// Desteklenen diller
enum AppLanguage { turkish, english, arabic, spanish, chinese, french, german }

extension AppLanguageExtension on AppLanguage {
  Locale get locale {
    switch (this) {
      case AppLanguage.turkish:
        return const Locale('tr', 'TR');
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.arabic:
        return const Locale('ar', 'SA');
      case AppLanguage.spanish:
        return const Locale('es', 'ES');
      case AppLanguage.chinese:
        return const Locale('zh', 'CN');
      case AppLanguage.french:
        return const Locale('fr', 'FR');
      case AppLanguage.german:
        return const Locale('de', 'DE');
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.turkish:
        return 'Türkçe';
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'العربية';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.chinese:
        return '中文';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
    }
  }
}

/// Tema ve dil yöneticisi
class AppController extends ChangeNotifier {
  static const String _themePrefsKey = 'theme_mode_v1';
  static const String _languagePrefsKey = 'app_language_v1';

  AppThemeMode _themeMode = AppThemeMode.system;
  AppLanguage _language = AppLanguage.turkish;

  AppThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;

  AppController();

  /// Async factory to create controller with persisted values loaded.
  static Future<AppController> create() async {
    final controller = AppController();
    try {
      final prefs = await SharedPreferences.getInstance();

      // Theme yükle
      final themeIdx = prefs.getInt(_themePrefsKey);
      if (themeIdx != null &&
          themeIdx >= 0 &&
          themeIdx < AppThemeMode.values.length) {
        controller._themeMode = AppThemeMode.values[themeIdx];
      }

      // Dil yükle
      final langIdx = prefs.getInt(_languagePrefsKey);
      if (langIdx != null &&
          langIdx >= 0 &&
          langIdx < AppLanguage.values.length) {
        controller._language = AppLanguage.values[langIdx];
      }
    } catch (_) {
      // ignore and use defaults
    }
    return controller;
  }

  void setThemeMode(AppThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _persistThemeMode();
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    _persistLanguage();
    notifyListeners();
  }

  Future<void> _persistThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePrefsKey, _themeMode.index);
    } catch (_) {
      // ignore persistence errors
    }
  }

  Future<void> _persistLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_languagePrefsKey, _language.index);
    } catch (_) {
      // ignore persistence errors
    }
  }

  /// Flutter'ın ThemeMode'una çevir
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
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
  bool get isAmoled => _themeMode == AppThemeMode.amoled;

  void toggleLightDark() {
    if (_themeMode == AppThemeMode.light) {
      setThemeMode(AppThemeMode.dark);
    } else {
      setThemeMode(AppThemeMode.light);
    }
  }
}

class AppControllerProvider extends InheritedNotifier<AppController> {
  const AppControllerProvider({
    super.key,
    required AppController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AppController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppControllerProvider>();
    assert(provider != null, 'AppControllerProvider not found in context');
    return provider!.notifier!;
  }
}
