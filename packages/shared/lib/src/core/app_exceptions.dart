/// Base class for all application-specific exceptions
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when an endpoint requires authentication
class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Unauthorized. Please log in again.');
}

/// Thrown when a request sequence goes over its assigned timeout
class TimeoutException extends AppException {
  const TimeoutException() : super('Request timed out.');
}
