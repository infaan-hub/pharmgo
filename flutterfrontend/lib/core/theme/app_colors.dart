import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF333F2C);
  static const Color primaryDarkHover = Color(0xFF28331F);
  static const Color background = Color(0xFFF3EEE3);
  static const Color cardSurface = Color(0xFFE7DCC6);
  static const Color cardSurfaceAlt = Color(0xFFDED2B9);
  static const Color textPrimary = Color(0xFF2A2A22);
  static const Color textSecondary = Color(0xFF8C8478);
  static const Color divider = Color(0xFFE3D8C4);
  static const Color success = Color(0xFF4C6B3F);
  static const Color error = Color(0xFFB0463C);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic roles: widgets use these rather than inventing color literals.
  static const Color primary = primaryDark;
  static const Color secondary = success;
  static const Color surface = cardSurface;
  static const Color border = divider;
}

/// Dark mode has the same public roles as [AppColors], keeping themes structurally aligned.
class AppColorsDark {
  AppColorsDark._();
  static const Color primary = AppColors.cardSurface;
  static const Color secondary = AppColors.success;
  static const Color background = AppColors.primaryDarkHover;
  static const Color surface = AppColors.primaryDark;
  static const Color error = AppColors.error;
  static const Color success = AppColors.success;
  static const Color textPrimary = AppColors.background;
  static const Color textSecondary = AppColors.cardSurfaceAlt;
  static const Color border = AppColors.textSecondary;
}
