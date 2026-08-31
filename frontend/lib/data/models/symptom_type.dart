class SymptomType {
  const SymptomType({required this.id, required this.name});

  final int id;
  final String name;

  factory SymptomType.fromJson(Map<String, dynamic> json) {
    return SymptomType(id: json['id'] as int, name: json['name'] as String);
  }
}
