import 'package:equatable/equatable.dart';
import '../data/todo_model.dart';
import 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> originalTodos;
  final List<Todo> visibleTodos;
  final TodoSortType sortType;
  final TodoFilterType filterType;

  TodoLoaded({
    required this.originalTodos,
    required this.visibleTodos,
    required this.sortType,
    required this.filterType,
  });

  @override
  List<Object?> get props =>
      [originalTodos, visibleTodos, sortType, filterType];
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
