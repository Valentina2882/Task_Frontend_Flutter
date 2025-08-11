/// Modelo que representa un usuario en la aplicación
/// Contiene los datos básicos del usuario autenticado
class User {
  final int id;
  final String username;
  final String? accessToken;

  User({
    required this.id,
    required this.username,
    this.accessToken,
  });

  /// Constructor que crea un User desde un JSON
  /// Útil para deserializar respuestas del backend
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      accessToken: json['accessToken'],
    );
  }

  /// Convierte el User a un Map para serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'accessToken': accessToken,
    };
  }

  /// Crea una copia del User con nuevos valores
  User copyWith({
    int? id,
    String? username,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username)';
  }
}
