import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/cycle_phase_style.dart';
import '../../../core/presentation/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/analysis.dart';
import '../../../data/models/symptom_type.dart';
import '../../../widgets/charts/scales.dart';
import '../../../widgets/cycle_dial.dart';
import 'report_parts.dart';
import '../../../l10n/l10n.dart';

/// Symptom frequency (bars, one color) with each symptom's phase
/// distribution as a thin stacked strip beneath it.
class SymptomSection extends StatelessWidget {
  const SymptomSection({
    super.key,
    required this.number,
    required this.symptoms,
    required this.symptomTypes,
  });

  final int number;
  final Map<int, SymptomAnalysis> symptoms;
  final AsyncValue<List<SymptomType>> symptomTypes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = l10n.sectionSymptoms;

    if (symptoms.isEmpty) {
      return ReportSection(
        number: number,
        title: title,
        child: NotEnoughData(message: l10n.symptomsEmpty),
      );
    }

    return ReportSection(
      number: number,
      title: title,
      caption: l10n.sectionSymptomsCaption,
      child: symptomTypes.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (_, _) => NotEnoughData(message: l10n.symptomsNamesUnavailable),
        data: (types) {
          final names = {for (final type in types) type.id: type.name};
          final entries = symptoms.entries.toList()
            ..sort((a, b) {
              final byFrequency = b.value.frequency.compareTo(
                a.value.frequency,
              );
              return byFrequency != 0
                  ? byFrequency
                  : (names[a.key] ?? '').compareTo(names[b.key] ?? '');
            });
          final maxFrequency = entries.first.value.frequency;
          final hasPhases = entries.any(
            (e) => e.value.phaseDistribution.values.any((v) => v > 0),
          );

          return ReportPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.md),
                  _SymptomRow(
                    name: names[entries[i].key] ?? l10n.symptomsUnknown,
                    analysis: entries[i].value,
                    maxFrequency: maxFrequency,
                  ),
                ],
                if (hasPhases) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  const PhaseLegend(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SymptomRow extends StatelessWidget {
  const _SymptomRow({
    required this.name,
    required this.analysis,
    required this.maxFrequency,
  });

  final String name;
  final SymptomAnalysis analysis;
  final int maxFrequency;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final rate = analysis.occurrenceRate;
    final mostCommon = CyclePhaseKind.fromApi(analysis.mostCommonPhase);
    final fraction = maxFrequency == 0
        ? 0.0
        : analysis.frequency / maxFrequency;
    final distribution = analysis.phaseDistribution;
    final phaseSummary = [
      for (final phase in CyclePhaseKind.values)
        if ((distribution[phase.apiValue] ?? 0) > 0)
          '${phase.label(l10n)} ${distribution[phase.apiValue]}',
    ].join(', ');

    return Semantics(
      label: l10n.semanticValue(
        name,
        [
          l10n.symptomsTimes(analysis.frequency),
          if (rate != null) l10n.symptomsOfLoggedDays(Fmt.percent(rate)),
          if (phaseSummary.isNotEmpty) l10n.symptomsByPhase(phaseSummary),
        ].join(', '),
      ),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${analysis.frequency}×',
                style: AppTypography.figure.copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (rate != null) ...[
                const SizedBox(width: AppSpacing.xs),
                SizedBox(
                  width: 40,
                  child: Text(
                    Fmt.percent(rate),
                    textAlign: TextAlign.end,
                    style: AppTypography.figure,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) => Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (constraints.maxWidth * fraction).clamp(
                  6,
                  constraints.maxWidth,
                ),
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          if (distribution.values.any((v) => v > 0)) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: PhaseDistributionBar(distribution: distribution),
                ),
                if (mostCommon != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      l10n.symptomsMostly(mostCommon.label(l10n)),
                      style: textTheme.labelSmall?.copyWith(
                        color: mostCommon.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
