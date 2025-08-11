class Task {
  final String id;
  final String title;
  final String? description;
  final String status;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = 'OPEN',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'] ?? 'OPEN',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'status': status,
      };
}