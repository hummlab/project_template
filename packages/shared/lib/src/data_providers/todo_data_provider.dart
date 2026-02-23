class TodoDataProvider {
  /// Simulating an API request to fetch a list of todos.
  Future<List<Map<String, dynamic>>> fetchTodos() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return <Map<String, dynamic>>[
      <String, dynamic>{'id': 1, 'title': 'Review architecture doc', 'completed': true},
      <String, dynamic>{'id': 2, 'title': 'Implement Todo feature', 'completed': false},
      <String, dynamic>{'id': 3, 'title': 'Write unit tests', 'completed': false},
    ];
  }
}
