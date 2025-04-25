import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/animations/animation.dart';

class SignupController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Animation controller for signup animations
  late AnimationController animationController;

  // Services
  final UserService _userService = Get.find<UserService>();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);

  // Validation errors
  final nameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final birthDateError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupTextFieldListeners();

    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: AnimationDurations.formEntrance,
    );

    // Start the animation
    animationController.forward();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.onClose();
  }

  // Setup listeners to clear errors when user types
  void _setupTextFieldListeners() {
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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A73E8),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
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

    return '${birthDate.value!.day.toString().padLeft(2, '0')}/'
        '${birthDate.value!.month.toString().padLeft(2, '0')}/'
        '${birthDate.value!.year}';
  }

  bool _validateInputs() {
    bool isValid = true;

    // Reset all errors
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
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _userService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        birthdate: birthDate.value!,
      );

      if (response.success) {
        _showSuccessMessage(response.message);
        Get.offNamed(Routes.LOGIN);
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
