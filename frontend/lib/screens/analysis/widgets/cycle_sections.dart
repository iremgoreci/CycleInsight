import 'package:flutter/material.dart';

import '../../../core/presentation/cycle_phase_style.dart';
import '../../../core/presentation/formatters.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/analysis.dart';
import '../../../data/models/cycle.dart';
import '../../../widgets/charts/cycle_length_chart.dart';
import '../../../widgets/confidence_meter.dart';
import '../../daily_logs/daily_log_labels.dart';
import '../analysis_labels.dart';
import 'report_parts.dart';
import '../../../l10n/l10n.dart';

/// Cycle length history, summary statistics and regularity.
class CycleLengthSection extends StatelessWidget {
  const CycleLengthSection({
    super.key,
    required this.number,
    required this.cycle,
    required this.cycles,
  });

  final int number;
  final CycleAnalysis cycle;

  /// Recorded cycles, used only to label each length with its start date.
  final List<Cycle>? cycles;

  @override
  Widget build(BuildContext context) {
    final lengths = cycle.cycleLengths;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    if (lengths.isEmpty) {
      return ReportSection(
        number: number,
        title: l10n.sectionCycleLength,
        child: NotEnoughData(message: l10n.sectionCycleLengthEmpty),
      );
    }

    final regularity = AnalysisLabels.regularity(l10n, cycle.regularity);
    final trend = AnalysisLabels.trend(cycle.trend);
    final shortest = lengths.reduce((a, b) => a < b ? a : b);
    final longest = lengths.reduce((a, b) => a > b ? a : b);

    return ReportSection(
      number: number,
      title: l10n.sectionCycleLength,
      caption: l10n.sectionCycleLengthCaption,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CycleLengthChart(
                  lengths: lengths,
                  labels: _labels(l10n, lengths.length),
                  median: cycle.medianLength,
                ),
                if (cycle.medianLength != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        child: CustomPaint(
                          size: const Size(16, 2),
                          painter: _DashPainter(),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.chartMedian(Fmt.number(cycle.medianLength!)),
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          StatGrid(
            children: [
              StatBlock(
                label: l10n.statAverage,
                value: _num(cycle.averageLength),
                unit: l10n.unitDays,
              ),
              StatBlock(
                label: l10n.statVariability,
                value: cycle.variability == null
                    ? null
                    : '±${Fmt.number(cycle.variability!)}',
                unit: l10n.unitDays,
                note: cycle.variability == null
                    ? null
                    : l10n.statStandardDeviation,
              ),
              StatBlock(
                label: l10n.statRange,
                value: cycle.range?.toString(),
                unit: l10n.unitDays,
                note: cycle.range == null
                    ? null
                    : l10n.statRangeDays(shortest, longest),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _FactRow(
            icon: Icons.timeline,
            label: l10n.regularityLabel,
            value: regularity ?? l10n.regularityNotAssessed,
            detail: AnalysisLabels.regularityExplanation(
              l10n,
              cycle.regularity,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _FactRow(
            icon: trend.icon,
            label: l10n.lengthOverTime,
            value: trend.label(l10n),
            detail: trend == TrendDirection.unavailable
                ? l10n.trendNeedThree
                : trend == TrendDirection.none
                ? l10n.trendNoneDetail
                : l10n.trendDetail,
          ),
        ],
      ),
    );
  }

  /// Labels each length with its starting cycle's date when the recorded
  /// cycles line up with the lengths (n cycles → n−1 lengths).
  List<String> _labels(AppLocalizations l10n, int count) {
    final starts = [...?cycles?.map((c) => c.startDate)]..sort();
    if (starts.length == count + 1) {
      return [
        for (var i = 0; i < count; i++)
          l10n.chartCycleStarting(Fmt.shortDate(starts[i])),
      ];
    }
    return [
      for (var i = 0; i < count; i++) l10n.chartCycleNumber(i + 1, count),
    ];
  }

  static String? _num(double? value) =>
      value == null ? null : Fmt.number(value);
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lavender
      ..strokeWidth = 1.5;
    for (var x = 0.0; x < size.width; x += 7) {
      canvas.drawLine(Offset(x, 1), Offset(x + 3.5, 1), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => false;
}

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$label  ', style: textTheme.labelMedium),
                    TextSpan(text: value, style: textTheme.titleSmall),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(detail, style: textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

/// Estimated dates and how much to trust them.
class PredictionSection extends StatelessWidget {
  const PredictionSection({
    super.key,
    required this.number,
    required this.predictions,
    required this.phase,
  });

  final int number;
  final CyclePredictions predictions;
  final CyclePhase phase;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final current = CyclePhaseKind.fromApi(phase.currentPhase);

    if (predictions.estimatedCycleLength == null) {
      return ReportSection(
        number: number,
        title: l10n.sectionPredictions,
        child: NotEnoughData(
          message: phase.cycleDay == null
              ? l10n.predictionsEmptyNoCycle
              : l10n.predictionsEmptyDay(phase.cycleDay!),
        ),
      );
    }

    final confidence = predictions.confidence;
    final window = predictions.ovulationWindow;

    return ReportSection(
      number: number,
      title: l10n.sectionPredictions,
      caption: l10n.sectionPredictionsCaption,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (phase.cycleDay != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.predictionsToday(phase.cycleDay!),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (current != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: current.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            l10n.predictionsCurrentPhase(
                              current.fullName(l10n),
                            ),
                            style: textTheme.bodyLarge?.copyWith(
                              color: current.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ReportPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _PredictionRow(
                  color: PhaseColors.menstrual,
                  label: l10n.predictionsNextPeriod,
                  value: predictions.nextPeriodDate == null
                      ? l10n.commonNotEnoughData
                      : Fmt.date(predictions.nextPeriodDate!),
                  detail: predictions.nextPeriodDate == null
                      ? null
                      : Fmt.relativeDay(l10n, predictions.nextPeriodDate!),
                ),
                const Divider(indent: AppSpacing.md),
                _PredictionRow(
                  color: PhaseColors.ovulatory,
                  label: l10n.predictionsOvulation,
                  value: predictions.ovulationDate == null
                      ? l10n.commonNotEnoughData
                      : Fmt.date(predictions.ovulationDate!),
                  detail: [
                    if (predictions.ovulationDay != null)
                      l10n.predictionsCycleDay(predictions.ovulationDay!),
                    if (window != null)
                      l10n.predictionsWindow(window.startDay, window.endDay),
                  ].join(' · '),
                ),
                const Divider(indent: AppSpacing.md),
                _PredictionRow(
                  color: AppColors.primary,
                  label: l10n.predictionsEstimatedLength,
                  value: l10n.daysCount(predictions.estimatedCycleLength!),
                  detail: l10n.predictionsMedianNote,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xxs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConfidenceMeter(tier: confidence.tier),
              Text(
                l10n.confidenceLabel(
                  ConfidenceMeter.tierLabel(l10n, confidence.tier),
                ),
                style: textTheme.titleSmall,
              ),
              Text(Fmt.percent(confidence.score), style: AppTypography.figure),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(l10n.predictionsConfidenceBasis, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PredictionRow extends StatelessWidget {
  const _PredictionRow({
    required this.color,
    required this.label,
    required this.value,
    this.detail,
  });

  final Color color;
  final String label;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(value, style: textTheme.titleMedium),
                if (detail != null && detail!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(detail!, style: textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bleeding summary from all logged check-ins.
class BleedingSection extends StatelessWidget {
  const BleedingSection({
    super.key,
    required this.number,
    required this.bleeding,
  });

  final int number;
  final BleedingAnalysis bleeding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (bleeding.periodDuration == 0) {
      return ReportSection(
        number: number,
        title: l10n.sectionBleeding,
        child: NotEnoughData(message: l10n.bleedingEmpty),
      );
    }

    final labels = DailyLogLabels(l10n);
    String? levelLabel(num? level) => level == null
        ? null
        : labels.bleeding[level.round()] ?? Fmt.number(level);

    return ReportSection(
      number: number,
      title: l10n.sectionBleeding,
      caption: l10n.sectionBleedingCaption,
      child: StatGrid(
        children: [
          StatBlock(
            label: l10n.bleedingDaysLogged,
            value: '${bleeding.periodDuration}',
            unit: l10n.unitDays,
          ),
          StatBlock(
            label: l10n.bleedingAverageLevel,
            value: bleeding.averageLevel == null
                ? null
                : Fmt.number(bleeding.averageLevel!),
            unit: l10n.unitOutOfFive,
            note: levelLabel(bleeding.averageLevel),
          ),
          StatBlock(
            label: l10n.bleedingPeakLevel,
            value: bleeding.peakLevel?.toString(),
            unit: l10n.unitOutOfFive,
            note: levelLabel(bleeding.peakLevel),
          ),
          StatBlock(
            label: l10n.bleedingIntensityScore,
            value: '${bleeding.intensityScore}',
            note: l10n.bleedingIntensityNote,
          ),
        ],
      ),
    );
  }
}
