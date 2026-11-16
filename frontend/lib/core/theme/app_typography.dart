import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography for CycleInsight.
///
/// Uses the platform sans for reliability. Character comes from a tight,
/// confident display scale, tabular figures for every number, and small
/// letter-spaced eyebrows that label sections like a printed report.
class AppTypography {
  const AppTypography._();

  static const _tabular = [FontFeature.tabularFigures()];

  static TextTheme get textTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.8,
      height: 1.1,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.6,
      height: 1.15,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
      height: 1.2,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textMuted,
    ),
    labelLarge: TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: AppColors.textMuted,
    ),
  );

  /// Hero numeral — the current cycle day. The single loudest element.
  static const TextStyle heroNumber = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w300,
    letterSpacing: -3,
    height: 1.0,
    color: AppColors.textPrimary,
    fontFeatures: _tabular,
  );

  /// Statistic numerals inside reports (cycle length, averages, ...).
  static const TextStyle statNumber = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.8,
    height: 1.1,
    color: AppColors.textPrimary,
    fontFeatures: _tabular,
  );

  /// Small numerals for chart labels and inline figures.
  static const TextStyle figure = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFeatures: _tabular,
  );

  /// Letter-spaced uppercase section label.
  static const TextStyle eyebrow = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
    height: 1.2,
    color: AppColors.textMuted,
  );

  /// Long-form reading text (Learn chapters).
  static const TextStyle reading = TextStyle(
    fontSize: 16.5,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: AppColors.textPrimary,
  );
}
