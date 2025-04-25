import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opticscan/utils/constants/api_constants.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConstants.baseUrlEmulator;
  // Getter for base URL
  String get baseUrl => _baseUrl;

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add request interceptor to include auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from secure storage
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(ApiConstants.accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Skip token refresh for login endpoint
          if (error.requestOptions.path == ApiConstants.loginEndpoint) {
            return handler.next(error);
          }

          // Handle 401 error (unauthorized) for other endpoints
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            bool refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Method to retry a failed request
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.accessTokenKey);

    if (token != null) {
      options.headers?['Authorization'] = 'Bearer $token';
    }

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Login method
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      // Configure Dio to handle cookies properly
      final dio = Dio();
      dio.options.baseUrl = _baseUrl;
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Configure options to receive cookies from response
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Enable cookie handling
        extra: {
          'withCredentials': true,
        },
        // Make sure to receive response headers to extract cookies
        responseType: ResponseType.json,
        validateStatus: (status) => status! < 500,
      );

      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
        options: options,
      );

      if (response.statusCode == 200) {
        // Save token to secure storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            ApiConstants.accessTokenKey, response.data['accessToken']);
        await prefs.setString(ApiConstants.userRoleKey, response.data['role']);

        // Extract refresh token from cookies if present
        if (response.headers['set-cookie'] != null) {
          final cookies = response.headers['set-cookie'];

          // Find and extract jwt cookie
          final jwtCookie = cookies?.firstWhere(
            (cookie) => cookie.startsWith('jwt='),
            orElse: () => '',
          );

          if (jwtCookie != null && jwtCookie.isNotEmpty) {
            // Extract token value from cookie string
            final refreshToken = jwtCookie.split(';')[0].substring(4);
            // Store refresh token
            await prefs.setString('refresh_token', refreshToken);
          }
        }

        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Login successful',
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse(
          success: false,
          message: e.response?.data?['message'] ?? 'Login failed',
        );
      }
      return ApiResponse(
        success: false,
        message: 'Network error or server unreachable',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Register method
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
  }) async {
    try {
      // Format date to YYYY-MM-DD
      final formattedDate =
          '${birthdate.year}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}';

      final response = await _dio.post(ApiConstants.registerEndpoint, data: {
        'name': name,
        'email': email,
        'password': password,
        'birthdate': formattedDate,
        'role': 'pasien', // Default role for Flutter app users
      });

      if (response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Registration successful',
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Refresh token method
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Call refresh token endpoint
      final response = await _dio.get(ApiConstants.refreshEndpoint);

      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        // Save new token
        await prefs.setString(
            ApiConstants.accessTokenKey, response.data['accessToken']);
        return true;
      } else {
        // Clear tokens if refresh fails
        await prefs.remove(ApiConstants.accessTokenKey);
        await prefs.remove(ApiConstants.userRoleKey);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Logout method
  Future<ApiResponse> logout() async {
    try {
      // Configure Dio to send cookies with request
      final dio = Dio();
      dio.options.baseUrl = _baseUrl;

      // Get the stored refresh token if any
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      // Configure options to handle cookies properly
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Include cookie handling to ensure jwt cookie is sent
        extra: {
          'withCredentials': true,
        },
      );

      // Add refresh token in cookie format for the backend
      if (refreshToken != null) {
        options.headers?['Cookie'] = 'jwt=$refreshToken';
      }

      // Make logout request with configured options
      final response = await dio.get(
        ApiConstants.logoutEndpoint,
        options: options,
      );

      // Clear all tokens from storage
      await prefs.remove(ApiConstants.accessTokenKey);
      await prefs.remove(ApiConstants.userRoleKey);
      await prefs.remove(ApiConstants.userIdKey);
      await prefs.remove('refresh_token');

      return ApiResponse(
        success: true,
        message: response.data['message'] ?? 'Logged out successfully',
      );
    } catch (e) {
      // Still clear tokens on error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.accessTokenKey);
      await prefs.remove(ApiConstants.userRoleKey);
      await prefs.remove(ApiConstants.userIdKey);
      await prefs.remove('refresh_token');

      return ApiResponse(
        success: false,
        message: 'Error during logout, but tokens cleared',
      );
    }
  }

  // Get authenticated user info
  Future<ApiResponse> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.userInfoEndpoint);

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: 'User data retrieved successfully',
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to get user data',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get user data',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Get examination results
  Future<ApiResponse> getExaminationResults() async {
    try {
      final response = await _dio.get(ApiConstants.getExamResultsEndpoint);

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: 'Examination results retrieved successfully',
          data: response.data['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message:
              response.data['message'] ?? 'Failed to get examination results',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? 'Failed to get examination results',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Submit examination (upload eye scan)
  Future<ApiResponse> submitExamination({
    required String imagePath,
    String? complaints,
  }) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'eye_pic':
            await MultipartFile.fromFile(imagePath, filename: 'eye_scan.jpg'),
        if (complaints != null && complaints.isNotEmpty)
          'complaints': complaints,
      });

      // Send request
      final response = await _dio.post(
        ApiConstants.submitExamEndpoint,
        data: formData,
      );

      if (response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message:
              response.data['message'] ?? 'Examination submitted successfully',
          data: response.data['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to submit examination',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to submit examination',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Get user profile data
  Future<ApiResponse> getUserProfile() async {
    try {
      final response = await _dio.get(ApiConstants.getUserProfileEndpoint);

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: 'Profile data retrieved successfully',
          data: response.data['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to get profile data',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get profile data',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Update user profile data
  Future<ApiResponse> updateUserProfile({
    String? name,
    String? email,
    String? birthdate,
  }) async {
    try {
      final data = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (birthdate != null) 'birthdate': birthdate,
      };

      final response = await _dio.patch(
        ApiConstants.updateUserProfileEndpoint,
        data: data,
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Profile updated successfully',
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to update profile',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Change password
  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.patch(
        ApiConstants.changePasswordEndpoint,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Password changed successfully',
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to change password',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to change password',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Change profile picture
  Future<ApiResponse> changeProfilePicture(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'profile_pic': await MultipartFile.fromFile(
          imagePath,
          filename: 'profile_pic.jpg',
        ),
      });

      final response = await _dio.patch(
        ApiConstants.changeProfilePicEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ??
              'Profile picture updated successfully',
          data: response.data['file'],
        );
      } else {
        return ApiResponse(
          success: false,
          message:
              response.data['message'] ?? 'Failed to update profile picture',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? 'Failed to update profile picture',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}
