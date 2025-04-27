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
  String get baseUrl => _baseUrl;
  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ambil token dari storage
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(ApiConstants.accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.requestOptions.path == ApiConstants.loginEndpoint) {
            return handler.next(error);
          }
          if (error.response?.statusCode == 401) {
            bool refreshed = await _refreshToken();
            if (refreshed) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ========= retry request =========
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

  // ========= login =========
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = _baseUrl;
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        extra: {
          'withCredentials': true,
        },
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
        // simpan token ke storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            ApiConstants.accessTokenKey, response.data['accessToken']);
        await prefs.setString(ApiConstants.userRoleKey, response.data['role']);
        if (response.headers['set-cookie'] != null) {
          final cookies = response.headers['set-cookie'];
          final jwtCookie = cookies?.firstWhere(
            (cookie) => cookie.startsWith('jwt='),
            orElse: () => '',
          );
          if (jwtCookie != null && jwtCookie.isNotEmpty) {
            final refreshToken = jwtCookie.split(';')[0].substring(4);
            //simpan refresh token ke storage
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

  // ========= register =========
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
  }) async {
    try {
      // format tanggal ke YYYY-MM-DD
      final formattedDate =
          '${birthdate.year}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}';
      final response = await _dio.post(ApiConstants.registerEndpoint, data: {
        'name': name,
        'email': email,
        'password': password,
        'birthdate': formattedDate,
        'role': 'pasien', // default role untuk user mobile adalah pasien
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

  // ========= refresh token =========
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // panggil endpoint refresh token
      final response = await _dio.get(ApiConstants.refreshEndpoint);
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        // simpan token baru
        await prefs.setString(
            ApiConstants.accessTokenKey, response.data['accessToken']);
        return true;
      } else {
        // hapus token jika refresh gagal
        await prefs.remove(ApiConstants.accessTokenKey);
        await prefs.remove(ApiConstants.userRoleKey);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ========= logout =========
  Future<ApiResponse> logout() async {
    try {
      final dio = Dio();
      dio.options.baseUrl = _baseUrl;
      // ambil refresh token dari storage
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        extra: {
          'withCredentials': true,
        },
      );
      // tambah refresh token ke cookie
      if (refreshToken != null) {
        options.headers?['Cookie'] = 'jwt=$refreshToken';
      }
      final response = await dio.get(
        ApiConstants.logoutEndpoint,
        options: options,
      );
      // hapus semua token dari storage
      await prefs.remove(ApiConstants.accessTokenKey);
      await prefs.remove(ApiConstants.userRoleKey);
      await prefs.remove(ApiConstants.userIdKey);
      await prefs.remove('refresh_token');
      return ApiResponse(
        success: true,
        message: response.data['message'] ?? 'Logged out successfully',
      );
    } catch (e) {
      // hapus token kalau error
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

  // ========= ambil data user yang login =========
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

  // ========= ambil data hasil pemeriksaan =========
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

  // ========= submit pemeriksaan (upload gambar mata) =========
  Future<ApiResponse> submitExamination({
    required String imagePath,
    String? complaints,
  }) async {
    try {
      final formData = FormData.fromMap({
        'eye_pic':
            await MultipartFile.fromFile(imagePath, filename: 'eye_scan.jpg'),
        if (complaints != null && complaints.isNotEmpty)
          'complaints': complaints,
      });
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

  // ========= ambil data profile user =========
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

  // ========= update data profile user =========
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
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 20),
        ),
      );
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Profil berhasil diperbarui',
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Gagal memperbarui profil',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse(
          success: false,
          message: e.response?.data?['message'] ?? 'Gagal memperbarui profil',
        );
      }
      return ApiResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga',
      );
    }
  }

  // ubah password
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
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'Password berhasil diubah',
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Gagal mengubah password',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse(
          success: false,
          message: e.response?.data?['message'] ?? 'Gagal mengubah password',
        );
      }
      return ApiResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga',
      );
    }
  }

  // ========= ubah gambar profile =========
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
