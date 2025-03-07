import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateForm() {
    bool isValid = true;

    // Reset errors
    emailError.value = '';
    passwordError.value = '';

    // Validate email
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
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
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoading.value = false;

      if (response.success) {
        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home page or dashboard
        // Get.offAll(() => HomePage());
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
