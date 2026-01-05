import 'package:flutter_app/features/Notes/bloc/notes_bloc.dart';

import '../data/note_model.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String title;
  final String content;
  final List<Attachment> attachments;

  AddNoteEvent(this.title, this.content, this.attachments);
}

class UpdateNoteEvent extends NotesEvent {
  final String id;
  final String title;
  final String content;
  final List<Attachment> attachments;

  UpdateNoteEvent(this.id, this.title, this.content, this.attachments);
}

class DeleteNoteEvent extends NotesEvent {
  final int index;
  DeleteNoteEvent(this.index);
}

class SearchNotesChanged extends NotesEvent {
  final String query;
  SearchNotesChanged(this.query);
}

class NotesSortChanged extends NotesEvent {
  final NotesSortType sortType;
  NotesSortChanged(this.sortType);
}

class NotesFilterChanged extends NotesEvent {
  final NotesFilterType filterType;
  NotesFilterChanged(this.filterType);
}

