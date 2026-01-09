import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../data/note_model.dart';
import 'editor_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesBloc>().add(LoadNotes());
    });
  }

  Widget _buildNoteCard(Note note, int index) {
    final colors = [
      Colors.yellow[300],
      Colors.pink[200],
      Colors.lightBlue[200],
      Colors.green[200],
    ];

    return SizedBox(
      width: 170,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditorView(existingNote: note),
            ),
          );
        },
        child: Card(
          key: ValueKey(note.id),
          color: colors[index % colors.length],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
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
    final bool isWeb = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading || state is NotesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotesLoaded) {
            // ✅ IMPORTANT CHANGE (NO UI CHANGE)
            final notes = state.visibleNotes;

            if (notes.isEmpty) {
              return const Center(
                child: Text('No notes yet. Tap + to add one.'),
              );
            }

            if(isWeb){
              return MasonryGridView.count(
              crossAxisCount: 6,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) {
                    context
                        .read<NotesBloc>()
                        .add(DeleteNoteEvent(index));
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: _buildNoteCard(note, index),
                );
              },
            );
            }
            else{
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
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) {
                    context
                        .read<NotesBloc>()
                        .add(DeleteNoteEvent(index));
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: _buildNoteCard(note, index),
                );
              },
            );
            }
            
          }

          if (state is NotesError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditorView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
