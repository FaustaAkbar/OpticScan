import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/models/user_model.dart';
import 'package:opticscan/features/home/views/home_view.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final UserService _userService = Get.find<UserService>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  void _setupListeners() {
    emailController.addListener(() {
      if (emailController.text.trim().isNotEmpty) {
        emailError.value = '';
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) {
        passwordError.value = '';
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateInputs() {
    bool isValid = true;

    // Validate email
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _apiService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.success) {
        _showSuccessMessage(response.message);
        await _updateUserData(response);
        Get.offAll(() => const HomeView());
      } else {
        _showErrorMessage(response.message);
      }
    } catch (e) {
      _showErrorMessage('An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> _updateUserData(dynamic response) async {
    if (response.data != null && response.data['user_type'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_type', response.data['user_type']);

      _userService.currentUser.value = User(
        name: 'Current User',
        email: emailController.text,
        userType: response.data['user_type'],
      );
      _userService.isLoggedIn.value = true;
    }
  }
}
