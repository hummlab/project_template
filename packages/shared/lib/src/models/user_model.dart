/// User model representing a user entity in the application
/// 
/// This model contains all the essential information about a user
/// and provides serialization/deserialization capabilities.
class User {
  /// Unique identifier for the user
  final String id;
  
  /// User's email address
  final String email;
  
  /// User's display name
  final String name;
  
  /// User's role in the system
  final String role;
  
  /// Timestamp when the user was created
  final DateTime createdAt;
  
  /// Timestamp when the user was last updated
  final DateTime updatedAt;

  /// Creates a new User instance
  /// 
  /// [id] - Unique identifier for the user
  /// [email] - User's email address
  /// [name] - User's display name
  /// [role] - User's role in the system
  /// [createdAt] - Timestamp when the user was created
  /// [updatedAt] - Timestamp when the user was last updated
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  /// Converts the User instance to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Creates a copy of this User with optionally updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.role == role &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        role.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
  
  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
