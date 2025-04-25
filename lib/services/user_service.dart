import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:opticscan/utils/constants/api_constants.dart';

class UserService extends GetxService {
  final ApiService _apiService = ApiService();

  final RxBool isLoggedIn = false.obs;
  final RxString userRole = ''.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  // Initialize the service, check if user is already logged in
  Future<UserService> init() async {
    await checkAuthStatus();
    return this;
  }

  // Check if user is authenticated
  Future<bool> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.accessTokenKey);

      if (token == null) {
        _resetAuthState();
        return false;
      }

      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        // Try to refresh token
        final refreshed = await _refreshToken();
        if (!refreshed) {
          _resetAuthState();
          return false;
        }
      }

      // Get saved role or fetch current user
      final savedRole = prefs.getString(ApiConstants.userRoleKey);
      if (savedRole != null) {
        userRole.value = savedRole;
      } else {
        // Fetch user data if role not found
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

  // Login user
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

  // Register user
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

  // Logout user
  Future<ApiResponse> logout() async {
    final response = await _apiService.logout();
    _resetAuthState();
    return response;
  }

  // Reset authentication state
  void _resetAuthState() {
    isLoggedIn.value = false;
    userRole.value = '';
    userData.value = {};
  }

  // Refresh token - internal implementation
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Call refresh token endpoint directly
      final dio = Dio();
      dio.options.baseUrl = _apiService.baseUrl;

      final response = await dio.get(ApiConstants.refreshEndpoint);

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
      // Clear tokens on error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.accessTokenKey);
      await prefs.remove(ApiConstants.userRoleKey);
      return false;
    }
  }

  // Fetch current user data
  Future<void> _fetchUserData() async {
    try {
      print('Fetching updated user data');
      final response = await _apiService.getUserProfile();
      if (response.success && response.data != null) {
        print('Successfully received updated user data: ${response.data}');
        userData.value = response.data;

        // Update specific fields that might have changed
        if (userData.value.containsKey('name')) {
          print('Updating name to: ${userData.value['name']}');
        }

        if (userData.value.containsKey('email')) {
          print('Updating email to: ${userData.value['email']}');
        }

        if (userData.value.containsKey('profile_pic')) {
          print('Updating profile pic to: ${userData.value['profile_pic']}');
        }
      } else {
        print('Failed to fetch user data: ${response.message}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Get user info (name, email, etc.)
  Map<String, dynamic> get userInfo => userData;

  // Get user ID
  int? get userId => userData['user_id'];

  // Get current user profile data
  Future<ApiResponse> getUserProfile() async {
    return await _apiService.getUserProfile();
  }

  // Update user profile
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

    // Refresh user data if update was successful
    if (response.success) {
      await _fetchUserData();
    }

    return response;
  }

  // Change user password
  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await _apiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  // Change profile picture
  Future<ApiResponse> changeProfilePicture(String imagePath) async {
    final response = await _apiService.changeProfilePicture(imagePath);

    // Refresh user data if update was successful
    if (response.success) {
      await _fetchUserData();
    }

    return response;
  }

  // Get full profile image URL
  String getProfileImageUrl(String? profilePic) {
    if (profilePic == null || profilePic.isEmpty) {
      return '${ApiConstants.profileImageBaseUrl}${ApiConstants.defaultProfileImage}';
    }
    return '${ApiConstants.profileImageBaseUrl}$profilePic';
  }
}
