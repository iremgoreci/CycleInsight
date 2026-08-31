class Cycle {
  const Cycle({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
  });

  final int id;
  final int userId;
  final DateTime startDate;
  final DateTime? endDate;

  bool get isOngoing => endDate == null;

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
    );
  }
}
