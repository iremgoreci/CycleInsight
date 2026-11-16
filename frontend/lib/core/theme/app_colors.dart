import 'package:flutter/material.dart';

/// Centralized color palette for CycleInsight.
///
/// The identity is built on a warm paper ground, deep sage as the action
/// color, muted lavender as the secondary voice, and a four-color *phase
/// spectrum* (see [PhaseColors]) that carries cycle meaning through charts
/// and markers. Screens should reference these tokens instead of hardcoding
/// colors.
class AppColors {
  const AppColors._();

  // Sage — primary action and brand color.
  static const Color primary = Color(0xFF3D6B53);
  static const Color primaryDark = Color(0xFF274A39);
  static const Color primarySoft = Color(0xFFDDE8E0);
  static const Color primaryTint = Color(0xFFEEF4EF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Lavender — secondary voice (insights, education, highlights).
  static const Color lavender = Color(0xFF6E5CA6);
  static const Color lavenderDeep = Color(0xFF4E3F86);
  static const Color lavenderSoft = Color(0xFFE6E2F2);
  static const Color lavenderTint = Color(0xFFF3F1F9);

  // Neutral surfaces — warm, never pure grey.
  static const Color background = Color(0xFFF6F4EF); // paper
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFEDE6); // recessed paper
  static const Color outline = Color(0xFFE2DED4);
  static const Color divider = Color(0xFFE9E5DC);

  // Ink.
  static const Color textPrimary = Color(0xFF1E2823);
  static const Color textSecondary = Color(0xFF515C56);
  static const Color textMuted = Color(0xFF6E7872); // >= 4.5:1 on paper
  static const Color textFaint = Color(0xFF9AA19C); // decorative only
  static const Color onSurface = textPrimary;

  // Status.
  static const Color error = Color(0xFFA8382F);
  static const Color errorSoft = Color(0xFFF6E3E0);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = primary;
  static const Color warning = Color(0xFF8A6418);

  // Overlays.
  static const Color shadow = Color(0x141E2823);
  static const Color scrim = Color(0x661E2823);
}

/// The four-phase spectrum. Validated as a categorical set: every pair
/// keeps >= 11 OKLab ΔE under protan/deutan/tritan simulation and >= 17 for
/// normal vision. Ovulatory's fill is low-contrast on white, so phase marks
/// always ship with a text label and phase *text* uses the `ink` variants.
class PhaseColors {
  const PhaseColors._();

  static const Color menstrual = Color(0xFFA0453F);
  static const Color follicular = Color(0xFF5F9479);
  static const Color ovulatory = Color(0xFFD6AA4C);
  static const Color luteal = Color(0xFF6E5CA6);

  static const Color menstrualInk = Color(0xFF7E332E);
  static const Color follicularInk = Color(0xFF35614A);
  static const Color ovulatoryInk = Color(0xFF6E500F);
  static const Color lutealInk = Color(0xFF4E3F86);

  static const Color menstrualSoft = Color(0xFFF3E1DE);
  static const Color follicularSoft = Color(0xFFE0ECE5);
  static const Color ovulatorySoft = Color(0xFFF6ECD5);
  static const Color lutealSoft = Color(0xFFE6E2F2);
}

/// Colors for the five daily-log measures. Reused everywhere a measure is
/// shown (log input, journal meters, insights) so a measure keeps its color.
class MetricColors {
  const MetricColors._();

  static const Color bleeding = PhaseColors.menstrual;
  static const Color pain = Color(0xFFB8673F);
  static const Color mood = AppColors.primary;
  static const Color sleep = AppColors.lavender;
  static const Color stress = Color(0xFF9C7A2C);
}
