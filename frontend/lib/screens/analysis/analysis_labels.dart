import 'package:flutter/material.dart';

import '../../core/presentation/cycle_phase_style.dart';
import '../../data/models/analysis.dart';
import '../../l10n/l10n.dart';

/// Wording for analysis values. Presentation only — every number shown is
/// taken from the API response.
class AnalysisLabels {
  const AnalysisLabels._();

  static String? regularity(AppLocalizations l10n, String regularity) {
    return switch (regularity) {
      'regular' => l10n.regularityRegular,
      'irregular' => l10n.regularityIrregular,
      _ => null,
    };
  }

  static String regularityExplanation(
    AppLocalizations l10n,
    String regularity,
  ) {
    return switch (regularity) {
      'regular' => l10n.regularityExplainRegular,
      'irregular' => l10n.regularityExplainIrregular,
      'not_assessed' => l10n.regularityExplainNotAssessed,
      _ => l10n.regularityExplainInsufficient,
    };
  }

  /// A trend is described only when it meets the same thresholds the
  /// backend uses before generating a trend insight (r² ≥ 0.5, p ≤ 0.05).
  static TrendDirection trend(TrendResult? trend) {
    if (trend == null) {
      return TrendDirection.unavailable;
    }
    if (trend.rSquared < 0.5 || trend.pValue > 0.05) {
      return TrendDirection.none;
    }
    if (trend.slope > 0) {
      return TrendDirection.up;
    }
    if (trend.slope < 0) {
      return TrendDirection.down;
    }
    return TrendDirection.none;
  }

  static ({String strength, String description})? correlation(
    AppLocalizations l10n,
    CorrelationResult? result,
    CorrelationPair pair,
  ) {
    if (result == null) {
      return null;
    }
    final r = result.correlation;
    final magnitude = r.abs();
    final strength = switch (magnitude) {
      < 0.1 => l10n.correlationNegligible,
      < 0.3 => l10n.correlationWeak,
      < 0.5 => l10n.correlationModerate,
      _ => l10n.correlationStrong,
    };
    final none = magnitude < 0.1;
    final description = switch (pair) {
      CorrelationPair.sleepMood =>
        none
            ? l10n.correlationSleepMoodNone
            : r > 0
            ? l10n.correlationSleepMoodUp
            : l10n.correlationSleepMoodDown,
      CorrelationPair.stressPain =>
        none
            ? l10n.correlationStressPainNone
            : r > 0
            ? l10n.correlationStressPainUp
            : l10n.correlationStressPainDown,
    };
    return (
      strength: none
          ? strength
          : r > 0
          ? l10n.correlationStrengthPositive(strength)
          : l10n.correlationStrengthNegative(strength),
      description: description,
    );
  }

  static IconData insightIcon(String type) {
    return switch (type) {
      'cycle_pattern' => Icons.timeline,
      'cycle_trend' => Icons.trending_up,
      'prediction' => Icons.event_outlined,
      'bleeding_intensity' => Icons.water_drop_outlined,
      'symptom_pattern' => Icons.healing_outlined,
      'wellbeing_trend' => Icons.show_chart,
      'correlation' => Icons.compare_arrows,
      _ => Icons.lightbulb_outline,
    };
  }
}

enum CorrelationPair { sleepMood, stressPain }

enum TrendDirection {
  up(Icons.north_east),
  down(Icons.south_east),
  none(Icons.east),
  unavailable(Icons.remove);

  const TrendDirection(this.icon);

  final IconData icon;

  String label(AppLocalizations l10n) => switch (this) {
    TrendDirection.up => l10n.trendUp,
    TrendDirection.down => l10n.trendDown,
    TrendDirection.none => l10n.trendNone,
    TrendDirection.unavailable => l10n.trendUnavailable,
  };
}

/// Localized text for the backend's generated insights.
///
/// The API returns insight `type`, an English `title` and an English
/// `message`. To show them in the app language without changing the API,
/// each known insight is rebuilt from the same analysis values and rules
/// the backend uses (`app/analysis/insight_generation.py`). Anything not
/// recognised falls back to the API's own text, so a new backend insight
/// type still appears rather than disappearing.
class InsightText {
  const InsightText._();

  static ({String title, String message}) of(
    AppLocalizations l10n,
    Insight insight,
    Analysis analysis, {
    Map<int, String>? symptomNames,
  }) {
    final fallback = (title: insight.title, message: insight.message);

    switch (insight.type) {
      case 'cycle_pattern':
        final message = switch (analysis.cycle.regularity) {
          'regular' => l10n.insightCycleRegular,
          'irregular' => l10n.insightCycleIrregular,
          _ => null,
        };
        return message == null
            ? fallback
            : (title: l10n.insightCyclePatternTitle, message: message);

      case 'cycle_trend':
        final slope = analysis.cycle.trend?.slope;
        if (slope == null || slope == 0) {
          return fallback;
        }
        return (
          title: l10n.insightCycleTrendTitle,
          message: slope > 0
              ? l10n.insightCycleTrendUp
              : l10n.insightCycleTrendDown,
        );

      case 'prediction':
        final days = analysis.predictions.estimatedCycleLength;
        if (days == null) {
          return fallback;
        }
        return (
          title: l10n.insightPredictionTitle,
          message: analysis.predictions.confidence.tier == 'low'
              ? l10n.insightPredictionLow(days)
              : l10n.insightPredictionBased(days),
        );

      case 'bleeding_intensity':
        // Two variants share this type; the backend titles are fixed.
        return switch (insight.title) {
          'Bleeding intensity' => (
            title: l10n.insightBleedingIntensityTitle,
            message: l10n.insightBleedingHighAverage,
          ),
          'Peak bleeding level' => (
            title: l10n.insightPeakBleedingTitle,
            message: l10n.insightPeakBleeding,
          ),
          _ => fallback,
        };

      case 'symptom_pattern':
        final names = symptomNames;
        if (names == null) {
          return fallback;
        }
        // Same selection and order as the backend: frequency >= 2,
        // most frequent first (stable for ties).
        final recurring =
            analysis.symptoms.entries
                .where((entry) => entry.value.frequency >= 2)
                .toList()
              ..sort((a, b) => b.value.frequency.compareTo(a.value.frequency));
        if (recurring.isEmpty) {
          return fallback;
        }
        final sentences = [
          for (final entry in recurring)
            _symptomSentence(
              l10n,
              names[entry.key] ?? l10n.symptomsUnknown,
              entry.value,
            ),
        ];
        return (title: l10n.insightSymptomTitle, message: sentences.join(' '));

      case 'wellbeing_trend':
        // The backend title is "<Metric> trend".
        final key = insight.title.split(' ').first.toLowerCase();
        final metric = switch (key) {
          'mood' => (
            l10n.metricMood,
            l10n.insightMetricMood,
            analysis.wellbeing.mood,
          ),
          'pain' => (
            l10n.metricPain,
            l10n.insightMetricPain,
            analysis.wellbeing.pain,
          ),
          'sleep' => (
            l10n.metricSleep,
            l10n.insightMetricSleep,
            analysis.wellbeing.sleep,
          ),
          'stress' => (
            l10n.metricStress,
            l10n.insightMetricStress,
            analysis.wellbeing.stress,
          ),
          _ => null,
        };
        final slope = metric?.$3.trend?.slope;
        if (metric == null || slope == null || slope == 0) {
          return fallback;
        }
        return (
          title: l10n.insightWellbeingTitle(metric.$1),
          message: slope > 0
              ? l10n.insightWellbeingUp(metric.$2)
              : l10n.insightWellbeingDown(metric.$2),
        );

      case 'correlation':
        return switch (insight.title) {
          'Sleep and mood' => _correlation(
            l10n.correlationSleepMood,
            analysis.correlations.sleepMood,
            l10n.insightSleepMoodPositive,
            l10n.insightSleepMoodNegative,
            fallback,
          ),
          'Stress and pain' => _correlation(
            l10n.correlationStressPain,
            analysis.correlations.stressPain,
            l10n.insightStressPainPositive,
            l10n.insightStressPainNegative,
            fallback,
          ),
          _ => fallback,
        };

      default:
        return fallback;
    }
  }

  static String _symptomSentence(
    AppLocalizations l10n,
    String name,
    SymptomAnalysis symptom,
  ) {
    final phase = CyclePhaseKind.fromApi(symptom.mostCommonPhase);
    return phase == null
        ? l10n.insightSymptomNoPhase(name, symptom.frequency)
        : l10n.insightSymptomWithPhase(
            name,
            symptom.frequency,
            phase.fullName(l10n),
          );
  }

  static ({String title, String message}) _correlation(
    String title,
    CorrelationResult? result,
    String positive,
    String negative,
    ({String title, String message}) fallback,
  ) {
    if (result == null || result.correlation == 0) {
      return fallback;
    }
    return (
      title: title,
      message: result.correlation > 0 ? positive : negative,
    );
  }
}
