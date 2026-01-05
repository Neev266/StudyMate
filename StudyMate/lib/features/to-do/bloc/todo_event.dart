import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/to-do/bloc/todo_bloc.dart';

// It basically stores what to do when an event happens like updation of a todo list etc
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;

  AddTodoEvent(this.title, this.description);

  @override
  List<Object?> get props => [title, description];
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final String newTitle;
  final String newDesc;

  UpdateTodoEvent(this.id, this.newTitle, this.newDesc);

  @override
  List<Object?> get props => [id, newTitle, newDesc];
}

class RemoveTodoEvent extends TodoEvent {
  final String id;        // We delete using id

  RemoveTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchQueryChanged extends TodoEvent {
  final String query;

  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class TodoSortChanged extends TodoEvent {
  final TodoSortType sortType;
  TodoSortChanged(this.sortType);
}

class TodoFilterChanged extends TodoEvent {
  final TodoFilterType filterType;
  TodoFilterChanged(this.filterType);
}
