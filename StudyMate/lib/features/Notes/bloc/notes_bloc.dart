import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/Notes/data/note_model.dart';

import '../data/note_service.dart';
import 'notes_event.dart';
import 'notes_state.dart';

/// ---------------- SORT & FILTER ENUMS ----------------

enum NotesSortType {
  newestFirst,
  oldestFirst,
  alphabetical,
}

enum NotesFilterType {
  all,
  textOnly,
  hasImage,
  hasPdf,
}

/// ---------------- NOTES BLOC ----------------

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesService notesService;

  NotesBloc(this.notesService) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);

    // 🔍 Search / Sort / Filter
    on<SearchNotesChanged>(_onSearchChanged);
    on<NotesSortChanged>(_onSortChanged);
    on<NotesFilterChanged>(_onFilterChanged);
  }

  /// ---------------- LOAD NOTES ----------------
  Future<void> _onLoadNotes(
    LoadNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    await notesService.loadNotes();

    emit(
      NotesLoaded(
        originalNotes: notesService.notes,
        visibleNotes: notesService.notes,
        searchQuery: '',
        sortType: NotesSortType.newestFirst,
        filterType: NotesFilterType.all,
      ),
    );
  }

  /// ---------------- ADD NOTE ----------------
  Future<void> _onAddNote(
    AddNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    await notesService.addNote(
      event.title,
      event.content,
      event.attachments,
    );

    final updatedNotes = notesService.notes;

    emit(
      currentState.copyWith(
        originalNotes: updatedNotes,
        visibleNotes: _applyNotesFilters(
          notes: updatedNotes,
          searchQuery: currentState.searchQuery,
          sortType: currentState.sortType,
          filterType: currentState.filterType,
        ),
      ),
    );
  }

  /// ---------------- UPDATE NOTE ----------------
  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    await notesService.updateNote(
      event.id,
      event.title,
      event.content,
      event.attachments,
    );

    final updatedNotes = notesService.notes;

    emit(
      currentState.copyWith(
        originalNotes: updatedNotes,
        visibleNotes: _applyNotesFilters(
          notes: updatedNotes,
          searchQuery: currentState.searchQuery,
          sortType: currentState.sortType,
          filterType: currentState.filterType,
        ),
      ),
    );
  }

  /// ---------------- DELETE NOTE ----------------
  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    await notesService.deleteNoteAt(event.index);

    final updatedNotes = notesService.notes;

    emit(
      currentState.copyWith(
        originalNotes: updatedNotes,
        visibleNotes: _applyNotesFilters(
          notes: updatedNotes,
          searchQuery: currentState.searchQuery,
          sortType: currentState.sortType,
          filterType: currentState.filterType,
        ),
      ),
    );
  }

  /// ---------------- SEARCH ----------------
  void _onSearchChanged(
    SearchNotesChanged event,
    Emitter<NotesState> emit,
  ) {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    emit(
      currentState.copyWith(
        searchQuery: event.query,
        visibleNotes: _applyNotesFilters(
          notes: currentState.originalNotes,
          searchQuery: event.query,
          sortType: currentState.sortType,
          filterType: currentState.filterType,
        ),
      ),
    );
  }

  /// ---------------- SORT ----------------
  void _onSortChanged(
    NotesSortChanged event,
    Emitter<NotesState> emit,
  ) {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    emit(
      currentState.copyWith(
        sortType: event.sortType,
        visibleNotes: _applyNotesFilters(
          notes: currentState.originalNotes,
          searchQuery: currentState.searchQuery,
          sortType: event.sortType,
          filterType: currentState.filterType,
        ),
      ),
    );
  }

  /// ---------------- FILTER ----------------
  void _onFilterChanged(
    NotesFilterChanged event,
    Emitter<NotesState> emit,
  ) {
    if (state is! NotesLoaded) return;

    final currentState = state as NotesLoaded;

    emit(
      currentState.copyWith(
        filterType: event.filterType,
        visibleNotes: _applyNotesFilters(
          notes: currentState.originalNotes,
          searchQuery: currentState.searchQuery,
          sortType: currentState.sortType,
          filterType: event.filterType,
        ),
      ),
    );
  }

  /// ---------------- FILTER LOGIC ----------------
  List<Note> _applyNotesFilters({
    required List<Note> notes,
    required String searchQuery,
    required NotesSortType sortType,
    required NotesFilterType filterType,
  }) {
    var result = [...notes];

    // 🔍 SEARCH
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((note) {
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q);
      }).toList();
    }

    // 🎯 FILTER
    switch (filterType) {
      case NotesFilterType.textOnly:
        result = result.where((n) => n.attachments.isEmpty).toList();
        break;
      case NotesFilterType.hasImage:
        result = result
            .where(
              (n) => n.attachments.any((a) => a.type == 'image'),
            )
            .toList();
        break;
      case NotesFilterType.hasPdf:
        result = result
            .where(
              (n) => n.attachments.any((a) => a.type == 'pdf'),
            )
            .toList();
        break;
      case NotesFilterType.all:
        break;
    }

    // 🔃 SORT
    switch (sortType) {
      case NotesSortType.newestFirst:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NotesSortType.oldestFirst:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case NotesSortType.alphabetical:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return result;
  }
}
