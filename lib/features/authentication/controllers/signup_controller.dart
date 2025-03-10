import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxString nameError = ''.obs;
  final RxString birthDateError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      if (nameController.text.trim().isNotEmpty) {
        nameError.value = '';
      }
    });

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

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF1A73E8), // Button and header background
              onPrimary: Colors.white, // Button and header foreground
              surface: Colors.white, // Dialog background
              onSurface: Colors.black87, // Dialog text
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      birthDate.value = picked;
      birthDateError.value = '';
    }
  }

  String? formatBirthDate() {
    if (birthDate.value == null) return null;
    return '${birthDate.value!.day}/${birthDate.value!.month}/${birthDate.value!.year}';
  }

  bool validateForm() {
    bool isValid = true;

    // Reset errors
    nameError.value = '';
    birthDateError.value = '';
    emailError.value = '';
    passwordError.value = '';

    // Validate name
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    }

    // Validate birth date
    if (birthDate.value == null) {
      birthDateError.value = 'Birth date is required';
      isValid = false;
    }

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
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  Future<void> signup() async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.signup(
        name: nameController.text.trim(),
        birthDate: birthDate.value!,
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoading.value = false;

      if (response.success) {
        Get.snackbar(
          'Success',
          'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login or home page
        // Get.offAll(() => LoginView());
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to create account',
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
