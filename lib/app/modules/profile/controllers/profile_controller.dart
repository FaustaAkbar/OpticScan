import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/constants/api_constants.dart';
import 'package:opticscan/utils/widgets/stylish_progress_indicator.dart';

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

    if (!isValid) {
      print('Form validation failed:');
      if (oldPasswordError.value.isNotEmpty)
        print('- Old password error: ${oldPasswordError.value}');
      if (newPasswordError.value.isNotEmpty)
        print('- New password error: ${newPasswordError.value}');
      if (confirmPasswordError.value.isNotEmpty)
        print('- Confirm password error: ${confirmPasswordError.value}');
    } else {
      print('Form validation successful');
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
        // Check for common error messages from backend

        oldPasswordError.value = 'Incorrect current password';
      }
    } catch (e) {
      print('Error changing password: $e');
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
    print('Starting profile update process');

    try {
      print(
          'Sending profile update request with: name=${nameController.text.trim()}, email=${emailController.text.trim()}, birthdate=${birthdate.value}');

      final response = await _userService.updateUserProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        birthdate: birthdate.value,
      );

      print(
          'Profile update response: ${response.success}, message: ${response.message}');

      if (response.success) {
        // Update observable values immediately
        name.value = nameController.text.trim();
        email.value = emailController.text.trim();

        // Format birthdate for display
        if (birthdate.value.isNotEmpty) {
          final date = DateTime.parse(birthdate.value);
          formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(date);
        }

        // Upload image if selected (do this in parallel)
        if (selectedImage.value != null) {
          await uploadProfileImage();
        }

        // Show saved status
        showSaved.value = true;
        print('Profile updated successfully, showing success status');

        // Hide saved status after delay and show dialog
        Future.delayed(const Duration(seconds: 1), () {
          // Ensure we're still in the right state before modifying values
          if (isUpdatingProfile.value) {
            showSaved.value = false;
            isUpdatingProfile.value = false;
            // Exit edit mode after showing saved status
            isEditMode.value = false;

            // Show success dialog
            _showSuccessDialog('Profile updated successfully');
            print('Edit mode exited, success dialog shown');
          }
        });
      } else {
        // Clear loading state on error
        isUpdatingProfile.value = false;
        _showErrorSnackbar(response.message);
        print('Profile update failed: ${response.message}');
      }
    } catch (e) {
      // Clear loading state on exception
      isUpdatingProfile.value = false;
      _showErrorSnackbar('An error occurred while updating profile');
      print('Exception during profile update: $e');
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

  // Show change password dialog
  void showChangePasswordDialog() {
    print('Opening change password dialog');

    // Clear previous password fields
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    // Clear errors
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // Create form key for validation
    final formKey = GlobalKey<FormState>();

    // Primary color for styling
    const Color primaryColor = Color(0xFF146EF5);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                color: primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Change Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your current password and new password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Current password field
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        hintText: 'Enter your current password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        errorText: oldPasswordError.value.isEmpty
                            ? null
                            : oldPasswordError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: primaryColor),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New password field
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Minimum 6 characters',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        errorText: newPasswordError.value.isEmpty
                            ? null
                            : newPasswordError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        prefixIcon:
                            const Icon(Icons.vpn_key, color: primaryColor),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Repeat your new password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        errorText: confirmPasswordError.value.isEmpty
                            ? null
                            : confirmPasswordError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        prefixIcon: const Icon(Icons.check_circle_outline,
                            color: primaryColor),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        } else if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
          ),
        ),
        actions: [
          Row(
            children: [
              // Cancel button
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Change button
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: isChangingPassword.value
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                print(
                                    'Form validated, calling changePassword()');
                                changePassword();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      ),
                      child: isChangingPassword.value
                          ? const ButtonProgressIndicator()
                          : const Text(
                              'Change',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )),
              ),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      ),
      barrierDismissible: true,
    );
  }

  // Show success dialog when profile is updated
  void _showSuccessDialog(String message) {
    print('Showing success dialog with message: $message');

    // Ensure loading state is cleared
    isUpdatingProfile.value = false;

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
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF146EF5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Success title
              const Text(
                'EDIT PROFILE COMPLETE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Success message
              Text(
                'You can now see your account in profile page',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // See My Profile button
              Center(
                child: SizedBox(
                  width: 219,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // Make sure to reload data after dialog is closed
                      loadProfileData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF146EF5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                            color: Color(0xFF146EF5), width: 2),
                      ),
                    ),
                    child: const Text(
                      'See My Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
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
    // Show confirmation dialog first
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
              // Logout icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Confirmation title
              const Text(
                'LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Confirmation message
              const Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Logout button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        _performLogout(); // Perform the actual logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Private method for the actual logout process
  void _performLogout() async {
    // Show loading dialog
    Get.dialog(
      const Center(
        child: StylishProgressIndicator(size: 50),
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
