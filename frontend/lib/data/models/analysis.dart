class Analysis {
  const Analysis({
    required this.cycle,
    required this.bleeding,
    required this.phase,
    required this.predictions,
    required this.wellbeing,
    required this.symptoms,
    required this.correlations,
  });

  final CycleAnalysis cycle;
  final BleedingAnalysis bleeding;
  final CyclePhase phase;
  final CyclePredictions predictions;
  final WellbeingAnalysis wellbeing;
  final Map<int, SymptomAnalysis> symptoms;
  final Correlations correlations;

  factory Analysis.fromJson(Map<String, dynamic> json) {
    final symptomsJson = _map(json['symptoms']);

    return Analysis(
      cycle: CycleAnalysis.fromJson(_map(json['cycle'])),
      bleeding: BleedingAnalysis.fromJson(_map(json['bleeding'])),
      phase: CyclePhase.fromJson(_map(json['phase'])),
      predictions: CyclePredictions.fromJson(_map(json['predictions'])),
      wellbeing: WellbeingAnalysis.fromJson(_map(json['wellbeing'])),
      symptoms: {
        for (final entry in symptomsJson.entries)
          int.parse(entry.key): SymptomAnalysis.fromJson(_map(entry.value)),
      },
      correlations: Correlations.fromJson(_map(json['correlations'])),
    );
  }
}

class CycleAnalysis {
  const CycleAnalysis({
    required this.cycleLengths,
    required this.averageLength,
    required this.medianLength,
    required this.variability,
    required this.range,
    required this.consecutiveDifferences,
    required this.regularity,
    required this.trend,
  });

  final List<int> cycleLengths;
  final double? averageLength;
  final double? medianLength;
  final double? variability;
  final int? range;
  final List<int>? consecutiveDifferences;
  final String regularity;
  final TrendResult? trend;

  factory CycleAnalysis.fromJson(Map<String, dynamic> json) {
    return CycleAnalysis(
      cycleLengths: _intList(json['cycle_lengths']),
      averageLength: _doubleOrNull(json['average_length']),
      medianLength: _doubleOrNull(json['median_length']),
      variability: _doubleOrNull(json['variability']),
      range: _intOrNull(json['range']),
      consecutiveDifferences: json['consecutive_differences'] == null
          ? null
          : _intList(json['consecutive_differences']),
      regularity: json['regularity'] as String,
      trend: json['trend'] == null
          ? null
          : TrendResult.fromJson(_map(json['trend'])),
    );
  }
}

class BleedingAnalysis {
  const BleedingAnalysis({
    required this.periodDuration,
    required this.averageLevel,
    required this.medianLevel,
    required this.peakLevel,
    required this.intensityScore,
  });

  final int periodDuration;
  final double? averageLevel;
  final double? medianLevel;
  final int? peakLevel;
  final int intensityScore;

  factory BleedingAnalysis.fromJson(Map<String, dynamic> json) {
    return BleedingAnalysis(
      periodDuration: _int(json['period_duration']),
      averageLevel: _doubleOrNull(json['average_level']),
      medianLevel: _doubleOrNull(json['median_level']),
      peakLevel: _intOrNull(json['peak_level']),
      intensityScore: _int(json['intensity_score']),
    );
  }
}

class CyclePhase {
  const CyclePhase({required this.cycleDay, required this.currentPhase});

  final int? cycleDay;
  final String? currentPhase;

  factory CyclePhase.fromJson(Map<String, dynamic> json) {
    return CyclePhase(
      cycleDay: _intOrNull(json['cycle_day']),
      currentPhase: json['current_phase'] as String?,
    );
  }
}

class CyclePredictions {
  const CyclePredictions({
    required this.estimatedCycleLength,
    required this.nextPeriodDate,
    required this.ovulationDay,
    required this.ovulationDate,
    required this.ovulationWindow,
    required this.confidence,
  });

  final int? estimatedCycleLength;
  final DateTime? nextPeriodDate;
  final int? ovulationDay;
  final DateTime? ovulationDate;
  final OvulationWindow? ovulationWindow;
  final PredictionConfidence confidence;

  factory CyclePredictions.fromJson(Map<String, dynamic> json) {
    return CyclePredictions(
      estimatedCycleLength: _intOrNull(json['estimated_cycle_length']),
      nextPeriodDate: _dateOrNull(json['next_period_date']),
      ovulationDay: _intOrNull(json['ovulation_day']),
      ovulationDate: _dateOrNull(json['ovulation_date']),
      ovulationWindow: json['ovulation_window'] == null
          ? null
          : OvulationWindow.fromJson(_map(json['ovulation_window'])),
      confidence: PredictionConfidence.fromJson(_map(json['confidence'])),
    );
  }
}

class OvulationWindow {
  const OvulationWindow({required this.startDay, required this.endDay});

  final int startDay;
  final int endDay;

  factory OvulationWindow.fromJson(Map<String, dynamic> json) {
    return OvulationWindow(
      startDay: _int(json['start_day']),
      endDay: _int(json['end_day']),
    );
  }
}

class PredictionConfidence {
  const PredictionConfidence({required this.score, required this.tier});

  final double score;
  final String tier;

  factory PredictionConfidence.fromJson(Map<String, dynamic> json) {
    return PredictionConfidence(
      score: _double(json['score']),
      tier: json['tier'] as String,
    );
  }
}

class WellbeingAnalysis {
  const WellbeingAnalysis({
    required this.mood,
    required this.pain,
    required this.sleep,
    required this.stress,
  });

  final WellbeingMetric mood;
  final WellbeingMetric pain;
  final WellbeingMetric sleep;
  final WellbeingMetric stress;

  factory WellbeingAnalysis.fromJson(Map<String, dynamic> json) {
    return WellbeingAnalysis(
      mood: WellbeingMetric.fromJson(_map(json['mood'])),
      pain: WellbeingMetric.fromJson(_map(json['pain'])),
      sleep: WellbeingMetric.fromJson(_map(json['sleep'])),
      stress: WellbeingMetric.fromJson(_map(json['stress'])),
    );
  }
}

class WellbeingMetric {
  const WellbeingMetric({
    required this.average,
    required this.median,
    required this.minimum,
    required this.maximum,
    required this.trend,
  });

  final double? average;
  final double? median;
  final int? minimum;
  final int? maximum;
  final TrendResult? trend;

  factory WellbeingMetric.fromJson(Map<String, dynamic> json) {
    return WellbeingMetric(
      average: _doubleOrNull(json['average']),
      median: _doubleOrNull(json['median']),
      minimum: _intOrNull(json['minimum']),
      maximum: _intOrNull(json['maximum']),
      trend: json['trend'] == null
          ? null
          : TrendResult.fromJson(_map(json['trend'])),
    );
  }
}

class TrendResult {
  const TrendResult({
    required this.slope,
    required this.rSquared,
    required this.pValue,
  });

  final double slope;
  final double rSquared;
  final double pValue;

  factory TrendResult.fromJson(Map<String, dynamic> json) {
    return TrendResult(
      slope: _double(json['slope']),
      rSquared: _double(json['r_squared']),
      pValue: _double(json['p_value']),
    );
  }
}

class SymptomAnalysis {
  const SymptomAnalysis({
    required this.dates,
    required this.frequency,
    required this.occurrenceRate,
  });

  final List<DateTime> dates;
  final int frequency;
  final double? occurrenceRate;

  factory SymptomAnalysis.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysis(
      dates: _dateList(json['dates']),
      frequency: _int(json['frequency']),
      occurrenceRate: _doubleOrNull(json['occurrence_rate']),
    );
  }
}

class Correlations {
  const Correlations({required this.sleepMood, required this.stressPain});

  final CorrelationResult? sleepMood;
  final CorrelationResult? stressPain;

  factory Correlations.fromJson(Map<String, dynamic> json) {
    return Correlations(
      sleepMood: json['sleep_mood'] == null
          ? null
          : CorrelationResult.fromJson(_map(json['sleep_mood'])),
      stressPain: json['stress_pain'] == null
          ? null
          : CorrelationResult.fromJson(_map(json['stress_pain'])),
    );
  }
}

class CorrelationResult {
  const CorrelationResult({required this.correlation, required this.pValue});

  final double correlation;
  final double pValue;

  factory CorrelationResult.fromJson(Map<String, dynamic> json) {
    return CorrelationResult(
      correlation: _double(json['correlation']),
      pValue: _double(json['p_value']),
    );
  }
}

Map<String, dynamic> _map(Object? value) => Map<String, dynamic>.from(value! as Map);

int _int(Object? value) => (value as num).toInt();

int? _intOrNull(Object? value) => value == null ? null : _int(value);

double _double(Object? value) => (value as num).toDouble();

double? _doubleOrNull(Object? value) => value == null ? null : _double(value);

DateTime? _dateOrNull(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}

List<int> _intList(Object? value) {
  return (value as List<dynamic>).map(_int).toList();
}

List<DateTime> _dateList(Object? value) {
  return (value as List<dynamic>)
      .map((item) => DateTime.parse(item as String))
      .toList();
}
