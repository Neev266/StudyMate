import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'note_model.dart'; 

class NotesService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Note> _notes = [];
  List<Note> get notes => List.unmodifiable(_notes);

  NotesService() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _notes.clear();
        notifyListeners();
      } else {
        _loadNotes();
      }
    });
  }

  Future<void> _loadNotes() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (kDebugMode) print('Loading notes for user: ${user.uid}');

    final snapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();

    _notes
      ..clear()
      ..addAll(snapshot.docs.map((doc) => Note.fromMap(doc.id, doc.data())));

    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final docRef = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .add({
      'title': title,
      'content': content,
      'createdAt': now.toIso8601String(),
      'updatedAt': null,
    });

    _notes.insert(
      0,
      Note(
        id: docRef.id,
        title: title,
        content: content,
        createdAt: now,
      ),
    );
    notifyListeners();
  }

  Future<void> updateNote(String id, String newTitle, String newContent) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({
      'title': newTitle,
      'content': newContent,
      'updatedAt': now.toIso8601String(),
    });

    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: id,
        title: newTitle,
        content: newContent,
        createdAt: _notes[index].createdAt,
        updatedAt: now,
      );
      notifyListeners();
    }
  }

  Future<void> deleteNoteAt(int index) async {
    final user = _auth.currentUser;
    if (user == null || index < 0 || index >= _notes.length) return;

    final note = _notes[index];
    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .doc(note.id)
        .delete();

    _notes.removeAt(index);
    notifyListeners();
  }

  Future<void> clearAllNotes() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _firestore.batch();
    final notesCollection =
        _firestore.collection('Users').doc(user.uid).collection('notes');

    for (var note in _notes) {
      batch.delete(notesCollection.doc(note.id));
    }

    await batch.commit();
    _notes.clear();
    notifyListeners();
  }
}
