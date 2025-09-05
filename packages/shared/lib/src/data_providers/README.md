# Data Providers Directory

This directory contains data providers and services that handle data access and external service integrations.

## Purpose

The `data_providers/` directory provides a layer for accessing various data sources, including APIs, local storage, Firebase services, and external integrations.

## Structure

Data providers should be organized by data source or service type:

```
data_providers/
├── api/                 # HTTP API clients
│   ├── api_client.dart
│   ├── auth_api.dart
│   └── user_api.dart
├── local/               # Local storage providers
│   ├── shared_preferences_provider.dart
│   ├── hive_provider.dart
│   └── sqlite_provider.dart
├── firebase/            # Firebase service providers
│   ├── firebase_auth_provider.dart
│   ├── firestore_provider.dart
│   └── firebase_storage_provider.dart
└── external/            # External service providers
    ├── payment_provider.dart
    ├── notification_provider.dart
    └── analytics_provider.dart
```

## Provider Types

### API Providers
Handle HTTP communication with backend services:

```dart
class ApiClient {
  final Dio _dio;
  final String _baseUrl;
  
  ApiClient({
    required String baseUrl,
    required String apiKey,
  }) : _baseUrl = baseUrl,
       _dio = Dio(BaseOptions(
         baseUrl: baseUrl,
         headers: {'Authorization': 'Bearer $apiKey'},
       ));
  
  Future<ApiResponse<T>> get<T>(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
```

### Local Storage Providers
Handle local data persistence:

```dart
class SharedPreferencesProvider {
  final SharedPreferences _prefs;
  
  SharedPreferencesProvider(this._prefs);
  
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
```

### Firebase Providers
Handle Firebase service integrations:

```dart
class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  User? get currentUser => _auth.currentUser;
}
```

## Development Guidelines

- **Strong Typing**: All methods must have explicit return types and parameter types
- **Error Handling**: Implement comprehensive error handling and logging
- **Async Operations**: Use proper async/await patterns
- **Configuration**: Make providers configurable through dependency injection
- **Testing**: Write unit tests for all providers
- **Documentation**: Document all public methods and classes

## Example Provider

```dart
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class UserApiProvider {
  final Dio _dio;
  
  UserApiProvider(this._dio);
  
  /// Fetches user data by ID from the API
  /// 
  /// [userId] - The unique identifier of the user
  /// Returns [ApiResponse<User>] containing the user data or error
  Future<ApiResponse<User>> getUserById(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Creates a new user
  /// 
  /// [userData] - The user data to create
  /// Returns [ApiResponse<User>] containing the created user or error
  Future<ApiResponse<User>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/users', data: userData);
      
      if (response.statusCode == 201) {
        final user = User.fromJson(response.data);
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}
```

## Best Practices

1. **Separation of Concerns**: Each provider should handle one specific data source
2. **Dependency Injection**: Use dependency injection for configuration
3. **Error Handling**: Implement consistent error handling patterns
4. **Caching**: Implement appropriate caching strategies
5. **Retry Logic**: Add retry logic for network operations
6. **Logging**: Include comprehensive logging for debugging
7. **Configuration**: Make providers configurable for different environments 