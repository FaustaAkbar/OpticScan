import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app/modules/signup/controllers/signup_controller.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/animations/animation.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserService _userService = Get.find<UserService>();
  late AnimationController animationController;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    animationController = AnimationController(
      vsync: this,
      duration: AnimationDurations.formEntrance,
    );
    animationController.forward();
    clearFormFields();
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

  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
    emailError.value = '';
    passwordError.value = '';
  }

  void resetAnimation() {
    animationController.reset();
    animationController.forward();
  }

  void goToSignup() {
    clearFormFields();
    if (Get.isRegistered<SignupController>()) {
      final signupController = Get.find<SignupController>();
      signupController.resetAnimation();
    }
    Get.offNamed(Routes.SIGNUP);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.onClose();
  }

  // ========= toggle password visibility =========
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ========= validasi input =========
  bool _validateInputs() {
    bool isValid = true;
    // validasi email
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }
    // validasi password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    }

    return isValid;
  }

  // ========= proses login =========
  Future<void> login() async {
    if (!_validateInputs()) return;
    try {
      isLoading.value = true;
      final response = await _userService.login(
        emailController.text.trim(),
        passwordController.text,
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
