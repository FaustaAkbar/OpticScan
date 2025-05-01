import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/services/user_service.dart';
import 'package:IntelliSight/utils/constants/color.dart';
import 'package:IntelliSight/utils/widgets/stylish_progress_indicator.dart';

class ProfileController extends GetxController {
  // User service
  final UserService _userService = Get.find<UserService>();

  // data profile
  final profileData = {}.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // data user
  final name = ''.obs;
  final email = ''.obs;
  final birthdate = ''.obs;
  final profilePic = ''.obs;
  final role = ''.obs;
  final formattedBirthdate = ''.obs;

  // mode edit
  final isEditMode = false.obs;

  // pesan status
  final statusMessage = ''.obs;
  final showSaved = false.obs;

  // index pilihan untuk navbar bawah
  final selectedIndex = 2.obs; // 2 untuk tab profile

  // loading state
  final isUpdatingProfile = false.obs;
  final isChangingPassword = false.obs;
  final isUploadingImage = false.obs;

  // pesan error
  final nameError = ''.obs;
  final birthdateError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  // controller text untuk field form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  // gambar yang dipilih untuk upload
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController(text: '••••••');
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _setupListeners();
    // Load data profile
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ========= load data profile dari backend =========
  Future<void> loadProfileData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _userService.getUserProfile();

      if (response.success && response.data != null) {
        profileData.value = response.data;

        // update data user
        name.value = profileData['name'] ?? '';
        email.value = profileData['email'] ?? '';
        birthdate.value = profileData['birthdate'] ?? '';
        profilePic.value = profileData['profile_pic'] ?? '';
        role.value = profileData['role'] ?? '';
        // format tanggal lahir untuk tampilan
        if (birthdate.value.isNotEmpty) {
          final date = DateTime.parse(birthdate.value);
          formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(date);
        }
        // update controller text
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

  // ========= ambil url gambar profile =========
  String get profileImageUrl =>
      _userService.getProfileImageUrl(profilePic.value);

  // ========= masuk mode edit dan inisialisasi controller dengan nilai saat ini =========
  void enterEditMode() {
    clearErrors();
    nameController.text = name.value;
    emailController.text = email.value;
    isEditMode.value = true;
  }

  // ========= keluar mode edit tanpa menyimpan =========
  void cancelEdit() {
    isEditMode.value = false;
    clearErrors();
    selectedImage.value = null;
  }

  // ========= hapus semua pesan error =========
  void clearErrors() {
    nameError.value = '';
    birthdateError.value = '';
    emailError.value = '';
    passwordError.value = '';
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';
  }

  // ========= validasi form profile =========
  bool validateProfileForm() {
    bool isValid = true;

    // hapus pesan error sebelumnya
    nameError.value = '';
    emailError.value = '';
    birthdateError.value = '';

    // validasi nama (required)
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      isValid = false;
    }

    // validasi tanggal lahir (required)
    if (birthdate.value.isEmpty) {
      birthdateError.value = 'Birthdate is required';
      isValid = false;
    }

    // validasi email (required dan harus format valid)
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    return isValid;
  }

  // ========= validasi form ubah password =========
  bool validatePasswordForm() {
    bool isValid = true;

    // hapus pesan error sebelumnya
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // validasi password lama (required)
    if (oldPasswordController.text.isEmpty) {
      oldPasswordError.value = 'Current password is required';
      isValid = false;
    }

    // validasi password baru (required dan harus minimal 6 karakter)
    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = 'New password is required';
      isValid = false;
    } else if (newPasswordController.text.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    // validasi password konfirmasi (required dan harus sama dengan password baru)
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isValid = false;
    } else if (confirmPasswordController.text != newPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }
    return isValid;
  }

  // ========= ubah password =========
  Future<void> changePassword() async {
    if (!validatePasswordForm()) return;
    isChangingPassword.value = true;
    try {
      final response = await _userService.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );
      if (response.success) {
        Get.back();
        _showSuccessSnackbar('Password changed successfully');
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        oldPasswordError.value = 'Incorrect current password';
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while changing password');
    } finally {
      isChangingPassword.value = false;
    }
  }

  // ========= simpan profile =========
  Future<void> saveProfile() async {
    if (!validateProfileForm()) {
      return;
    }
    isUpdatingProfile.value = true;
    try {
      final response = await _userService.updateUserProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        birthdate: birthdate.value,
      );
      if (response.success) {
        // update data user
        name.value = nameController.text.trim();
        email.value = emailController.text.trim();
        // format tanggal lahir untuk tampilan
        if (birthdate.value.isNotEmpty) {
          final date = DateTime.parse(birthdate.value);
          formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(date);
        }
        // tampilkan pesan sukses
        showSaved.value = true;
        // hide pesan sukses setelah delay dan tampilkan dialog
        Future.delayed(const Duration(seconds: 1), () {
          if (isUpdatingProfile.value) {
            showSaved.value = false;
            isUpdatingProfile.value = false;
            // keluar mode edit setelah tampilkan pesan sukses
            isEditMode.value = false;
            _showSuccessDialog('Profile updated successfully');
          }
        });
      } else {
        // hapus loading state jika gagal
        isUpdatingProfile.value = false;
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      // hapus loading state jika terjadi exception
      isUpdatingProfile.value = false;
      _showErrorSnackbar('An error occurred while updating profile');
    }
  }

  // ========= pilih gambar dari galeri =========
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        await uploadProfilePic();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ========= upload profile picture =========
  Future<void> uploadProfilePic() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isUploadingImage.value = true;
      final response =
          await _userService.changeProfilePic(selectedImage.value!);
      if (response.success) {
        profilePic.value = response.data;
        selectedImage.value = null;
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload profile picture. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  // ========= pilih tanggal lahir =========
  Future<void> selectBirthdate(BuildContext context) async {
    DateTime initialDate;
    if (birthdate.value.isNotEmpty) {
      initialDate = DateTime.parse(birthdate.value);
    } else {
      initialDate = DateTime.now().subtract(
          const Duration(days: 365 * 18)); // default 18 tahun yang lalu
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
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // format untuk backend
      birthdate.value = DateFormat('yyyy-MM-dd').format(picked);

      // format untuk tampilan
      formattedBirthdate.value = DateFormat('dd MMMM yyyy').format(picked);

      // hapus pesan error
      birthdateError.value = '';
    }
  }

  // ========= tampilkan dialog ubah password =========
  void showChangePasswordDialog() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Simple header with icon
                const SizedBox(height: 24),
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

                // Title
                const Text(
                  'Change Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 24),

                // Form Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Current Password Field
                            _buildPasswordField(
                              controller: oldPasswordController,
                              label: 'Current Password',
                              hint: 'Enter your current password',
                              errorText: oldPasswordError.value,
                              icon: Icons.lock_outlined,
                            ),
                            const SizedBox(height: 16),

                            // New Password Field
                            _buildPasswordField(
                              controller: newPasswordController,
                              label: 'New Password',
                              hint: 'Minimum 6 characters',
                              errorText: newPasswordError.value,
                              icon: Icons.vpn_key_outlined,
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            _buildPasswordField(
                              controller: confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Repeat your new password',
                              errorText: confirmPasswordError.value,
                              icon: Icons.check_circle_outline,
                            ),

                            const SizedBox(height: 24),

                            // Buttons
                            Row(
                              children: [
                                // Cancel Button
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Get.back(),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      foregroundColor: Colors.grey.shade700,
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Change Button
                                Expanded(
                                  child: Obx(() => ElevatedButton(
                                        onPressed: isChangingPassword.value
                                            ? null
                                            : () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  changePassword();
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          disabledBackgroundColor:
                                              primaryColor.withOpacity(0.6),
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
                        )),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Helper method to build password fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String errorText,
    required IconData icon,
  }) {
    final bool hasError = errorText.isNotEmpty;

    return Theme(
      data: ThemeData().copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: primaryColor.withOpacity(0.3),
          selectionHandleColor: primaryColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        cursorColor: Colors.black,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: TextStyle(
            color: hasError ? Colors.red : primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: hasError ? Colors.red.shade200 : Colors.grey.shade400,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          errorText: hasError ? errorText : null,
          errorStyle: const TextStyle(
            fontSize: 11,
            color: Colors.red,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: hasError ? Colors.red : Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: hasError ? Colors.red : Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: hasError ? Colors.red : primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          prefixIcon:
              Icon(icon, color: hasError ? Colors.red : primaryColor, size: 18),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (label == 'Current Password') {
              return 'Current password is required';
            } else if (label == 'New Password') {
              return 'New password is required';
            } else {
              return 'Confirm password is required';
            }
          } else if (label == 'New Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
          } else if (label == 'Confirm Password' &&
              value != newPasswordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  // ========= tampilkan dialog sukses =========
  void _showSuccessDialog(String message) {
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
              // icon sukses
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

              // judul sukses
              const Text(
                'EDIT PROFILE COMPLETE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // pesan sukses
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

              // tombol lihat profile
              Center(
                child: SizedBox(
                  width: 219,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // memuat ulang data setelah dialog ditutup
                      loadProfileData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: primaryColor, width: 2),
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

  // ========= tampilkan snackbar sukses =========
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // ========= tampilkan snackbar error =========
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // ========= navigasi untuk navbar bawah =========
  void onItemTapped(int index) {
    selectedIndex.value = index;

    // navigasi berdasarkan index yang dipilih
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Riwayat
        Get.offAllNamed(Routes.RIWAYAT);
        break;
      case 2: // Profile
        break;
    }
  }

  // ========= proses logout =========
  void logout() async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // icon logout
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

              // judul logout
              const Text(
                'LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // pesan logout
              const Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // tombol
              Row(
                children: [
                  // tombol cancel
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Colors.grey.shade700,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // tombol logout
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // tutup dialog
                        _performLogout(); // lakukan logout
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

  // ========= proses logout =========
  void _performLogout() async {
    // tampilkan loading dialog
    Get.dialog(
      const Center(
        child: StylishProgressIndicator(size: 50),
      ),
      barrierDismissible: false,
    );

    try {
      // panggil API logout
      final response = await _userService.logout();
      Get.back();

      if (response.success) {
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Note',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      // navigasi ke login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'An error occurred during logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
