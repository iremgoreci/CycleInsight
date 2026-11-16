import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/app_colors.dart';

/// Presentation metadata for the four cycle phases returned by the API
/// (`menstrual`, `follicular`, `ovulatory`, `luteal`).
///
/// This is display-only: phase *calculation* stays in the backend.
/// Text comes from [AppLocalizations] via the [CyclePhaseText] extension.
enum CyclePhaseKind {
  menstrual(
    apiValue: 'menstrual',
    color: PhaseColors.menstrual,
    ink: PhaseColors.menstrualInk,
    soft: PhaseColors.menstrualSoft,
    icon: Icons.water_drop_outlined,
  ),
  follicular(
    apiValue: 'follicular',
    color: PhaseColors.follicular,
    ink: PhaseColors.follicularInk,
    soft: PhaseColors.follicularSoft,
    icon: Icons.eco_outlined,
  ),
  ovulatory(
    apiValue: 'ovulatory',
    color: PhaseColors.ovulatory,
    ink: PhaseColors.ovulatoryInk,
    soft: PhaseColors.ovulatorySoft,
    icon: Icons.wb_sunny_outlined,
  ),
  luteal(
    apiValue: 'luteal',
    color: PhaseColors.luteal,
    ink: PhaseColors.lutealInk,
    soft: PhaseColors.lutealSoft,
    icon: Icons.nightlight_outlined,
  );

  const CyclePhaseKind({
    required this.apiValue,
    required this.color,
    required this.ink,
    required this.soft,
    required this.icon,
  });

  final String apiValue;

  /// Fill color for marks (arcs, bars, dots).
  final Color color;

  /// Accessible text color for this phase.
  final Color ink;

  /// Very light tint for backgrounds.
  final Color soft;
  final IconData icon;

  /// 1-based position in the cycle.
  int get number => index + 1;

  static CyclePhaseKind? fromApi(String? value) {
    if (value == null) {
      return null;
    }
    for (final phase in values) {
      if (phase.apiValue == value) {
        return phase;
      }
    }
    return null;
  }
}

extension CyclePhaseText on CyclePhaseKind {
  /// Short label: "Foliküler".
  String label(AppLocalizations l10n) => switch (this) {
    CyclePhaseKind.menstrual => l10n.phaseMenstrual,
    CyclePhaseKind.follicular => l10n.phaseFollicular,
    CyclePhaseKind.ovulatory => l10n.phaseOvulatory,
    CyclePhaseKind.luteal => l10n.phaseLuteal,
  };

  /// Full name: "Foliküler faz", "Ovülasyon fazı".
  String fullName(AppLocalizations l10n) => switch (this) {
    CyclePhaseKind.menstrual => l10n.phaseMenstrualName,
    CyclePhaseKind.follicular => l10n.phaseFollicularName,
    CyclePhaseKind.ovulatory => l10n.phaseOvulatoryName,
    CyclePhaseKind.luteal => l10n.phaseLutealName,
  };

  /// Abbreviation for narrow table headers: "Fol.".
  String short(AppLocalizations l10n) => switch (this) {
    CyclePhaseKind.menstrual => l10n.phaseMenstrualShort,
    CyclePhaseKind.follicular => l10n.phaseFollicularShort,
    CyclePhaseKind.ovulatory => l10n.phaseOvulatoryShort,
    CyclePhaseKind.luteal => l10n.phaseLutealShort,
  };
}
