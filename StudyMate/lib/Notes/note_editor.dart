import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_model.dart';
import 'note_service.dart';

class NoteEditor extends StatefulWidget {
  final Note? existingNote;
  const NoteEditor({super.key, this.existingNote});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingNote != null;
    _titleController =
        TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingNote?.content ?? '');
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final notesService = Provider.of<NotesService>(context, listen: false);

    if (_isEditing && widget.existingNote != null) {
      notesService.updateNote(widget.existingNote!.id, title, content);
    } else {
      notesService.addNote(title.isEmpty ? 'Untitled Note' : title, content);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isEditing ? 'Edit Note' : 'New Note',
        style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save,color: Colors.black,),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
