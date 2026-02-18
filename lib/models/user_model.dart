class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarPath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarPath,
  });

  // Convertir a JSON para guardar
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarPath': avatarPath,
    };
  }

  // Crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarPath: json['avatarPath'],
    );
  }

  // Crear copia con cambios
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarPath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}