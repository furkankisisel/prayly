import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Custom component styling (card-like bordered panel with ornate corners)
class PanelTheme extends ThemeExtension<PanelTheme> {
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final EdgeInsets padding;

  const PanelTheme({
    required this.borderColor,
    required this.backgroundColor,
    this.radius = 14,
    this.padding = const EdgeInsets.all(20),
  });

  factory PanelTheme.light() =>
      PanelTheme(borderColor: AppColors.gold, backgroundColor: Colors.white);
  factory PanelTheme.dark() => PanelTheme(
    borderColor: AppColors.gold,
    backgroundColor: AppColors.darkSurface,
  );
  factory PanelTheme.amoled() => PanelTheme(
    borderColor: AppColors.gold,
    backgroundColor: const Color(0xFF1A1A1A),
  );

  @override
  ThemeExtension<PanelTheme> copyWith({
    Color? borderColor,
    Color? backgroundColor,
    double? radius,
    EdgeInsets? padding,
  }) => PanelTheme(
    borderColor: borderColor ?? this.borderColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
  );

  @override
  ThemeExtension<PanelTheme> lerp(
    covariant ThemeExtension<PanelTheme>? other,
    double t,
  ) {
    if (other is! PanelTheme) return this;
    return PanelTheme(
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
