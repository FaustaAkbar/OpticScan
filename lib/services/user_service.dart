import 'package:get/get.dart';
import 'package:opticscan/features/authentication/models/user_model.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends GetxService {
  final ApiService _apiService = ApiService();
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn.value = await _apiService.isLoggedIn();

    if (isLoggedIn.value) {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('user_type');
      final userData = await _apiService.getUserData();

      if (userData != null) {
        currentUser.value = User.fromJson(userData);
      } else if (userType != null) {
        currentUser.value = User(
          name: 'Current User',
          email: 'user@example.com',
          userType: userType,
        );
      }
    }
  }

  Future<void> logout() async {
    final response = await _apiService.logout();
    if (response.success) {
      currentUser.value = null;
      isLoggedIn.value = false;
    }
  }
}
