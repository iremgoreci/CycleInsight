import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/analysis.dart';
import '../../data/models/symptom_type.dart';
import '../../state/analysis_provider.dart';
import '../../state/symptom_provider.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  static final _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(analysisProvider);
    final symptomTypes = ref.watch(symptomTypesProvider);

    return analysis.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _AnalysisLoadError(
        message: _errorMessage(error),
        onRetry: () => ref.read(analysisProvider.notifier).refresh(),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.read(analysisProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _CurrentCycleSection(phase: data.phase),
            const SizedBox(height: 16),
            _PredictionsSection(predictions: data.predictions),
            const SizedBox(height: 16),
            _CycleSummarySection(cycle: data.cycle),
            const SizedBox(height: 16),
            _BleedingSummarySection(bleeding: data.bleeding),
            const SizedBox(height: 16),
            _WellbeingSummarySection(wellbeing: data.wellbeing),
            const SizedBox(height: 16),
            _SymptomsSummarySection(
              symptoms: data.symptoms,
              symptomTypes: symptomTypes,
            ),
            const SizedBox(height: 16),
            _CorrelationsSummarySection(correlations: data.correlations),
          ],
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    return error is ApiException ? error.message : 'Unable to load analysis';
  }
}

class _CurrentCycleSection extends StatelessWidget {
  const _CurrentCycleSection({required this.phase});

  final CyclePhase phase;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Current cycle',
      icon: Icons.today_outlined,
      children: [
        _AnalysisValueRow(
          label: 'Cycle day',
          value: phase.cycleDay == null
              ? null
              : 'Day ${phase.cycleDay}',
        ),
        _AnalysisValueRow(
          label: 'Current phase',
          value: _phaseLabel(phase.currentPhase),
        ),
      ],
    );
  }
}

class _PredictionsSection extends StatelessWidget {
  const _PredictionsSection({required this.predictions});

  final CyclePredictions predictions;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Predictions',
      icon: Icons.auto_graph_outlined,
      subtitle: 'These are estimates based on your recorded cycle history.',
      children: [
        _AnalysisValueRow(
          label: 'Estimated cycle length',
          value: predictions.estimatedCycleLength == null
              ? null
              : '${predictions.estimatedCycleLength} days',
        ),
        _AnalysisValueRow(
          label: 'Estimated next period',
          value: _formatDate(predictions.nextPeriodDate),
        ),
        _AnalysisValueRow(
          label: 'Estimated ovulation day',
          value: predictions.ovulationDay == null
              ? null
              : 'Day ${predictions.ovulationDay}',
        ),
        _AnalysisValueRow(
          label: 'Estimated ovulation date',
          value: _formatDate(predictions.ovulationDate),
        ),
        _AnalysisValueRow(
          label: 'Estimated ovulation window',
          value: _ovulationWindowLabel(predictions.ovulationWindow),
        ),
        _AnalysisValueRow(
          label: 'Prediction confidence',
          value: _confidenceLabel(predictions.confidence),
        ),
      ],
    );
  }
}

class _CycleSummarySection extends StatelessWidget {
  const _CycleSummarySection({required this.cycle});

  final CycleAnalysis cycle;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Cycle summary',
      icon: Icons.insights_outlined,
      children: [
        _AnalysisValueRow(
          label: 'Average cycle length',
          value: _daysLabel(cycle.averageLength),
        ),
        _AnalysisValueRow(
          label: 'Median cycle length',
          value: _daysLabel(cycle.medianLength),
        ),
        _AnalysisValueRow(
          label: 'Regularity',
          value: _regularityLabel(cycle.regularity),
        ),
        _AnalysisValueRow(
          label: 'Variability',
          value: _daysLabel(cycle.variability),
        ),
        _AnalysisValueRow(
          label: 'Range',
          value: cycle.range == null ? null : '${cycle.range} days',
        ),
      ],
    );
  }
}

class _BleedingSummarySection extends StatelessWidget {
  const _BleedingSummarySection({required this.bleeding});

  final BleedingAnalysis bleeding;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Bleeding summary',
      icon: Icons.water_drop_outlined,
      children: [
        _AnalysisValueRow(
          label: 'Period duration',
          value: bleeding.periodDuration == 0
              ? null
              : '${bleeding.periodDuration} logged days',
        ),
        _AnalysisValueRow(
          label: 'Average level',
          value: _levelLabel(bleeding.averageLevel),
        ),
        _AnalysisValueRow(
          label: 'Median level',
          value: _levelLabel(bleeding.medianLevel),
        ),
        _AnalysisValueRow(
          label: 'Peak level',
          value: bleeding.peakLevel?.toString(),
        ),
        _AnalysisValueRow(
          label: 'Intensity score',
          value: bleeding.intensityScore == 0
              ? null
              : bleeding.intensityScore.toString(),
        ),
      ],
    );
  }
}

class _WellbeingSummarySection extends StatelessWidget {
  const _WellbeingSummarySection({required this.wellbeing});

  final WellbeingAnalysis wellbeing;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Wellbeing summary',
      icon: Icons.favorite_outline,
      subtitle: 'Based on your recorded daily logs.',
      children: [
        _WellbeingMetricSummary(label: 'Mood', metric: wellbeing.mood),
        const Divider(),
        _WellbeingMetricSummary(label: 'Pain', metric: wellbeing.pain),
        const Divider(),
        _WellbeingMetricSummary(label: 'Sleep', metric: wellbeing.sleep),
        const Divider(),
        _WellbeingMetricSummary(label: 'Stress', metric: wellbeing.stress),
      ],
    );
  }
}

class _WellbeingMetricSummary extends StatelessWidget {
  const _WellbeingMetricSummary({required this.label, required this.metric});

  final String label;
  final WellbeingMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        _AnalysisValueRow(label: 'Average', value: _levelLabel(metric.average)),
        _AnalysisValueRow(label: 'Median', value: _levelLabel(metric.median)),
        _AnalysisValueRow(
          label: 'Minimum',
          value: metric.minimum?.toString(),
        ),
        _AnalysisValueRow(
          label: 'Maximum',
          value: metric.maximum?.toString(),
        ),
        _AnalysisValueRow(
          label: 'Trend',
          value: _trendLabel(metric.trend),
        ),
      ],
    );
  }
}

class _SymptomsSummarySection extends StatelessWidget {
  const _SymptomsSummarySection({
    required this.symptoms,
    required this.symptomTypes,
  });

  final Map<int, SymptomAnalysis> symptoms;
  final AsyncValue<List<SymptomType>> symptomTypes;

  @override
  Widget build(BuildContext context) {
    if (symptoms.isEmpty) {
      return const _AnalysisSection(
        title: 'Symptoms summary',
        icon: Icons.healing_outlined,
        children: [Text('No symptoms have been recorded yet.')],
      );
    }

    return symptomTypes.when(
      loading: () => const _AnalysisSection(
        title: 'Symptoms summary',
        icon: Icons.healing_outlined,
        children: [Text('Loading symptom names...')],
      ),
      error: (_, _) => const _AnalysisSection(
        title: 'Symptoms summary',
        icon: Icons.healing_outlined,
        children: [Text('Symptom names are currently unavailable.')],
      ),
      data: (types) {
        final namesById = {for (final type in types) type.id: type.name};
        final entries = symptoms.entries.toList()
          ..sort(
            (first, second) => (namesById[first.key] ?? 'Unknown symptom')
                .compareTo(namesById[second.key] ?? 'Unknown symptom'),
          );

        return _AnalysisSection(
          title: 'Symptoms summary',
          icon: Icons.healing_outlined,
          children: [
            for (final entry in entries)
              _AnalysisValueRow(
                label: namesById[entry.key] ?? 'Unknown symptom',
                value: _symptomSummaryLabel(entry.value),
              ),
          ],
        );
      },
    );
  }
}

class _CorrelationsSummarySection extends StatelessWidget {
  const _CorrelationsSummarySection({required this.correlations});

  final Correlations correlations;

  @override
  Widget build(BuildContext context) {
    return _AnalysisSection(
      title: 'Correlations summary',
      icon: Icons.compare_arrows_outlined,
      subtitle: 'These describe associations in your logs, not causes.',
      children: [
        _AnalysisValueRow(
          label: 'Sleep and mood',
          value: _correlationLabel(correlations.sleepMood),
        ),
        _AnalysisValueRow(
          label: 'Stress and pain',
          value: _correlationLabel(correlations.stressPain),
        ),
      ],
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  const _AnalysisSection({
    required this.title,
    required this.icon,
    required this.children,
    this.subtitle,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AnalysisValueRow extends StatelessWidget {
  const _AnalysisValueRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value ?? 'Not enough data',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: value == null ? theme.colorScheme.onSurfaceVariant : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisLoadError extends StatelessWidget {
  const _AnalysisLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

String? _formatDate(DateTime? date) {
  return date == null ? null : AnalysisScreen._dateFormat.format(date);
}

String? _phaseLabel(String? phase) {
  if (phase == null) {
    return null;
  }

  return switch (phase) {
    'menstrual' => 'Menstrual',
    'follicular' => 'Follicular',
    'ovulatory' => 'Ovulatory',
    'luteal' => 'Luteal',
    _ => phase,
  };
}

String? _ovulationWindowLabel(OvulationWindow? window) {
  return window == null ? null : 'Cycle days ${window.startDay}-${window.endDay}';
}

String _confidenceLabel(PredictionConfidence confidence) {
  final tier = confidence.tier.isEmpty
      ? 'Not enough data'
      : '${confidence.tier[0].toUpperCase()}${confidence.tier.substring(1)}';
  return '$tier (${(confidence.score * 100).toStringAsFixed(0)}%)';
}

String? _daysLabel(double? value) {
  if (value == null) {
    return null;
  }

  final formatted = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return '$formatted days';
}

String? _levelLabel(double? value) {
  if (value == null) {
    return null;
  }

  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

String? _trendLabel(TrendResult? trend) {
  if (trend == null) {
    return null;
  }

  if (trend.slope > 0.01) {
    return 'Increasing';
  }
  if (trend.slope < -0.01) {
    return 'Decreasing';
  }
  return 'Stable';
}

String _symptomSummaryLabel(SymptomAnalysis symptom) {
  final frequencyLabel = '${symptom.frequency} '
      '${symptom.frequency == 1 ? 'time' : 'times'}';
  final occurrenceRate = symptom.occurrenceRate;
  if (occurrenceRate == null) {
    return frequencyLabel;
  }

  return '$frequencyLabel · ${(occurrenceRate * 100).toStringAsFixed(0)}% of logged days';
}

String? _correlationLabel(CorrelationResult? correlation) {
  if (correlation == null) {
    return null;
  }

  final direction = correlation.correlation < 0 ? 'negative' : 'positive';
  final magnitude = correlation.correlation.abs();
  final strength = switch (magnitude) {
    < 0.1 => 'Negligible',
    < 0.3 => 'Weak',
    < 0.5 => 'Moderate',
    _ => 'Strong',
  };

  return '$strength $direction '
      '(r = ${correlation.correlation.toStringAsFixed(2)}, '
      'p = ${correlation.pValue.toStringAsFixed(3)})';
}

String? _regularityLabel(String regularity) {
  return switch (regularity) {
    'regular' => 'Regular',
    'irregular' => 'Irregular',
    'insufficient_data' || 'not_assessed' => null,
    _ => regularity,
  };
}
