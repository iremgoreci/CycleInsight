class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
