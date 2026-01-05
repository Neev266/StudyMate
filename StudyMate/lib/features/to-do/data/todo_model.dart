class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool completed; // ✅ ADD

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completed': completed, // ✅
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      completed: map['completed'] ?? false, // ✅
    );
  }
}
