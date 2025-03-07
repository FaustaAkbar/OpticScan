import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/controllers/login_controller.dart';
import 'package:opticscan/features/authentication/screens/signup/signup.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
                  'LOGIN',
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
                    text: 'Login to continue to access ',
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
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // =============== FORM FIELD ===============
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
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

                // =============== LOGIN BUTTON ===============
                Obx(() => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ABED9),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
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
                        'Don\'t have any account?',
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

                // =============== CREATE ACCOUNT BUTTON ===============
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => SignupView());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4ABED9),
                    side: const BorderSide(color: Color(0xFF4ABED9)),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
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
