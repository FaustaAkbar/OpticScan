import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:opticscan/utils/animations/animation.dart';
import 'package:opticscan/utils/constants/color.dart';
import 'package:opticscan/utils/widgets/stylish_progress_indicator.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final animCtrl = controller.animationController;
    final intervals = StaggeredIntervals(
      totalFields: 4, // Header, email, password, button
      endTime: 0.8,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FormAnimationBuilder(
              controller: animCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // =============== HEADER ===============
                  StaggeredFormField(
                    controller: animCtrl,
                    startInterval: intervals.getFieldInterval(0)['start']!,
                    endInterval: intervals.getFieldInterval(0)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                text: 'OpticScan',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // =============== FORM FIELDS ===============
                  StaggeredFormField(
                    controller: animCtrl,
                    startInterval: intervals.getFieldInterval(1)['start']!,
                    endInterval: intervals.getFieldInterval(1)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => TextField(
                              cursorColor: Colors.black,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  StaggeredFormField(
                    controller: animCtrl,
                    startInterval: intervals.getFieldInterval(2)['start']!,
                    endInterval: intervals.getFieldInterval(2)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => TextField(
                              cursorColor: Colors.black,
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              style: const TextStyle(
                                  fontFamily: "Cabin",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                errorText:
                                    controller.passwordError.value.isEmpty
                                        ? null
                                        : controller.passwordError.value,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 1,
                                      color: const Color(0xACACACAC),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: primaryColor,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // =============== LOGIN BUTTON ===============
                  StaggeredFormField(
                    controller: animCtrl,
                    startInterval: intervals.getFieldInterval(3)['start']!,
                    endInterval: intervals.getFieldInterval(3)['end']!,
                    child: Obx(() => AnimatedButton(
                          isLoading: controller.isLoading.value,
                          loadingWidget: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: ButtonProgressIndicator(
                                size: 20,
                              ),
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 24),

                  // =============== DIVIDER SECTION ===============
                  StaggeredFormField(
                    controller: animCtrl,
                    startInterval: 0.7,
                    endInterval: 0.9,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xACACACAC),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                                color: const Color(0xACACACAC),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // =============== CREATE ACCOUNT BUTTON ===============
                        AnimatedButton(
                          child: OutlinedButton(
                            onPressed: () => controller.goToSignup(),
                            style: OutlinedButton.styleFrom(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
