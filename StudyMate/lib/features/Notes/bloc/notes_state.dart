import 'package:flutter_app/features/Notes/bloc/notes_bloc.dart';

import '../data/note_model.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> originalNotes;
  final List<Note> visibleNotes;
  final String searchQuery;
  final NotesSortType sortType;
  final NotesFilterType filterType;

  NotesLoaded({
    required this.originalNotes,
    required this.visibleNotes,
    required this.searchQuery,
    required this.sortType,
    required this.filterType,
  });

  get notes => null;

  // ✅ THIS IS copyWith — ADD IT HERE
  NotesLoaded copyWith({
    List<Note>? originalNotes,
    List<Note>? visibleNotes,
    String? searchQuery,
    NotesSortType? sortType,
    NotesFilterType? filterType,
  }) {
    return NotesLoaded(
      originalNotes: originalNotes ?? this.originalNotes,
      visibleNotes: visibleNotes ?? this.visibleNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      sortType: sortType ?? this.sortType,
      filterType: filterType ?? this.filterType,
    );
  }
}

class NotesError extends NotesState {
  final String message;
  NotesError(this.message);
}
