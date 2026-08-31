import 'symptom_type.dart';

class DailyLog {
  const DailyLog({
    required this.id,
    required this.logDate,
    required this.bleedingLevel,
    required this.moodLevel,
    required this.painLevel,
    required this.sleepQuality,
    required this.stressLevel,
    this.notes,
    this.symptoms = const [],
  });

  final int id;
  final DateTime logDate;
  final int bleedingLevel;
  final int moodLevel;
  final int painLevel;
  final int sleepQuality;
  final int stressLevel;
  final String? notes;
  final List<SymptomType> symptoms;

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'] as int,
      logDate: DateTime.parse(json['log_date'] as String),
      bleedingLevel: json['bleeding_level'] as int,
      moodLevel: json['mood_level'] as int,
      painLevel: json['pain_level'] as int,
      sleepQuality: json['sleep_quality'] as int,
      stressLevel: json['stress_level'] as int,
      notes: json['notes'] as String?,
    );
  }

  DailyLog copyWithSymptoms(List<SymptomType> symptoms) {
    return DailyLog(
      id: id,
      logDate: logDate,
      bleedingLevel: bleedingLevel,
      moodLevel: moodLevel,
      painLevel: painLevel,
      sleepQuality: sleepQuality,
      stressLevel: stressLevel,
      notes: notes,
      symptoms: symptoms,
    );
  }
}
