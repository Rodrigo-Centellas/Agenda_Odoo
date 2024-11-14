// models/user_model.dart
class User {
  final int userId; // ID de la tabla res.users
  final int id;     // ID de la tabla específica del rol (student, parent, etc.)
  final String name;
  final String email;
  final String role;
  final int? classroomId;
  final List<int>? childrenIds;

  User({
    required this.userId,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.classroomId,
    this.childrenIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      classroomId: json['classroom_id'] as int?,
      childrenIds: (json['children_ids'] as List?)?.map((e) => e as int).toList(),
    );
  }
}
