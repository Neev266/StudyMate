import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Notes/note_service.dart';
import '../Notes/note_editor.dart';
import '../Notes/note_model.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  Widget _buildNoteCard(Note note, int index) {
    final colors = [
      Colors.yellow[200],
      Colors.pink[100],
      Colors.lightBlue[100],
      Colors.green[100],
    ];

    return SizedBox(
      width: 170,
      child: InkWell(
        onTap: () {
          // open note editor with existing note
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditor(existingNote: note),
            ),
          );
        },
        child: Card(
          key: ValueKey(note.id),
          color: colors[index % colors.length],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<NotesService>(
        builder: (context, notesService, _) {
          final notes = notesService.notes;

          if (notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Tap + to add one.'),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Dismissible(
                key: ValueKey(note.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  notesService.deleteNoteAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note deleted')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _buildNoteCard(note, index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open empty editor for new note
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditor()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
