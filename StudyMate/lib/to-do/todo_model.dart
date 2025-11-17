class Todo {
  final String id; // Firestore document ID
  final String title;
  final String description;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Convert Todo to Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Todo object from Firestore document
  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}