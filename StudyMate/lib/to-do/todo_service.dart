import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class TodoService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Todo> _todos = [];
  List<Todo> get todos => List.unmodifiable(_todos);

  TodoService() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _todos.clear();
        notifyListeners();
      } else {
        _loadTodos();
      }
    });
  }

  // Loads todos from Firestore for current user
  Future<void> _loadTodos() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (kDebugMode) {
      print('Loading todos for user: ${user.uid}');
    }

    final snapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .get();

    _todos.clear();
    _todos.addAll(snapshot.docs
        .map((doc) => Todo.fromMap(doc.id, doc.data()))
        .toList());

    notifyListeners();
  }

  // Add a new todo
  Future<void> addTodo(String title, String description) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final docRef = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('todos')
        .add({
      'title': title,
      'description': description,
      'createdAt': now.toIso8601String(),
    });

    _todos.insert(
      0,
      Todo(
        id: docRef.id,
        title: title,
        description: description,
        createdAt: now,
      ),
    );

    notifyListeners();
  }

  // Update an existing todo
  Future<void> updateTodo(String id, String newTitle, String newDescription) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return; // Todo not found locally

    // Update Firestore
    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('todos')
        .doc(id)
        .update({
      'title': newTitle,
      'description': newDescription,
    });

    // Update local list
    _todos[todoIndex] = Todo(
      id: id,
      title: newTitle,
      description: newDescription,
      createdAt: _todos[todoIndex].createdAt,
    );

    notifyListeners();
  }

  // Delete a todo
  Future<void> removeTodoAt(int index) async {
    final user = _auth.currentUser;
    if (user == null || index < 0 || index >= _todos.length) return;

    final todo = _todos[index];

    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('todos')
        .doc(todo.id)
        .delete();

    _todos.removeAt(index);
    notifyListeners();
  }

  // Clear all todos
  Future<void> clearAll() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _firestore.batch();
    final todosCollection =
        _firestore.collection('Users').doc(user.uid).collection('todos');

    for (var todo in _todos) {
      final docRef = todosCollection.doc(todo.id);
      batch.delete(docRef);
    }

    await batch.commit();
    _todos.clear();
    notifyListeners();
  }
}
