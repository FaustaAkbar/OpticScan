import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/controllers/signup_controller.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // =============== HEADER ===============
                const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontFamily: "Greycliff",
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    text: 'Create your ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xACACACAC),
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'SightAI',
                        style: TextStyle(
                          color: Color(0xFF4ABED9),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xACACACAC),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // =============== FORM FIELD ===============
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                      controller: controller.nameController,
                      style: TextStyle(
                          fontFamily: "Cabin",
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        errorText: controller.nameError.value.isEmpty
                            ? null
                            : controller.nameError.value,
                      ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: "Cabin",
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        errorText: controller.emailError.value.isEmpty
                            ? null
                            : controller.emailError.value,
                      ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      style: TextStyle(
                          fontFamily: "Cabin",
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        errorText: controller.passwordError.value.isEmpty
                            ? null
                            : controller.passwordError.value,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 24,
                              width: 1,
                              color: Color(0xACACACAC),
                            ),
                            IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFF597EF7),
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 40),

                // =============== SIGN-UP BUTTON ===============
                Obx(() => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.signup,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    )),
                const SizedBox(height: 24),

                // =============== DIVIDER SECTION ===============
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color(0xACACACAC),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xACACACAC),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color(0xACACACAC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // =============== LOGIN BUTTON ===============
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => LoginView());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF597EF7),
                    side: BorderSide(
                      color: Color(0xFF597EF7),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
