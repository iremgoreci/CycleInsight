class DailyLogSymptom {
  const DailyLogSymptom({
    required this.id,
    required this.dailyLogId,
    required this.symptomTypeId,
  });

  final int id;
  final int dailyLogId;
  final int symptomTypeId;

  factory DailyLogSymptom.fromJson(Map<String, dynamic> json) {
    return DailyLogSymptom(
      id: json['id'] as int,
      dailyLogId: json['daily_log_id'] as int,
      symptomTypeId: json['symptom_type_id'] as int,
    );
  }
}
