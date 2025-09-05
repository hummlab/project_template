import 'dart:convert';
import 'package:http/http.dart' as http;

/// Generic API response wrapper
/// 
/// This class wraps API responses to provide consistent error handling
/// and success/failure states across the application.
class ApiResponse<T> {
  /// The response data
  final T? data;
  
  /// Error message if the request failed
  final String? errorMessage;
  
  /// HTTP status code
  final int statusCode;
  
  /// Whether the request was successful
  bool get isSuccess => statusCode >= 200 && statusCode < 300 && errorMessage == null;
  
  /// Creates a new ApiResponse instance
  /// 
  /// [data] - The response data
  /// [errorMessage] - Error message if applicable
  /// [statusCode] - HTTP status code
  const ApiResponse({
    this.data,
    this.errorMessage,
    required this.statusCode,
  });
  
  /// Creates a successful response
  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse<T>(
      data: data,
      statusCode: statusCode,
    );
  }
  
  /// Creates an error response
  factory ApiResponse.error(String errorMessage, int statusCode) {
    return ApiResponse<T>(
      errorMessage: errorMessage,
      statusCode: statusCode,
    );
  }
}

/// Base API provider class
/// 
/// This abstract class provides common functionality for all API providers
/// including HTTP client configuration and error handling.
abstract class BaseApiProvider {
  /// HTTP client instance
  final http.Client _client;
  
  /// Base URL for API requests
  final String baseUrl;
  
  /// Creates a new BaseApiProvider instance
  /// 
  /// [baseUrl] - The base URL for API requests
  /// [client] - Optional HTTP client instance
  BaseApiProvider({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();
  
  /// Common headers for API requests
  Map<String, String> get headers => <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// Performs a GET request
  /// 
  /// [endpoint] - The API endpoint
  /// [queryParameters] - Optional query parameters
  /// Returns an [ApiResponse] with the response data
  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );
      
      final http.Response response = await _client.get(uri, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(
        'Network error: ${e.toString()}',
        0,
      );
    }
  }
  
  /// Performs a POST request
  /// 
  /// [endpoint] - The API endpoint
  /// [body] - Request body data
  /// Returns an [ApiResponse] with the response data
  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final Uri uri = Uri.parse('$baseUrl$endpoint');
      
      final http.Response response = await _client.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );
      
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(
        'Network error: ${e.toString()}',
        0,
      );
    }
  }
  
  /// Handles HTTP response and converts it to ApiResponse
  /// 
  /// [response] - The HTTP response
  /// Returns an [ApiResponse] with parsed data or error
  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<Map<String, dynamic>>.success(data, response.statusCode);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(
          data['message'] as String? ?? 'Unknown error',
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(
        'Failed to parse response: ${e.toString()}',
        response.statusCode,
      );
    }
  }
  
  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
