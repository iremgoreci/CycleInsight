import 'package:flutter/material.dart';

import '../../../core/presentation/cycle_phase_style.dart';
import '../../../core/presentation/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/analysis.dart';
import '../../../widgets/charts/scales.dart';
import '../analysis_labels.dart';
import 'report_parts.dart';
import '../../../l10n/l10n.dart';

typedef _Measure = ({String name, Color color, String note});

/// The four wellbeing measures in display order, with localized names.
({_Measure mood, _Measure sleep, _Measure pain, _Measure stress}) _measures(
  AppLocalizations l10n,
) => (
  mood: (
    name: l10n.metricMood,
    color: MetricColors.mood,
    note: l10n.wellbeingHigherBetter,
  ),
  sleep: (
    name: l10n.metricSleep,
    color: MetricColors.sleep,
    note: l10n.wellbeingHigherBetter,
  ),
  pain: (
    name: l10n.metricPain,
    color: MetricColors.pain,
    note: l10n.wellbeingHigherMore,
  ),
  stress: (
    name: l10n.metricStress,
    color: MetricColors.stress,
    note: l10n.wellbeingHigherMore,
  ),
);

/// Range strips for the four wellbeing measures, plus a by-phase table
/// when the backend returns phase averages.
class WellbeingSection extends StatelessWidget {
  const WellbeingSection({
    super.key,
    required this.number,
    required this.wellbeing,
    required this.byPhase,
  });

  final int number;
  final WellbeingAnalysis wellbeing;
  final Map<String, PhaseWellbeing> byPhase;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = _measures(l10n);
    final rows = <(_Measure, WellbeingMetric)>[
      (m.mood, wellbeing.mood),
      (m.sleep, wellbeing.sleep),
      (m.pain, wellbeing.pain),
      (m.stress, wellbeing.stress),
    ];
    final hasAny = rows.any((row) => row.$2.average != null);
    final hasPhaseData = byPhase.values.any((p) => p.hasData);

    return ReportSection(
      number: number,
      title: l10n.sectionWellbeing,
      caption: l10n.sectionWellbeingCaption,
      child: !hasAny
          ? NotEnoughData(message: l10n.wellbeingEmpty)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReportPanel(
                  child: Column(
                    children: [
                      for (var i = 0; i < rows.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppSpacing.lg),
                        _MetricRow(measure: rows[i].$1, metric: rows[i].$2),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      const _RangeKey(),
                    ],
                  ),
                ),
                if (hasPhaseData) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.wellbeingByPhase,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.wellbeingByPhaseCaption,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ReportPanel(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.sm,
                    ),
                    child: _PhaseTable(byPhase: byPhase),
                  ),
                ],
              ],
            ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.measure, required this.metric});

  final _Measure measure;
  final WellbeingMetric metric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final trend = AnalysisLabels.trend(metric.trend);
    final average = metric.average;

    return Semantics(
      label: average == null
          ? l10n.wellbeingSemanticNoData(measure.name, trend.label(l10n))
          : l10n.wellbeingSemantic(
              measure.name,
              Fmt.number(average),
              '${metric.minimum}',
              '${metric.maximum}',
              trend.label(l10n),
            ),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(measure.name, style: textTheme.titleSmall),
                    Text(measure.note, style: textTheme.labelSmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                average == null ? '—' : Fmt.number(average),
                style: AppTypography.statNumber.copyWith(fontSize: 20),
              ),
              Text(
                ' ${l10n.wellbeingAverageShort}',
                style: textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          RangeStrip(
            color: measure.color,
            minimum: metric.minimum,
            maximum: metric.maximum,
            average: average,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.minimum == null
                      ? l10n.wellbeingNoData
                      : [
                          l10n.wellbeingRange(
                            '${metric.minimum}',
                            '${metric.maximum}',
                          ),
                          if (metric.median != null)
                            l10n.wellbeingMedian(Fmt.number(metric.median!)),
                        ].join(' · '),
                  style: AppTypography.figure.copyWith(fontSize: 11.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(trend.icon, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  trend.label(l10n),
                  style: textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeKey extends StatelessWidget {
  const _RangeKey();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    return ExcludeSemantics(
      child: Wrap(
        spacing: 6,
        runSpacing: AppSpacing.xxs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 18,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(context.l10n.wellbeingKeyRange, style: style),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          Text(context.l10n.wellbeingKeyAverage, style: style),
        ],
      ),
    );
  }
}

class _PhaseTable extends StatelessWidget {
  const _PhaseTable({required this.byPhase});

  final Map<String, PhaseWellbeing> byPhase;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final phases = CyclePhaseKind.values;
    final l10n = context.l10n;
    final m = _measures(l10n);
    final measures = <(_Measure, double? Function(PhaseWellbeing))>[
      (m.mood, (p) => p.mood),
      (m.sleep, (p) => p.sleep),
      (m.pain, (p) => p.pain),
      (m.stress, (p) => p.stress),
    ];

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 56),
            for (final phase in phases)
              Expanded(
                child: Semantics(
                  label: phase.fullName(l10n),
                  excludeSemantics: true,
                  child: Column(
                    children: [
                      Container(width: 16, height: 3, color: phase.color),
                      const SizedBox(height: 4),
                      Text(
                        phase.short(l10n),
                        style: textTheme.labelSmall?.copyWith(
                          color: phase.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final (measure, read) in measures)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(measure.name, style: textTheme.labelMedium),
                ),
                for (final phase in phases)
                  Expanded(
                    child: _Cell(
                      value: byPhase[phase.apiValue] == null
                          ? null
                          : read(byPhase[phase.apiValue]!),
                      color: measure.color,
                      semantic: '${measure.name}, ${phase.fullName(l10n)}',
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.value,
    required this.color,
    required this.semantic,
  });

  final double? value;
  final Color color;
  final String semantic;

  @override
  Widget build(BuildContext context) {
    final v = value;
    final strength = v == null ? 0.0 : (v / 5).clamp(0.0, 1.0);
    final dark = strength > 0.62;
    return Semantics(
      label: context.l10n.semanticValue(
        semantic,
        v == null ? context.l10n.wellbeingCellNoData : Fmt.number(v),
      ),
      excludeSemantics: true,
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: v == null
              ? AppColors.background
              : color.withValues(alpha: 0.1 + 0.8 * strength),
          borderRadius: AppRadius.xsRadius,
        ),
        child: Text(
          v == null ? '–' : Fmt.fixed(v, 1),
          style: AppTypography.figure.copyWith(
            fontSize: 12.5,
            color: v == null
                ? AppColors.textFaint
                : dark
                ? AppColors.onPrimary
                : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// The two correlations the backend computes, on a −1…+1 scale.
class CorrelationSection extends StatelessWidget {
  const CorrelationSection({
    super.key,
    required this.number,
    required this.correlations,
  });

  final int number;
  final Correlations correlations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReportSection(
      number: number,
      title: l10n.sectionConnections,
      caption: l10n.sectionConnectionsCaption,
      child: Column(
        children: [
          _CorrelationRow(
            title: l10n.correlationSleepMood,
            result: correlations.sleepMood,
            pair: CorrelationPair.sleepMood,
          ),
          const SizedBox(height: AppSpacing.sm),
          _CorrelationRow(
            title: l10n.correlationStressPain,
            result: correlations.stressPain,
            pair: CorrelationPair.stressPain,
          ),
        ],
      ),
    );
  }
}

class _CorrelationRow extends StatelessWidget {
  const _CorrelationRow({
    required this.title,
    required this.result,
    required this.pair,
  });

  final String title;
  final CorrelationResult? result;
  final CorrelationPair pair;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final label = AnalysisLabels.correlation(l10n, result, pair);

    return ReportPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: textTheme.titleSmall)),
              Text(
                label?.strength ?? l10n.commonNotEnoughData,
                style: textTheme.labelMedium?.copyWith(
                  color: label == null
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (result == null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(l10n.correlationNeedData, style: textTheme.bodySmall),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: l10n.correlationSemantic(
                title,
                Fmt.fixed(result!.correlation, 2),
              ),
              child: CorrelationScale(value: result!.correlation),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label!.description,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              [
                l10n.correlationStats(
                  Fmt.fixed(result!.correlation, 2),
                  Fmt.fixed(result!.pValue, 3),
                ),
                if (result!.pValue > 0.05) l10n.correlationMaybeChance,
              ].join(' · '),
              style: AppTypography.figure.copyWith(fontSize: 11.5),
            ),
          ],
        ],
      ),
    );
  }
}
