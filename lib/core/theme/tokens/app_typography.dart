import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central typography scaling (can later adapt by dynamic text scaling)
class AppTypography {
  static TextTheme lightTextTheme = _baseTextTheme(light: true);
  static TextTheme darkTextTheme = _baseTextTheme(light: false);

  static TextTheme _baseTextTheme({required bool light}) {
    final base = ThemeData(
      brightness: light ? Brightness.light : Brightness.dark,
    ).textTheme;
    final serif = GoogleFonts.playfairDisplay; // for headings
    final body = GoogleFonts.nunito; // for body content
    return base.copyWith(
      displayLarge: serif(fontSize: 48, fontWeight: FontWeight.w600),
      displayMedium: serif(fontSize: 40, fontWeight: FontWeight.w600),
      headlineMedium: serif(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: serif(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: serif(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: body(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: body(fontSize: 14, fontWeight: FontWeight.w500),
      labelSmall: body(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }
}
