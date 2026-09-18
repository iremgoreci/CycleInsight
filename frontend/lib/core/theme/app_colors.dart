import 'package:flutter/material.dart';

/// Centralized color palette for CycleInsight.
///
/// Visual identity is RED + WHITE first. Pink ("blush") is a sparse
/// secondary accent only — used for small highlights, never as a dominant
/// background. Screens should reference these tokens instead of
/// hardcoding colors.
class AppColors {
  const AppColors._();

  // Brand red
  static const Color primary = Color(0xFFA23B4E); // sophisticated muted red
  static const Color primaryDark = Color(0xFF6E1F2E); // deep burgundy accent
  static const Color primaryMuted = Color(0xFFC97C89); // softer red, progress fill
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Blush — sparse secondary accent, used in small doses only
  static const Color blush = Color(0xFFF7E7EA);
  static const Color blushStrong = Color(0xFFEFD1D7);

  // Neutral surfaces — white dominates
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFAF7F7); // very subtle off-white
  static const Color outline = Color(0xFFEDE5E6);
  static const Color divider = Color(0xFFF1EAEB);

  // Text
  static const Color textPrimary = Color(0xFF241F20); // dark neutral
  static const Color textSecondary = Color(0xFF7A7476); // soft gray
  static const Color textMuted = Color(0xFFAFA8AA);
  static const Color onSurface = textPrimary;

  // Status
  static const Color error = Color(0xFFC1432E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF3F7D5C);
  static const Color warning = Color(0xFFB07A3E);

  // Overlays
  static const Color shadow = Color(0x14241F20);
  static const Color scrim = Color(0x66000000);
}
