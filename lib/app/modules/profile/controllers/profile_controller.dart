import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  // User data observables
  final name = 'James'.obs;
  final age = '24'.obs;
  final email = 'James@gmail.com'.obs;
  final password = '••••••'.obs;

  // Overall edit mode flag
  final isEditMode = false.obs;

  // Status message
  final statusMessage = ''.obs;
  final showSaved = false.obs;

  // Selected index for bottom navigation
  final selectedIndex = 2.obs; // 2 for profile tab

  // Error messages
  final nameError = ''.obs;
  final ageError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  // Text editing controllers for form fields
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    // Initialize text controllers with current values
    nameController = TextEditingController(text: name.value);
    ageController = TextEditingController(text: age.value);
    emailController = TextEditingController(text: email.value);
    passwordController =
        TextEditingController(text: '123456'); // Dummy password
    _setupListeners();
  }

  void _setupListeners() {
    nameController.addListener(() {
      if (nameController.text.trim().isNotEmpty) {
        nameError.value = '';
      }
    });

    ageController.addListener(() {
      if (ageController.text.isNotEmpty) {
        ageError.value = '';
      }
    });
    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
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
    // Dispose text controllers
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Enter edit mode and init the controllers with current values
  void enterEditMode() {
    // Clear all error messages
    clearErrors();

    // Update text field controllers with current values
    nameController.text = name.value;
    ageController.text = age.value;
    emailController.text = email.value;

    // Enter edit mode
    isEditMode.value = true;
  }

  // Exit edit mode without saving
  void cancelEdit() {
    isEditMode.value = false;
    clearErrors();
  }

  // Clear all error messages
  void clearErrors() {
    nameError.value = '';
    ageError.value = '';
    emailError.value = '';
    passwordError.value = '';
  }

  // Validate all form fields
  bool validateForm() {
    bool isValid = true;

    // Clear previous errors
    clearErrors();

    // Validate name (required)
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'First name is required';
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      isValid = false;
    }

    // Validate age (must be a number and in reasonable range)
    if (ageController.text.trim().isEmpty) {
      ageError.value = 'Age is required';
      isValid = false;
    } else {
      try {
        int age = int.parse(ageController.text.trim());
        if (age < 0 || age > 120) {
          ageError.value = 'Please enter a valid age (0-120)';
          isValid = false;
        }
      } catch (e) {
        ageError.value = 'Age must be a number';
        isValid = false;
      }
    }

    // Validate email (required and must be valid format)
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Validate password (only if changed from dots)
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text != '123456' &&
        passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  // Save profile changes and exit edit mode
  void saveProfile() {
    // First validate the form
    if (!validateForm()) {
      return; // Don't save if validation fails
    }

    // Update the observable values
    name.value = nameController.text;
    age.value = ageController.text;
    email.value = emailController.text;
    // Don't update the displayed password visually, keep it as dots

    // Show saved status
    showSaved.value = true;

    // Hide saved status after delay
    Future.delayed(const Duration(seconds: 1), () {
      showSaved.value = false;
      // Exit edit mode after showing saved status
      isEditMode.value = false;

      // Show success dialog
      _showSuccessDialog();
    });
  }

  // Show success dialog when profile is updated
  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Check mark
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Success title
              const Text(
                'EDIT PROFILE COMPLETE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Success message
              const Text(
                'You can now see your account in profile page',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // See My Profile button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('See My Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Navigation method for bottom navbar
  void onItemTapped(int index) {
    selectedIndex.value = index;

    // Navigate based on the selected index
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Riwayat
        Get.offAllNamed(Routes.RIWAYAT);
        break;
      case 2: // Profile
        // Already on profile, no need to navigate
        break;
    }
  }

  // Method to handle logout
  void logout() {
    // Implement logout logic here
    Get.offAllNamed(Routes.LOGIN);
  }
}
