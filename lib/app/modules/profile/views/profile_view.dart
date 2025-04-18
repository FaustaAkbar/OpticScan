import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => Stack(
            children: [
              // Main Profile View
              _buildMainProfileView(),

              // Edit Profile Overlay (shown when isEditMode is true)
              if (controller.isEditMode.value) _buildEditProfileOverlay(),
            ],
          )),
    );
  }

  // The main profile view with edit button and logout
  Widget _buildMainProfileView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'assets/images/image.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Name below profile picture
            Obx(() => Text(
                  controller.name.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                )),

            const SizedBox(height: 20),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.enterEditMode(),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: const Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Profile Information Display
            _buildProfileInfo(),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.logout(),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "LOGOUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display-only profile information
  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field (display only)
        _buildInfoField(
          label: 'Name',
          value: controller.name.value,
        ),
        const SizedBox(height: 16),

        // Age Field (display only)
        _buildInfoField(
          label: 'Age',
          value: controller.age.value,
        ),
        const SizedBox(height: 16),

        // Email Field (display only)
        _buildInfoField(
          label: 'Email',
          value: controller.email.value,
        ),
        const SizedBox(height: 16),

        // Password Field (display only)
        _buildInfoField(
          label: 'Password',
          value: controller.password.value,
        ),
      ],
    );
  }

  // Display-only field
  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // The edit profile overlay
  Widget _buildEditProfileOverlay() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Picture
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      'assets/images/image.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Name below profile picture
              Text(
                controller.name.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Profile Form Fields
              _buildEditForm(),

              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.showSaved.value
                          ? null
                          : controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBackgroundColor: Colors.blue,
                      ),
                      child: Text(
                        controller.showSaved.value ? "SAVED" : "SAVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),

              const SizedBox(height: 10),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed:
                      controller.showSaved.value ? null : controller.cancelEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey.shade400,
                  ),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Form for editing profile
  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        _buildEditField(
          label: 'First Name',
          controller: controller.nameController,
        ),
        const SizedBox(height: 16),

        // Age Field
        _buildEditField(
          label: 'Age',
          controller: controller.ageController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // Email Field
        _buildEditField(
          label: 'Email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // Password Field
        _buildEditField(
          label: 'Password',
          controller: controller.passwordController,
          isPassword: true,
        ),
      ],
    );
  }

  // Editable field with edit icon
  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    // Get the correct error message based on the field
    String errorText = '';
    Color borderColor = Colors.blue;

    switch (label) {
      case 'First Name':
      case 'Name':
        errorText = this.controller.nameError.value;
        borderColor = errorText.isNotEmpty ? Colors.red.shade300 : Colors.blue;
        break;
      case 'Age':
        errorText = this.controller.ageError.value;
        borderColor = errorText.isNotEmpty ? Colors.red.shade300 : Colors.blue;
        break;
      case 'Email':
        errorText = this.controller.emailError.value;
        borderColor = errorText.isNotEmpty ? Colors.red.shade300 : Colors.blue;
        break;
      case 'Password':
        errorText = this.controller.passwordError.value;
        borderColor = errorText.isNotEmpty ? Colors.red.shade300 : Colors.blue;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: borderColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  enabled: !this.controller.showSaved.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    hintText: 'Enter your ${label.toLowerCase()}',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.edit_outlined,
                  color: borderColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
