# Data Repositories Directory

This directory contains data repository implementations that provide a reactive, cache-enabled layer for data access and state management.

## Purpose

The `data_repositories/` directory implements an advanced repository pattern using `DataManager`. It provides:
- **Reactive Data Streams**: Exposes data as `Stream` (via `RxDart`'s `BehaviorSubject`) for real-time UI updates.
- **Automatic Caching**: Integrated `Hive` caching to persist data across sessions.
- **Smart Fetching**: Logic to handle data freshness and fetching strategies.

## Structure

Data repositories should be organized by domain or entity:

```
data_repositories/
├── data_manager.dart     # Base abstract class for all data managers
├── cache_service.dart    # Caching service interface and Hive implementation
├── user_repository.dart  # Example: User-related data manager
└── [entity]_repository.dart
```

## DataManager Pattern

### Implementation
Extend `DataManager<T, P>` where `T` is your model and `P` is the parameter type for fetching (use `void` if none).

```dart
import 'package:shared/src/data_repositories/data_manager.dart';
import 'package:shared/src/models/user_model.dart';

class UserRepository extends DataManager<User, void> {
  final ApiProvider _apiProvider;

  UserRepository(this._apiProvider);

  @override
  Future<Map<String, User>> fetch(void params) async {
    // Implement API call
    final response = await _apiProvider.getUsers();
    // Return a Map<ID, Entity>
    return { for (var e in response) e.id: e };
  }

  // Implement serialization for caching
  @override
  Map<String, dynamic> toJsonCache(User object) => object.toJson();

  @override
  User fromJsonCache(Map<String, dynamic> json) => User.fromJson(json);
}
```

### Usage
The `DataManager` provides several streams and methods out of the box:

```dart
// Access real-time data
userRepository.data$.listen((users) {
  print('Current users: $users');
});

// Access specific item by ID
userRepository.dataForId$('123').listen((user) {
  print('User 123 updated: $user');
});

// Fetch data (updates streams and cache automatically)
await userRepository.fetchData(null);

// Validate if cache is fresh enough
if (!userRepository.validateCacheTime('getUsers')) {
  await userRepository.fetchData(null);
}
```

## Key Features

### 1. Reactivity
- **`data$`**: Stream of List<T> values.
- **`dataMap$`**: Stream of Map<String, T>.
- **`dataForId$(id)`**: Stream of a specific item, updates automatically when the main data changes.

### 2. Caching
- **Persistence**: Data is automatically saved to local storage using Hive.
- **Initialization**: Call `initializeCache()` on startup to load persisted data into the stream immediately.

### 3. State Management
- **`lastKnownValues`**: Synchronous access to the current state.
- **`updateStreamWith`**: Manually update the state (e.g., after a successful mutation like `add` or `update`).

## Development Guidelines

- **Extension**: Always extend `DataManager<T, P>`.
- **Serialization**: Implement `toJsonCache` and `fromJsonCache` for Hive support.
- **Fetching**: Implement `fetch` to return a `Map<String, T>`. The keys should be unique IDs.
- **Singleton/DI**: Typically, these repositories should be singletons or scoped providers to maintain state.
