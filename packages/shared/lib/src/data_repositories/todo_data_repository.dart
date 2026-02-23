import '../data_providers/todo_data_provider.dart';
import '../models/todo_model.dart';
import 'data_manager.dart';

class NoFetchingParams {}

class TodoDataRepository extends DataManager<TodoModel, NoFetchingParams> {
  TodoDataRepository(this._dataProvider);

  final TodoDataProvider _dataProvider;

  @override
  Future<Map<String, TodoModel>> fetch(NoFetchingParams params) async {
    try {
      final List<Map<String, dynamic>> rawData = await _dataProvider.fetchTodos();
      final Map<String, TodoModel> result = <String, TodoModel>{};

      for (final Map<String, dynamic> item in rawData) {
        final TodoModel todo = TodoModel.fromJson(item);
        result[todo.id.toString()] = todo;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  @override
  Map<String, dynamic> toJsonCache(TodoModel object) => object.toJson();

  @override
  TodoModel fromJsonCache(Map<String, dynamic> json) => TodoModel.fromJson(json);
}
