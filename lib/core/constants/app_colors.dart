import 'package:flutter/material.dart';

class AppColors {
  // Surface colors
  static const surface = Color(0xFFF8F9FC);
  static const surfaceDim = Color(0xFFD8DADD);
  static const surfaceBright = Color(0xFFF8F9FC);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F4F6);
  static const surfaceContainer = Color(0xFFECEEF0);
  static const surfaceContainerHigh = Color(0xFFE7E8EB);
  static const surfaceContainerHighest = Color(0xFFE1E2E5);

  // On Surface colors
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF494455);
  static const inverseSurface = Color(0xFF2E3133);
  static const inverseOnSurface = Color(0xFFEFF1F3);

  // Outline colors
  static const outline = Color(0xFF7A7486);
  static const outlineVariant = Color(0xFFCBC3D7);

  // Brand / Primary
  static const surfaceTint = Color(0xFF6A39DF);
  static const primary = Color(0xFF3B009A);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF5416C9);
  static const onPrimaryContainer = Color(0xFFC1ACFF);
  static const inversePrimary = Color(0xFFCEBDFF);

  // Secondary
  static const secondary = Color(0xFF6736DC);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFF8054F6);
  static const onSecondaryContainer = Color(0xFFFFBFF);

  // Tertiary
  static const tertiary = Color(0xFF5C1F00);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF812F00);
  static const onTertiaryContainer = Color(0xFFFFA179);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Background
  static const background = Color(0xFFF8F9FC);
  static const onBackground = Color(0xFF191C1E);

  // Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6736DC),
      Color(0xFF3B009A),
    ],
  );

  // Additional Fixed colors
  static const primaryFixed = Color(0xFFE8DDFF);
  static const onPrimaryFixedVariant = Color(0xFF5110C7);
  static const secondaryFixed = Color(0xFFE8DDFF);
  static const onSecondaryFixedVariant = Color(0xFF5110C6);
  static const tertiaryFixed = Color(0xFFFFDBCD);
  static const surfaceVariant = Color(0xFFE1E2E5);
}
