import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Note> _notes = [];
  List<Note> get notes => List.unmodifiable(_notes);

  /// ---------------- LOAD NOTES ----------------
  Future<void> loadNotes() async {
    final user = _auth.currentUser;
    if (user == null) {
      _notes.clear();
      return;
    }

    final snapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();

    _notes
      ..clear()
      ..addAll(
        snapshot.docs.map(
          (doc) => Note.fromMap(doc.id, doc.data()),
        ),
      );
  }

  /// ---------------- ADD NOTE ----------------
  Future<void> addNote(
    String title,
    String content,
    List<Attachment> attachments,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toIso8601String();

    final docRef = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .add({
      'title': title,
      'content': content,
      'attachments': attachments.map((e) => e.toMap()).toList(),
      'createdAt': now,
      'updatedAt': null,
    });

    _notes.insert(
      0,
      Note(
        id: docRef.id,
        title: title,
        content: content,
        attachments: attachments,
        createdAt: now,
      ),
    );
  }

  /// ---------------- UPDATE NOTE ----------------
  Future<void> updateNote(
    String id,
    String newTitle,
    String newContent,
    List<Attachment> updatedAttachments,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toIso8601String();

    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({
      'title': newTitle,
      'content': newContent,
      'attachments': updatedAttachments.map((e) => e.toMap()).toList(),
      'updatedAt': now,
    });

    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: id,
        title: newTitle,
        content: newContent,
        attachments: updatedAttachments,
        createdAt: _notes[index].createdAt,
      );
    }
  }

  /// ---------------- DELETE NOTE ----------------
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
  }

  /// ---------------- CLEAR ALL NOTES ----------------
  Future<void> clearAllNotes() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _firestore.batch();
    final notesCollection =
        _firestore.collection('Users').doc(user.uid).collection('notes');

    for (final note in _notes) {
      batch.delete(notesCollection.doc(note.id));
    }

    await batch.commit();
    _notes.clear();
  }
}
