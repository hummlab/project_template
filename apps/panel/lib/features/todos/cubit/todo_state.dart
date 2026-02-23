part of 'todo_cubit.dart';

abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  TodoLoaded(this.todos);
  final List<TodoModel> todos;
}

class TodoError extends TodoState {
  TodoError(this.message);
  final String message;
}
