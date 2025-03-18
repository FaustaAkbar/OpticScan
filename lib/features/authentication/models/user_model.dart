class User {
  final int? id;
  final String name;
  final String email;
  final String? userType;
  final DateTime? birthdate;

  User({
    this.id,
    required this.name,
    required this.email,
    this.userType,
    this.birthdate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'birthdate': birthdate?.toIso8601String(),
    };
  }
}
