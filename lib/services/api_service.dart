import 'package:dio/dio.dart';
import 'package:opticscan/features/authentication/models/signup_response_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.example.com';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 3000);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // =============== Signup API ===============
  Future<ApiResponse> signup({
    required String name,
    required DateTime birthDate,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'name': name,
          'birthDate':
              '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
          'email': email,
          'password': password,
        },
      );

      return ApiResponse(
        success: true,
        data: response.data['data'],
        message: response.data['message'],
      );
    } on DioException catch (e) {
      String errorMessage = 'An error occurred. Please try again later.';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is taking too long to respond. Please try again later.';
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred. Please try again later.',
      );
    }
  }

  // =============== Login API ===============

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return ApiResponse(
        success: true,
        data: response.data['data'],
        message: response.data['message'],
      );
    } on DioException catch (e) {
      String errorMessage = 'An error occurred. Please try again later.';

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? 'Invalid email or password';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is taking too long to respond. Please try again later.';
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred. Please try again later.',
      );
    }
  }
}
