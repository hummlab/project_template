# Repositories Directory

This directory contains repository implementations that provide a clean abstraction layer for data access and business logic.

## Purpose

The `repositories/` directory implements the Repository pattern, providing a clean interface for data access while encapsulating the complexity of data sources and business logic.

## Structure

Repositories should be organized by domain or entity:

```
repositories/
├── user/                 # User-related repositories
│   ├── user_repository.dart
│   ├── user_repository_impl.dart
│   └── user_repository_interface.dart
├── product/              # Product-related repositories
│   ├── product_repository.dart
│   ├── product_repository_impl.dart
│   └── product_repository_interface.dart
├── order/                # Order-related repositories
│   ├── order_repository.dart
│   ├── order_repository_impl.dart
│   └── order_repository_interface.dart
└── common/               # Common repository utilities
    ├── base_repository.dart
    ├── cache_repository.dart
    └── repository_exception.dart
```

## Repository Pattern

### Interface Definition
Define the contract for data operations:

```dart
abstract class UserRepository {
  Future<User?> getById(String id);
  Future<List<User>> getAll();
  Future<User> create(User user);
  Future<User> update(User user);
  Future<void> delete(String id);
  Future<List<User>> search(String query);
}
```

### Implementation
Implement the repository with specific data sources:

```dart
class UserRepositoryImpl implements UserRepository {
  final UserApiProvider _apiProvider;
  final SharedPreferencesProvider _localProvider;
  final CacheRepository _cacheRepository;
  
  UserRepositoryImpl({
    required UserApiProvider apiProvider,
    required SharedPreferencesProvider localProvider,
    required CacheRepository cacheRepository,
  }) : _apiProvider = apiProvider,
       _localProvider = localProvider,
       _cacheRepository = cacheRepository;
  
  @override
  Future<User?> getById(String id) async {
    // Check cache first
    final cachedUser = await _cacheRepository.get<User>('user_$id');
    if (cachedUser != null) {
      return cachedUser;
    }
    
    // Fetch from API
    final apiResponse = await _apiProvider.getUserById(id);
    if (apiResponse.isSuccess) {
      final user = apiResponse.data!;
      // Cache the result
      await _cacheRepository.set('user_$id', user, Duration(hours: 1));
      return user;
    }
    
    return null;
  }
}
```

## Repository Types

### CRUD Repositories
Basic Create, Read, Update, Delete operations:

```dart
abstract class CrudRepository<T> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<void> delete(String id);
}
```

### Specialized Repositories
Repositories with domain-specific operations:

```dart
abstract class UserRepository extends CrudRepository<User> {
  Future<User?> getByEmail(String email);
  Future<List<User>> getByRole(UserRole role);
  Future<void> updateProfile(String userId, UserProfile profile);
  Future<void> changePassword(String userId, String newPassword);
}
```

## Development Guidelines

- **Strong Typing**: All methods must have explicit return types and parameter types
- **Interface Segregation**: Define specific interfaces for different operations
- **Dependency Injection**: Use dependency injection for data providers
- **Error Handling**: Implement comprehensive error handling
- **Caching**: Implement appropriate caching strategies
- **Testing**: Write unit tests for all repositories
- **Documentation**: Document all public methods and classes

## Example Repository

```dart
import '../models/user_model.dart';
import '../data_providers/user_api_provider.dart';
import '../data_providers/shared_preferences_provider.dart';

/// Repository for managing user data operations
/// 
/// This repository provides a clean interface for user-related data operations,
/// including CRUD operations and business logic.
abstract class UserRepository {
  /// Retrieves a user by their unique identifier
  /// 
  /// [id] - The unique identifier of the user
  /// Returns [User?] if found, null otherwise
  Future<User?> getById(String id);
  
  /// Retrieves all users
  /// 
  /// Returns [List<User>] containing all users
  Future<List<User>> getAll();
  
  /// Creates a new user
  /// 
  /// [user] - The user data to create
  /// Returns [User] the created user with generated ID
  Future<User> create(User user);
  
  /// Updates an existing user
  /// 
  /// [user] - The user data to update
  /// Returns [User] the updated user
  Future<User> update(User user);
  
  /// Deletes a user by their unique identifier
  /// 
  /// [id] - The unique identifier of the user to delete
  Future<void> delete(String id);
  
  /// Searches for users by email
  /// 
  /// [email] - The email to search for
  /// Returns [User?] if found, null otherwise
  Future<User?> getByEmail(String email);
}

class UserRepositoryImpl implements UserRepository {
  final UserApiProvider _apiProvider;
  final SharedPreferencesProvider _localProvider;
  
  UserRepositoryImpl({
    required UserApiProvider apiProvider,
    required SharedPreferencesProvider localProvider,
  }) : _apiProvider = apiProvider,
       _localProvider = localProvider;
  
  @override
  Future<User?> getById(String id) async {
    try {
      final apiResponse = await _apiProvider.getUserById(id);
      return apiResponse.isSuccess ? apiResponse.data : null;
    } catch (e) {
      // Log error and return null
      print('Error fetching user by ID: $e');
      return null;
    }
  }
  
  @override
  Future<List<User>> getAll() async {
    try {
      final apiResponse = await _apiProvider.getAllUsers();
      return apiResponse.isSuccess ? apiResponse.data : [];
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }
  
  @override
  Future<User> create(User user) async {
    try {
      final apiResponse = await _apiProvider.createUser(user.toJson());
      if (apiResponse.isSuccess) {
        return apiResponse.data!;
      } else {
        throw Exception('Failed to create user: ${apiResponse.error}');
      }
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
  
  @override
  Future<User> update(User user) async {
    try {
      final apiResponse = await _apiProvider.updateUser(user.id, user.toJson());
      if (apiResponse.isSuccess) {
        return apiResponse.data!;
      } else {
        throw Exception('Failed to update user: ${apiResponse.error}');
      }
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> delete(String id) async {
    try {
      final apiResponse = await _apiProvider.deleteUser(id);
      if (!apiResponse.isSuccess) {
        throw Exception('Failed to delete user: ${apiResponse.error}');
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
  
  @override
  Future<User?> getByEmail(String email) async {
    try {
      final apiResponse = await _apiProvider.getUserByEmail(email);
      return apiResponse.isSuccess ? apiResponse.data : null;
    } catch (e) {
      print('Error fetching user by email: $e');
      return null;
    }
  }
}
```

## Best Practices

1. **Single Responsibility**: Each repository should handle one entity type
2. **Interface Segregation**: Define specific interfaces for different operations
3. **Dependency Inversion**: Depend on abstractions, not concrete implementations
4. **Error Handling**: Implement consistent error handling patterns
5. **Caching**: Use appropriate caching strategies for performance
6. **Validation**: Include business logic validation in repositories
7. **Testing**: Write comprehensive unit tests for all repository methods
``` 