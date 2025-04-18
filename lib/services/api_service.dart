import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'No message provided',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:4000';

  // Token storage keys
  static const String ACCESS_TOKEN_KEY = 'accessToken';
  static const String REFRESH_TOKEN_KEY = 'refreshToken';
  static const String USER_TYPE_KEY = 'user_type';
  static const String USER_DATA_KEY = 'user_data';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.validateStatus = (status) => status! < 500;

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _handleRequest,
      onResponse: _handleResponse,
      onError: (DioException e, handler) => handler.next(e),
    ));
  }

  Future<void> _handleRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ACCESS_TOKEN_KEY);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  Future<void> _handleResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 &&
        response.data is Map &&
        response.data.containsKey('accessToken')) {
      await _saveToken(response.data['accessToken']);

      if (response.data.containsKey('user_type')) {
        await _saveUserType(response.data['user_type']);
      }

      if (response.data.containsKey('user')) {
        await _saveUserData(response.data['user']);
      }
    }
    return handler.next(response);
  }

  // Storage methods
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN_KEY, token);
    await prefs.setString(REFRESH_TOKEN_KEY, token);
  }

  Future<void> _saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_TYPE_KEY, userType);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_DATA_KEY, jsonEncode(userData));
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN_KEY);
    await prefs.remove(REFRESH_TOKEN_KEY);
    await prefs.remove(USER_TYPE_KEY);
    await prefs.remove(USER_DATA_KEY);
  }

  // API methods
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'birthdate': birthdate.toIso8601String().split('T')[0],
          'role': 'pasien',
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Registration successful',
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Registration failed',
          data: null,
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Create user data if not present in response
        final userData = {
          'name': email.split('@')[0],
          'email': email,
          'user_type': response.data['user_type'] ?? 'pasien',
        };

        await _saveUserData(userData);

        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Login successful',
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Login failed',
          data: null,
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(REFRESH_TOKEN_KEY);

      // Set the cookie in the request
      _dio.options.headers['Cookie'] = 'jwt=$refreshToken';

      final response = await _dio.get('/logout');

      // Clear auth data regardless of response
      await _clearAuthData();

      return ApiResponse(
        success: response.statusCode == 200,
        message: response.data?['message'] ?? 'Logout successful',
        data: null,
      );
    } catch (e) {
      await _clearAuthData();
      return _handleError(e);
    }
  }

  ApiResponse _handleError(dynamic error) {
    if (error is DioException) {
      return ApiResponse(
        success: false,
        message: error.response?.data?['message'] ?? 'Network error occurred',
        data: null,
      );
    }
    return ApiResponse(
      success: false,
      message: 'An unexpected error occurred',
      data: null,
    );
  }

  // Utility methods
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(REFRESH_TOKEN_KEY) != null;
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_TYPE_KEY);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(USER_DATA_KEY);
    return userData != null
        ? jsonDecode(userData) as Map<String, dynamic>
        : null;
  }
}
