import '../core/app_exceptions.dart';

class AuthDataProvider {
  /// Simulating an API request to authentication endpoint.
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    if (email == 'admin@admin.com' && password == 'password') {
      return <String, dynamic>{
        'token': 'mock-jwt-token-123456789',
      };
    } else {
      throw const AppException('Login failed: Invalid credentials');
    }
  }
}
