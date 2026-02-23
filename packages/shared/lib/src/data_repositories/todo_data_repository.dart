import '../models/todo_model.dart';
import 'data_manager.dart';

class NoFetchingParams {}

class TodoDataRepository extends DataManager<TodoModel, NoFetchingParams> {
  TodoDataRepository();

  int _nextId = 1;

  @override
  Future<Map<String, TodoModel>> fetch(NoFetchingParams params) async {
    // For local-only storage, fetch simply resolves to the currently cached data
    // DataManager.initializeCache() loads it first, so we just return it here
    // or return empty if nothing yet.
    return data.value;
  }

  Future<void> addTodo(String title) async {
    final Map<String, TodoModel> currentData = Map<String, TodoModel>.from(data.value);

    // Find highest ID to auto-increment
    if (currentData.isNotEmpty) {
      final int maxId = currentData.values.map((TodoModel t) => t.id).reduce((int a, int b) => a > b ? a : b);
      _nextId = maxId + 1;
    }

    final TodoModel newTodo = TodoModel(id: _nextId, title: title, completed: false);

    await updateStreamWith(<String, TodoModel?>{newTodo.id.toString(): newTodo});
  }

  Future<void> toggleTodo(int id) async {
    final Map<String, TodoModel> currentData = data.value;
    final String key = id.toString();

    if (currentData.containsKey(key)) {
      final TodoModel todo = currentData[key]!;
      final TodoModel updatedTodo = todo.copyWith(completed: !todo.completed);
      await updateStreamWith(<String, TodoModel?>{key: updatedTodo});
    }
  }

  Future<void> editTodo(int id, String newTitle) async {
    final Map<String, TodoModel> currentData = data.value;
    final String key = id.toString();

    if (currentData.containsKey(key)) {
      final TodoModel todo = currentData[key]!;
      final TodoModel updatedTodo = todo.copyWith(title: newTitle);
      await updateStreamWith(<String, TodoModel?>{key: updatedTodo});
    }
  }

  Future<void> deleteTodo(int id) async {
    final String key = id.toString();
    await updateStreamWith(<String, TodoModel?>{key: null}); // Passing null deletes the item
  }

  @override
  Map<String, dynamic> toJsonCache(TodoModel object) => object.toJson();

  @override
  TodoModel fromJsonCache(Map<String, dynamic> json) => TodoModel.fromJson(json);
}
