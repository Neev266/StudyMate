import 'package:flutter/material.dart';
import 'package:flutter_app/features/Home/home.dart';
import 'package:flutter_app/features/Notes/data/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../features/to-do/bloc/todo_bloc.dart';
import '../../features/to-do/bloc/todo_state.dart';
import '../../features/to-do/data/todo_model.dart';

import '../../features/Notes/bloc/notes_bloc.dart';
import '../../features/Notes/bloc/notes_state.dart';



class AppSearchDelegate extends SearchDelegate {
  final HomeTab tab;

  AppSearchDelegate(this.tab);

  @override
  String get searchFieldLabel =>
      tab == HomeTab.todo ? 'Search todos...' : 'Search notes...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }


  @override
ThemeData appBarTheme(BuildContext context) {
  final theme = Theme.of(context);

  return theme.copyWith(
    scaffoldBackgroundColor: Colors.white, // ✅ page background
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: Colors.white,       // ✅ app bar background
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black54),
      border: InputBorder.none,
    ),
    textTheme: theme.textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
  );
}


  // ==========================================================
  // ====================== TODO SEARCH =======================
  // ==========================================================

  Widget _buildResults(BuildContext context) {
    if (tab == HomeTab.todo) {
      return BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is! TodoLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Todo> results = query.isEmpty
          ? state.originalTodos
          : state.originalTodos.where((todo) {
              return todo.title
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  todo.description
                      .toLowerCase()
                      .contains(query.toLowerCase());
            }).toList();


          if (results.isEmpty) {
            return const Center(child: Text('No matching todos'));
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final todo = results[index];
              return _buildTodoCard(context, todo, index);
            },
          );
        },
      );
    }

    return BlocBuilder<NotesBloc, NotesState>(
  builder: (context, state) {
    if (state is! NotesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final results = query.isEmpty
    ? state.originalNotes
    : state.originalNotes.where((note) {
        return note.title
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();


    if (results.isEmpty) {
      return const Center(child: Text('No matching notes'));
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return _buildNoteCard(context, note, index);
      },
    );
  },
);



  }

  // ==========================================================
  // =============== SAME TODO CARD UI (REUSED) ================
  // ==========================================================

  Widget _buildTodoCard(BuildContext context, Todo todo, int index) {
    final colors = [
      Colors.red[400],
      Colors.green[100],
    ];

    return GestureDetector(
      onTap: () {
        // optional: open edit dialog here later
      },
      child: SizedBox(
        width: 170,
        child: Card(
          key: ValueKey(todo.id),
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
                  todo.title,
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
                  todo.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNoteCard(BuildContext context, Note note, int index) {
  final colors = [
    Colors.yellow[200],
    Colors.pink[100],
    Colors.lightBlue[100],
    Colors.green[100],
  ];

  return SizedBox(
    width: 170,
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
  );
}

}
