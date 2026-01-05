import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/todo_model.dart';
import '../data/todo_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';

/// ---------------- SORT & FILTER ENUMS ----------------

enum TodoSortType {
  newestFirst,
  oldestFirst,
  alphabetical,
}

enum TodoFilterType {
  all,
  completed,
  pending,
}

/// ---------------- TODO BLOC ----------------

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoService service;

  TodoBloc(this.service) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<RemoveTodoEvent>(_onRemoveTodo);
    on<TodoSortChanged>(_onSortChanged);
    on<TodoFilterChanged>(_onFilterChanged);
  }

  /// ---------------- LOAD TODOS ----------------
  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      await service.loadTodosFromFirebase();

      emit(
        TodoLoaded(
          originalTodos: service.todos,
          visibleTodos: service.todos,
          sortType: TodoSortType.newestFirst,
          filterType: TodoFilterType.all,
        ),
      );
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  /// ---------------- ADD TODO ----------------
  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    final s = state as TodoLoaded;

    await service.addTodo(event.title, event.description);

    final updated = _applyFilters(
      todos: service.todos,
      sortType: s.sortType,
      filterType: s.filterType,
    );

    emit(
      TodoLoaded(
        originalTodos: service.todos,
        visibleTodos: updated,
        sortType: s.sortType,
        filterType: s.filterType,
      ),
    );
  }

  /// ---------------- UPDATE TODO ----------------
  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    final s = state as TodoLoaded;

    await service.updateTodo(
      event.id,
      event.newTitle,
      event.newDesc,
    );

    final updated = _applyFilters(
      todos: service.todos,
      sortType: s.sortType,
      filterType: s.filterType,
    );

    emit(
      TodoLoaded(
        originalTodos: service.todos,
        visibleTodos: updated,
        sortType: s.sortType,
        filterType: s.filterType,
      ),
    );
  }

  /// ---------------- REMOVE TODO ----------------
  Future<void> _onRemoveTodo(
    RemoveTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    final s = state as TodoLoaded;

    final index =
        service.todos.indexWhere((todo) => todo.id == event.id);
    if (index != -1) {
      await service.removeTodoAt(index);
    }

    final updated = _applyFilters(
      todos: service.todos,
      sortType: s.sortType,
      filterType: s.filterType,
    );

    emit(
      TodoLoaded(
        originalTodos: service.todos,
        visibleTodos: updated,
        sortType: s.sortType,
        filterType: s.filterType,
      ),
    );
  }

  /// ---------------- SORT ----------------
  void _onSortChanged(
    TodoSortChanged event,
    Emitter<TodoState> emit,
  ) {
    if (state is! TodoLoaded) return;
    final s = state as TodoLoaded;

    final updated = _applyFilters(
      todos: s.originalTodos,
      sortType: event.sortType,
      filterType: s.filterType,
    );

    emit(
      TodoLoaded(
        originalTodos: s.originalTodos,
        visibleTodos: updated,
        sortType: event.sortType,
        filterType: s.filterType,
      ),
    );
  }

  /// ---------------- FILTER ----------------
  void _onFilterChanged(
    TodoFilterChanged event,
    Emitter<TodoState> emit,
  ) {
    if (state is! TodoLoaded) return;
    final s = state as TodoLoaded;

    final updated = _applyFilters(
      todos: s.originalTodos,
      sortType: s.sortType,
      filterType: event.filterType,
    );

    emit(
      TodoLoaded(
        originalTodos: s.originalTodos,
        visibleTodos: updated,
        sortType: s.sortType,
        filterType: event.filterType,
      ),
    );
  }

  /// ---------------- APPLY FILTERS ----------------
  List<Todo> _applyFilters({
    required List<Todo> todos,
    required TodoSortType sortType,
    required TodoFilterType filterType,
  }) {
    var result = [...todos];

    // FILTER
    if (filterType == TodoFilterType.completed) {
      result = result.where((t) => t.completed).toList();
    } else if (filterType == TodoFilterType.pending) {
      result = result.where((t) => !t.completed).toList();
    }

    // SORT
    switch (sortType) {
      case TodoSortType.newestFirst:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TodoSortType.oldestFirst:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TodoSortType.alphabetical:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return result;
  }
}
