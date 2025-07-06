# Shared Package

The main shared package containing common functionality, models, and business logic used across all Flutter applications in the project.

## Purpose

This package provides a centralized location for shared code, ensuring consistency and reducing duplication across multiple Flutter applications.

## Structure

```
shared/
├── models/          # Data models and entities
├── data_providers/  # Data providers and services
└── repositories/    # Repository layer for data access
```

## Components

### Models (`models/`)
Contains all data models, entities, and type definitions:

- **Entities**: Core business objects (User, Product, Order, etc.)
- **DTOs**: Data Transfer Objects for API communication
- **Enums**: Shared enumerations and constants
- **Type Definitions**: Custom type aliases and definitions

### Data Providers (`data_providers/`)
Handles data access and external service integrations:

- **API Clients**: HTTP clients for external APIs
- **Local Storage**: SharedPreferences, Hive, or SQLite providers
- **Firebase Services**: Authentication, Firestore, Storage providers
- **External Services**: Third-party service integrations

### Repositories (`repositories/`)
Implements the repository pattern for data access:

- **Data Access Layer**: Abstracts data sources
- **Business Logic**: Core business rules and transformations
- **Caching**: Data caching strategies
- **Error Handling**: Centralized error management

## Usage Example

```dart
// Import shared models
import 'package:shared/models/user_model.dart';

// Import repositories
import 'package:shared/repositories/user_repository.dart';

// Use in your application
class UserService {
  final UserRepository _userRepository = UserRepository();
  
  Future<User> getUserById(String id) async {
    return await _userRepository.getById(id);
  }
}
```

## Development Guidelines

- **Strong Typing**: All variables, parameters, and return types must be explicitly typed
- **Documentation**: All public methods and classes must be documented
- **Testing**: Include unit tests for all functionality
- **Error Handling**: Implement proper error handling and logging
- **Performance**: Optimize for performance and memory usage
- **Compatibility**: Maintain backward compatibility when possible

## Adding New Components

When adding new models, providers, or repositories:

1. Follow the established naming conventions
2. Include comprehensive documentation
3. Write unit tests
4. Update this README if necessary
5. Ensure strong typing is used throughout

## Dependencies

This package should have minimal external dependencies to avoid conflicts. Common dependencies include:

- `http` for API calls
- `shared_preferences` for local storage
- `firebase_core` and related Firebase packages
- `json_annotation` for JSON serialization

## Secrets

Sensitive information such as API keys, tokens, and other credentials must be stored in the `lib/secrets.dart` file. This file is excluded from version control via `.gitignore` and **must not be committed to the repository**. Example secrets include Firebase keys, Mixpanel tokens, and any other private configuration values. 