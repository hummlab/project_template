# Shared Flutter Package

This is a shared Flutter package containing common models, data providers, and repositories that can be used across multiple Flutter applications in the project.

## Overview

The shared package provides a centralized location for all common code that needs to be shared between different parts of the application or between multiple applications. It follows the repository pattern and includes:

- **Models**: Data models with serialization/deserialization capabilities
- **Data Providers**: Classes that handle data fetching from various sources (APIs, local storage, etc.)
- **Repositories**: Classes that provide a clean interface for data operations and business logic

## Package Structure

```
lib/
├── shared.dart                 # Main library export file
└── src/
    ├── models/
    │   ├── models.dart         # Models barrel export
    │   └── user_model.dart     # Example user model
    ├── data_providers/
    │   ├── data_providers.dart # Data providers barrel export
    │   └── api_provider.dart   # Base API provider
    └── repositories/
        ├── repositories.dart   # Repositories barrel export
        └── base_repository.dart # Base repository interface
```

## Usage

To use this package in your Flutter application, add it as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  shared:
    path: ../packages/shared
```

Then import the package in your Dart files:

```dart
import 'package:shared/shared.dart';
```

### Using Models

```dart
// Create a user model instance
final User user = User(
  id: '123',
  email: 'user@example.com',
  name: 'John Doe',
  role: 'user',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Serialize to JSON
final Map<String, dynamic> json = user.toJson();

// Deserialize from JSON
final User userFromJson = User.fromJson(json);
```

### Using Data Providers

```dart
// Extend the base API provider
class UserApiProvider extends BaseApiProvider {
  UserApiProvider() : super(baseUrl: 'https://api.example.com');
  
  Future<ApiResponse<Map<String, dynamic>>> getUser(String id) async {
    return await get('/users/$id');
  }
}
```

### Using Repositories

```dart
// Implement the base repository interface
class UserRepository implements BaseRepository<User, String> {
  final UserApiProvider _apiProvider;
  
  UserRepository({required UserApiProvider apiProvider})
      : _apiProvider = apiProvider;
  
  @override
  Future<User?> getById(String id) async {
    final ApiResponse<Map<String, dynamic>> response = await _apiProvider.getUser(id);
    
    if (response.isSuccess && response.data != null) {
      return User.fromJson(response.data!);
    }
    
    return null;
  }
  
  // Implement other required methods...
}
```

## Code Generation

This package uses code generation for models. After making changes to models, run:

```bash
dart run build_runner build
```

Or for continuous generation during development:

```bash
dart run build_runner watch
```

## Testing

Run tests for the shared package:

```bash
flutter test
```

## Code Quality

The package follows strict typing requirements and code quality standards:

- All variables must have explicit type annotations
- All function parameters must have explicit type annotations
- All function return types must be explicitly declared
- Comprehensive documentation for all public APIs
- Consistent error handling patterns

## Dependencies

The package includes the following key dependencies:

- `freezed`: For immutable data classes with code generation
- `json_annotation`: For JSON serialization
- `http`: For HTTP API calls
- `shared_preferences`: For local storage
- Firebase packages for backend integration

## Contributing

When adding new models, data providers, or repositories:

1. Follow the existing code structure and patterns
2. Add proper type annotations and documentation
3. Export new classes in the appropriate barrel files
4. Run code generation if needed
5. Add comprehensive tests
6. Update this README if necessary

## Development Guidelines

- **Strong Typing**: All variables, parameters, and return types must be explicitly typed
- **Documentation**: All public methods and classes must be documented
- **Testing**: Include unit tests for all functionality
- **Error Handling**: Implement proper error handling and logging
- **Performance**: Optimize for performance and memory usage
- **Compatibility**: Maintain backward compatibility when possible

## Secrets

Sensitive information such as API keys, tokens, and other credentials must be stored in the `lib/secrets.dart` file. This file is excluded from version control via `.gitignore` and **must not be committed to the repository**. Example secrets include Firebase keys, Mixpanel tokens, and any other private configuration values.