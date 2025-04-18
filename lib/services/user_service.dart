import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final String? userType;
  final DateTime? birthdate;

  User({
    this.id,
    required this.name,
    required this.email,
    this.userType,
    this.birthdate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'birthdate': birthdate?.toIso8601String(),
    };
  }
}

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
