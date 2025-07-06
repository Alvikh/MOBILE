import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/routes.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class ApiEndpoints {
  static const String url = 'https://pey.my.id';
  static const String baseUrl = '$url/api';

  static String get register => '/register';
  static String get login => '/login';
  static String get completeProfile => '/complete-profile';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _initDio();
  }

  late Dio _dio;
  String? _token;

  String get baseUrl => ApiEndpoints.baseUrl;
  String get url => ApiEndpoints.url;

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    _addInterceptors();
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _updateDioHeaders();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _updateDioHeaders();
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _updateDioHeaders();
  }

  void _updateDioHeaders() {
    _dio.options.headers = {
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<Response> _refreshToken() async {
    final refreshToken = await UserPreferencesService().getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await _dio.post(
      '/refresh',
      data: {'refresh_token': refreshToken},
    );

    if (response.data['success'] == true) {
      await UserPreferencesService().saveTokens(
        authToken: response.data['token'],
        refreshToken: response.data['refresh_token'],
      );
      await setToken(response.data['token']);
    }

    return response;
  }

  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        print('Headers: ${options.headers}');
        print('Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('Error: ${error.response?.statusCode} ${error.message}');
        if (error.response?.statusCode == 401) {
          try {
            await _refreshToken();
            final request = error.requestOptions;
            final opts = Options(
              method: request.method,
              headers: request.headers,
            );
            final response = await _dio.request(
              request.path,
              options: opts,
              data: request.data,
              queryParameters: request.queryParameters,
            );
            return handler.resolve(response);
          } catch (e) {
            await UserPreferencesService().clearUserData();
            navigatorKey.currentState?.pushReplacementNamed(AppRoutes.login);
            return handler.reject(error);
          }
        }
        return handler.reject(error);
      },
    ));
  }

  String getToken() {
    return _token ?? "";
  }

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? body, bool useToken = true}) async {
    try {
      final response = await _dio.get(
        endpoint,
        data: body,
        options: Options(headers: useToken ? null : {'Authorization': null}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic body,
      {bool useToken = true}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: useToken ? null : {'Authorization': null}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic body,
      {bool useToken = true}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(headers: useToken ? null : {'Authorization': null}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {bool useToken = true}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: useToken ? null : {'Authorization': null}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return {
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': response.data['message'] ?? 'Request failed',
        'statusCode': response.statusCode,
        'errors': response.data['errors'] ?? null,
      };
    }
  }

  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return {
          'success': false,
          'message': error.response?.data['message'] ?? 'Request failed',
          'statusCode': error.response?.statusCode,
          'errors': error.response?.data['errors'] ?? null,
        };
      } else {
        return {
          'success': false,
          'message': error.message ?? 'Network error occurred',
          'statusCode': null,
        };
      }
    } else if (error is ApiException) {
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
