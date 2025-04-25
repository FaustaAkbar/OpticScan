import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/constants/api_constants.dart';

class ProfileController extends GetxController {
  // User service
  final UserService _userService = Get.find<UserService>();

  // Profile data
  final profileData = {}.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // User data observables
  final name = ''.obs;
  final email = ''.obs;
  final birthdate = ''.obs;
  final profilePic = ''.obs;
  final role = ''.obs;
  final formattedBirthdate = ''.obs;

  // Overall edit mode flag
  final isEditMode = false.obs;

  // Status message
  final statusMessage = ''.obs;
  final showSaved = false.obs;

  // Selected index for bottom navigation
  final selectedIndex = 2.obs; // 2 for profile tab

  // Loading states
  final isUpdatingProfile = false.obs;
  final isChangingPassword = false.obs;
  final isUploadingImage = false.obs;

  // Error messages
  final nameError = ''.obs;
  final birthdateError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  // Text editing controllers for form fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  // Selected image for upload
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();

    // Initialize text controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController(text: '••••••');
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _setupListeners();

    // Load user profile data
    loadProfileData();
  }

  void _setupListeners() {
    nameController.addListener(() {
      if (nameController.text.trim().isNotEmpty) {
        nameError.value = '';
      }
    });

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        emailError.value = '';
      }
    });

    oldPasswordController.addListener(() {
      if (oldPasswordController.text.isNotEmpty) {
        oldPasswordError.value = '';
      }
    });

    newPasswordController.addListener(() {
      if (newPasswordController.text.isNotEmpty) {
        newPasswordError.value = '';
      }
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text.isNotEmpty) {
        confirmPasswordError.value = '';
      }
    });
  }

  @override
  void onClose() {
    // Dispose text controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load user profile data from backend
  Future<void> loadProfileData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _userService.getUserProfile();

      if (response.success && response.data != null) {
        profileData.value = response.data;

        // Update observables
        name.value = profileData['name'] ?? '';
        email.value = profileData['email'] ?? '';
        birthdate.value = profileData['birthdate'] ?? '';
        profilePic.value = profileData['profile_pic'] ?? '';
        role.value = profileData['role'] ?? '';

        // Format birthdate for display
        if (birthdate.value.isNotEmpty) {
          final date = DateTime.parse(birthdate.value);
          formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(date);
        }

        // Update text controllers
        nameController.text = name.value;
        emailController.text = email.value;
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load profile data';
    } finally {
      isLoading.value = false;
    }
  }

  // Get profile image URL
  String get profileImageUrl =>
      _userService.getProfileImageUrl(profilePic.value);

  // Enter edit mode and init the controllers with current values
  void enterEditMode() {
    // Clear all error messages
    clearErrors();

    // Update text field controllers with current values
    nameController.text = name.value;
    emailController.text = email.value;

    // Enter edit mode
    isEditMode.value = true;
  }

  // Exit edit mode without saving
  void cancelEdit() {
    isEditMode.value = false;
    clearErrors();
    selectedImage.value = null;
  }

  // Clear all error messages
  void clearErrors() {
    nameError.value = '';
    birthdateError.value = '';
    emailError.value = '';
    passwordError.value = '';
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';
  }

  // Validate profile form fields
  bool validateProfileForm() {
    bool isValid = true;

    // Clear previous errors
    nameError.value = '';
    emailError.value = '';
    birthdateError.value = '';

    // Validate name (required)
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      isValid = false;
    }

    // Validate birthdate
    if (birthdate.value.isEmpty) {
      birthdateError.value = 'Birthdate is required';
      isValid = false;
    }

    // Validate email (required and must be valid format)
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    return isValid;
  }

  // Validate password change form
  bool validatePasswordForm() {
    bool isValid = true;

    // Clear previous errors
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // Validate old password
    if (oldPasswordController.text.isEmpty) {
      oldPasswordError.value = 'Current password is required';
      isValid = false;
    }

    // Validate new password
    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = 'New password is required';
      isValid = false;
    } else if (newPasswordController.text.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isValid = false;
    } else if (confirmPasswordController.text != newPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }

  // Change password
  Future<void> changePassword() async {
    if (!validatePasswordForm()) return;

    isChangingPassword.value = true;

    try {
      final response = await _userService.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (response.success) {
        Get.back(); // Close the password dialog
        _showSuccessSnackbar('Password changed successfully');

        // Clear password fields
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while changing password');
    } finally {
      isChangingPassword.value = false;
    }
  }

  // Update profile
  Future<void> saveProfile() async {
    // First validate the form
    if (!validateProfileForm()) {
      return; // Don't save if validation fails
    }

    isUpdatingProfile.value = true;

    try {
      final response = await _userService.updateUserProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        birthdate: birthdate.value,
      );

      if (response.success) {
        // Update observable values
        name.value = nameController.text;
        email.value = emailController.text;

        // Format birthdate for display
        if (birthdate.value.isNotEmpty) {
          final date = DateTime.parse(birthdate.value);
          formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(date);
        }

        // Upload image if selected
        if (selectedImage.value != null) {
          await uploadProfileImage();
        }

        // Show saved status
        showSaved.value = true;

        // Hide saved status after delay
        Future.delayed(const Duration(seconds: 1), () {
          showSaved.value = false;
          // Exit edit mode after showing saved status
          isEditMode.value = false;

          // Show success dialog
          _showSuccessDialog('Profile updated successfully');
        });
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while updating profile');
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage() async {
    if (selectedImage.value == null) return;

    isUploadingImage.value = true;

    try {
      final response = await _userService.changeProfilePicture(
        selectedImage.value!.path,
      );

      if (response.success) {
        // Update profile picture
        profilePic.value = response.data ?? '';
        selectedImage.value = null;
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while uploading image');
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Pick birthdate using a date picker
  Future<void> selectBirthdate(BuildContext context) async {
    DateTime initialDate;
    if (birthdate.value.isNotEmpty) {
      initialDate = DateTime.parse(birthdate.value);
    } else {
      initialDate = DateTime.now()
          .subtract(const Duration(days: 365 * 18)); // Default to 18 years ago
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'SELECT BIRTHDATE',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format in yyyy-MM-dd for backend
      birthdate.value = DateFormat('yyyy-MM-dd').format(picked);

      // Format for display
      formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(picked);

      // Clear any error
      birthdateError.value = '';
    }
  }

  // Show success dialog when profile is updated
  void _showSuccessDialog(String message) {
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
                'PROFILE UPDATED',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Success message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Show change password dialog
  void showChangePasswordDialog() {
    // Clear previous password fields
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    // Clear errors
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog title
                  const Center(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Current password field
                  TextField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: oldPasswordError.value.isEmpty
                          ? null
                          : oldPasswordError.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // New password field
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: newPasswordError.value.isEmpty
                          ? null
                          : newPasswordError.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm password field
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: confirmPasswordError.value.isEmpty
                          ? null
                          : confirmPasswordError.value,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel button
                      TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: const Text('Cancel'),
                      ),

                      // Change button
                      ElevatedButton(
                        onPressed:
                            isChangingPassword.value ? null : changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isChangingPassword.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Change Password'),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
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
  void logout() async {
    // Show loading dialog
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      // Call logout API
      final response = await _userService.logout();

      // Close loading dialog
      Get.back();

      if (response.success) {
        // Show success message
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message but continue with logout navigation
        Get.snackbar(
          'Note',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      // Navigate to login screen
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error message
      Get.snackbar(
        'Error',
        'An error occurred during logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Still navigate to login screen
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
