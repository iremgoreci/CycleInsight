import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography for CycleInsight.
///
/// Light/regular weights dominate; medium is reserved for labels and
/// emphasis; bold is used only where real visual weight is intentional
/// (see [heroNumber]).
class AppTypography {
  const AppTypography._();

  static TextTheme get textTheme => const TextTheme(
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
          color: AppColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          color: AppColors.textMuted,
        ),
      );

  /// Large hero numeral (e.g. current cycle day). The one place real
  /// visual weight is intentional.
  static const TextStyle heroNumber = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  /// Small, letter-spaced caption used for phase names and section eyebrows.
  static const TextStyle eyebrow = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.primary,
  );
}
