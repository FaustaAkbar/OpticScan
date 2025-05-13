import 'package:IntelliSight/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:IntelliSight/utils/widgets/stylish_progress_indicator.dart';
import 'package:IntelliSight/utils/constants/api_constants.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: StylishProgressIndicator(size: 40));
        }
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.loadProfileData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Stack(
          children: [
            // tampilan utama profile
            _buildMainProfileView(context),
            // overlay edit profile (ditampilkan saat isEditMode true)
            if (controller.isEditMode.value) _buildEditProfileOverlay(context),
          ],
        );
      }),
    );
  }

  // tampilan utama profile dengan tombol edit dan logout
  Widget _buildMainProfileView(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // gambar profile
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: controller.profilePic.value.isNotEmpty
                      ? Image.network(
                          '${ApiConstants.baseUrlEmulator}${ApiConstants.profileImageBaseUrl}/${controller.profilePic.value}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/blank-profile-pic.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/blank-profile-pic.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // nama di bawah gambar profile
            Text(
              controller.name.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            // role user
            Text(
              controller.role.value.capitalize ?? "User",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // tombol edit profile
            Center(
              child: SizedBox(
                width: 240,
                height: 36,
                child: ElevatedButton(
                  onPressed: () => controller.enterEditMode(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "EDIT PROFILE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // tombol ubah password
            Center(
              child: SizedBox(
                width: 240,
                height: 36,
                child: OutlinedButton(
                  onPressed: () => controller.showChangePasswordDialog(),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "CHANGE PASSWORD",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // tampilan informasi profile
            _buildProfileInfo(),

            const SizedBox(height: 20),

            // tombol logout
            Center(
              child: SizedBox(
                width: 185,
                height: 28,
                child: ElevatedButton.icon(
                  onPressed: () => controller.logout(),
                  icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                  label: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // tampilan informasi profile
  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // nama (hanya tampilan)
        _buildInfoField(
          label: 'Name',
          value: controller.name.value,
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        // tanggal lahir (hanya tampilan)
        _buildInfoField(
          label: 'Birthdate',
          value: controller.formattedBirthdate.value,
          icon: Icons.cake,
        ),
        const SizedBox(height: 16),

        // email (hanya tampilan)
        _buildInfoField(
          label: 'Email',
          value: controller.email.value,
          icon: Icons.email,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // tampilan field hanya tampilan
  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 288,
          height: 33,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // overlay edit profile
  Widget _buildEditProfileOverlay(BuildContext context) {
    return Positioned.fill(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundLight,
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: backgroundLight,
          child: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gambar profile
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Obx(() {
                                  if (controller.selectedImage.value != null) {
                                    return Image.file(
                                      controller.selectedImage.value!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image.network(
                                      '${ApiConstants.baseUrlEmulator}${ApiConstants.profileImageBaseUrl}/${controller.profilePic.value}',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/blank-profile-pic.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  }
                                }),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: controller.isUploadingImage.value
                                      ? null
                                      : () => controller.pickImage(),
                                ),
                              ),
                            ),
                            if (controller.isUploadingImage.value)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: StylishProgressIndicator(size: 30),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // field form langsung
                      // nama
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 288,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.nameError.value.isNotEmpty
                                    ? Colors.red
                                    : primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: SizedBox(
                              width: 288,
                              height: 33,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: Colors.black,
                                    selectionColor:
                                        primaryColor.withOpacity(0.3),
                                    selectionHandleColor: primaryColor,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: controller.nameController,
                                  enabled: !controller.showSaved.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .nameError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .nameError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .nameError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    hintText: 'Enter your name',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.edit_outlined,
                                      color:
                                          controller.nameError.value.isNotEmpty
                                              ? Colors.red
                                              : primaryColor,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (controller.nameError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 16),
                              child: Text(
                                controller.nameError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // tanggal lahir
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 288,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Birthdate',
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: SizedBox(
                              width: 288,
                              height: 33,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: Colors.black,
                                    selectionColor:
                                        primaryColor.withOpacity(0.3),
                                    selectionHandleColor: primaryColor,
                                  ),
                                ),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text:
                                          controller.formattedBirthdate.value),
                                  enabled: !controller.showSaved.value,
                                  onTap: () =>
                                      controller.selectBirthdate(context),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .birthdateError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .birthdateError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .birthdateError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    hintText: 'Select birthdate',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    suffixIcon: const Icon(Icons.calendar_today,
                                        size: 20, color: primaryColor),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Birthdate is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (controller.birthdateError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Text(
                                controller.birthdateError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 288,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.emailError.value.isNotEmpty
                                    ? Colors.red
                                    : primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: SizedBox(
                              width: 288,
                              height: 33,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: Colors.black,
                                    selectionColor:
                                        primaryColor.withOpacity(0.3),
                                    selectionHandleColor: primaryColor,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: controller.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !controller.showSaved.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .emailError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .emailError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller
                                                .emailError.value.isNotEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.edit_outlined,
                                      color:
                                          controller.emailError.value.isNotEmpty
                                              ? Colors.red
                                              : primaryColor,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (!GetUtils.isEmail(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (controller.emailError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 16),
                              child: Text(
                                controller.emailError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // tombol simpan
                      Center(
                        child: SizedBox(
                          width: 185,
                          height: 28,
                          child: Obx(() => ElevatedButton(
                                onPressed: controller.showSaved.value ||
                                        controller.isUpdatingProfile.value
                                    ? null
                                    : () => controller.saveProfile(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  disabledBackgroundColor: primaryColor,
                                ),
                                child: controller.isUpdatingProfile.value
                                    ? const ButtonProgressIndicator()
                                    : Text(
                                        controller.showSaved.value
                                            ? "SAVED"
                                            : "SAVE",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              )),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // tombol cancel
                      Center(
                        child: SizedBox(
                          width: 185,
                          height: 28,
                          child: OutlinedButton(
                            onPressed: controller.showSaved.value
                                ? null
                                : controller.cancelEdit,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              disabledForegroundColor: Colors.grey.shade400,
                            ),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
