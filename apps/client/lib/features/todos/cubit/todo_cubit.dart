import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._todoRepository) : super(TodoLoading()) {
    _init();
  }

  final TodoDataRepository _todoRepository;
  StreamSubscription<List<TodoModel>>? _subscription;

  void _init() {
    _subscription = _todoRepository.data$.listen(
      (List<TodoModel> todos) {
        emit(TodoLoaded(todos));
      },
      onError: (Object error) {
        emit(TodoError(error.toString()));
      },
    );
  }

  Future<void> loadTodos() async {
    emit(TodoLoading());
    try {
      await _todoRepository.fetch(NoFetchingParams());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> editTodo(int id, String newTitle) async {
    try {
      if (newTitle.trim().isNotEmpty) {
        await _todoRepository.editTodo(id, newTitle.trim());
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> addTodo(String title) async {
    try {
      await _todoRepository.addTodo(title);
    } catch (e) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> toggleTodo(int id) async {
    try {
      await _todoRepository.toggleTodo(id);
    } catch (e) {
      throw Exception('Failed to toggle todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _todoRepository.deleteTodo(id);
    } catch (e) {
      throw Exception('Failed to delete todo');
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
