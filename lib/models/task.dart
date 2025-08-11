/// Modelo que representa una tarea en la aplicación
/// Contiene todos los datos necesarios para gestionar tareas
class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final int userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.userId,
  });

  /// Constructor que crea un Task desde un JSON
  /// Útil para deserializar respuestas del backend
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TaskStatus.OPEN,
      ),
      userId: json['userId'],
    );
  }

  /// Convierte el Task a un Map para serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'userId': userId,
    };
  }

  /// Crea una copia del Task con nuevos valores
  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status)';
  }
}

/// Enum que define los posibles estados de una tarea
/// Corresponde con los estados definidos en el backend
enum TaskStatus {
  OPEN,
  IN_PROGRESS,
  DONE,
}

/// Extensión para obtener el texto en español de cada estado
extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.OPEN:
        return 'Abierta';
      case TaskStatus.IN_PROGRESS:
        return 'En Progreso';
      case TaskStatus.DONE:
        return 'Completada';
    }
  }

  /// Obtiene el color correspondiente a cada estado
  String get color {
    switch (this) {
      case TaskStatus.OPEN:
        return '#FF6B6B'; // Rojo
      case TaskStatus.IN_PROGRESS:
        return '#4ECDC4'; // Verde azulado
      case TaskStatus.DONE:
        return '#45B7D1'; // Azul
    }
  }
}
