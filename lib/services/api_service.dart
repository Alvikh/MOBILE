import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.19:8000/api';

  static String get register => '/register';
  static String get login => '/login';
  static String get completeProfile => '/complete-profile';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  ApiService._internal();
  factory ApiService() => _instance;

  String? _token;

  String get baseUrl => ApiEndpoints.baseUrl;

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  String getToken() {
    return _token ?? "";
  }

  /// Load token from local storage
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  /// Clear token from memory and storage
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Build headers for API request
  Map<String, String> _buildHeaders(bool useToken) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json', // Important for Laravel API
    };

    if (useToken && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    print(headers);
    return headers;
  }

  /// GET request
  Future<dynamic> get(String endpoint, {bool useToken = true}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(useToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// POST request
  Future<dynamic> post(String endpoint, dynamic body,
      {bool useToken = true}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(useToken),
        body: jsonEncode(body),
      );
      print(jsonEncode(body));
      print(jsonEncode(response.body));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, dynamic body,
      {bool useToken = true}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(useToken),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint, {bool useToken = true}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(useToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    print('Status Code: ${response.statusCode}');
    print('Content-Type: ${response.headers['content-type']}');
    print('Body: ${response.body}');

    final contentType = response.headers['content-type'] ?? '';

    // If not JSON, return error
    if (!contentType.contains('application/json')) {
      return {
        'success': false,
        'message':
            'Invalid response format: expected JSON but got $contentType',
        'statusCode': response.statusCode,
      };
    }

    try {
      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Request failed',
          'statusCode': response.statusCode,
          'errors': responseData['errors'] ?? null,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to parse response: $e',
        'statusCode': response.statusCode,
      };
    }
  }

  /// Handle unexpected errors
  dynamic _handleError(dynamic error) {
    if (error is ApiException) {
      throw error;
    } else {
      return {
        'success': false,
        'message': 'Unexpected error: $error',
        'statusCode': null,
      };
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
