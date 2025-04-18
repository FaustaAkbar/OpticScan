import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:opticscan/utils/animations/animation.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  // Animation controller for login animations
  late AnimationController animationController;

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();

    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: AnimationDurations.formEntrance,
    );

    // Start the animation
    animationController.forward();
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
    animationController.dispose();
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
        Get.offNamed(Routes.HOME);
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
}
