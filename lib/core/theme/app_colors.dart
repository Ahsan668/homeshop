import 'package:flutter/material.dart';

/// App color palette - Trending 2025 Design
class AppColors {
  // Primary Colors - Vibrant Purple
  static const Color primary = Color(0xFF5A4AE3);
  static const Color primaryDark = Color(0xFF4839C7);
  static const Color primaryLight = Color(0xFF7B6EF0);
  static const Color primaryExtraLight = Color(0xFFE8E5FB);

  // Secondary Colors - Hot Pink
  static const Color secondary = Color(0xFFE14D9C);
  static const Color secondaryDark = Color(0xFFC93D85);
  static const Color secondaryLight = Color(0xFFF177B6);
  static const Color secondaryExtraLight = Color(0xFFFCE8F3);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color greyDark = Color(0xFF616161);

  // Background Colors
  static const Color background = Color(0xFFF8F7FD);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2A2A2A);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFCCCCCC);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF4B5563);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // Private constructor to prevent instantiation
  AppColors._();
}
