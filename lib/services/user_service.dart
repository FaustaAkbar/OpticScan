import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:opticscan/utils/constants/api_constants.dart';
import 'dart:io';

class UserService extends GetxService {
  final ApiService _apiService = ApiService();
  final RxBool isLoggedIn = false.obs;
  final RxString userRole = ''.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  Future<UserService> init() async {
    await checkAuthStatus();
    return this;
  }

  // ========= cek apakah user sudah login =========
  Future<bool> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.accessTokenKey);
      if (token == null) {
        _resetAuthState();
        return false;
      }

      // cek apakah token sudah expired
      if (JwtDecoder.isExpired(token)) {
        // coba refresh token
        final refreshed = await _refreshToken();
        if (!refreshed) {
          _resetAuthState();
          return false;
        }
      }
      // ambil role yang disimpan atau ambil data user
      final savedRole = prefs.getString(ApiConstants.userRoleKey);
      if (savedRole != null) {
        userRole.value = savedRole;
      } else {
        // ambil data user jika role tidak ditemukan
        final response = await _apiService.getCurrentUser();
        if (response.success && response.data != null) {
          userData.value = response.data;
          userRole.value = response.data['role'] ?? '';
          await prefs.setString(ApiConstants.userRoleKey, userRole.value);
        }
      }
      isLoggedIn.value = true;
      return true;
    } catch (e) {
      _resetAuthState();
      return false;
    }
  }

  // ========= login =========
  Future<ApiResponse> login(String email, String password) async {
    final response = await _apiService.login(
      email: email,
      password: password,
    );

    if (response.success) {
      isLoggedIn.value = true;
      userRole.value = response.data['role'] ?? '';
    }

    return response;
  }

  // ========= register =========
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
  }) async {
    return await _apiService.register(
      name: name,
      email: email,
      password: password,
      birthdate: birthdate,
    );
  }

  // ========= logout =========
  Future<ApiResponse> logout() async {
    final response = await _apiService.logout();
    _resetAuthState();
    return response;
  }

  // ========= reset state login =========
  void _resetAuthState() {
    isLoggedIn.value = false;
    userRole.value = '';
    userData.value = {};
  }

  // ========= refresh token =========
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      dio.options.baseUrl = _apiService.baseUrl;
      final response = await dio.get(ApiConstants.refreshEndpoint);
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
      // hapus token jika error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.accessTokenKey);
      await prefs.remove(ApiConstants.userRoleKey);
      return false;
    }
  }

  // ========= ambil data user =========
  Future<void> _fetchUserData() async {
    try {
      final response = await _apiService.getUserProfile();
      if (response.success && response.data != null) {
        userData.value = response.data;
      }
      // Silently handle unsuccessful responses
    } catch (e) {
      // Silently handle exceptions
    }
  }

  // ========= ambil data user =========
  Map<String, dynamic> get userInfo => userData;

  // ========= ambil id user =========
  int? get userId => userData['user_id'];

  // ========= ambil data profile user =========
  Future<ApiResponse> getUserProfile() async {
    return await _apiService.getUserProfile();
  }

  // ========= update data profile user =========
  Future<ApiResponse> updateUserProfile({
    String? name,
    String? email,
    String? birthdate,
  }) async {
    final response = await _apiService.updateUserProfile(
      name: name,
      email: email,
      birthdate: birthdate,
    );

    // refresh data user jika update berhasil
    if (response.success) {
      await _fetchUserData();
    }

    return response;
  }

  // ========= ubah password =========
  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await _apiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  // ========= change profile picture =========
  Future<ApiResponse> changeProfilePic(File imageFile) async {
    final response = await _apiService.changeProfilePic(imageFile);
    if (response.success && response.data != null) {
      userData.value['profile_pic'] = response.data;
    }
    return response;
  }

  // ========= ambil url gambar profile =========
  String getProfileImageUrl(String? profilePic) {
    if (profilePic == null || profilePic.isEmpty) {
      return '${ApiConstants.profileImageBaseUrl}${ApiConstants.defaultProfileImage}';
    }
    return '${ApiConstants.profileImageBaseUrl}$profilePic';
  }
}
