import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/controllers/signup_controller.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';
import 'package:opticscan/utils/animations/animation.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin, FormAnimationControllerProvider {
  late StaggeredIntervals _intervals;

  @override
  void initState() {
    super.initState();

    initAnimationController(this);
    _intervals = StaggeredIntervals(
      totalFields: 6, // Header, name, birth date, email, password, button
      endTime: 0.8,
    );
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FormAnimationBuilder(
              controller: animationController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // =============== HEADER ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(0)['start']!,
                    endInterval: _intervals.getFieldInterval(0)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                text: 'OpticScan',
                                style: TextStyle(
                                  color: Color(0xFF146EF5),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // =============== NAME FIELD ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(1)['start']!,
                    endInterval: _intervals.getFieldInterval(1)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => TextField(
                              cursorColor: Colors.black,
                              controller: controller.nameController,
                              style: const TextStyle(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // =============== BIRTH DATE FIELD ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(2)['start']!,
                    endInterval: _intervals.getFieldInterval(2)['end']!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birth date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => InkWell(
                              onTap: () => controller.selectBirthDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 14.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: const Color(0xACACACAC)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.formatBirthDate() ??
                                            'Select birth date',
                                        style: TextStyle(
                                          fontWeight:
                                              controller.birthDate.value == null
                                                  ? FontWeight.w400
                                                  : null,
                                          fontSize:
                                              controller.birthDate.value == null
                                                  ? 12
                                                  : null,
                                          color:
                                              controller.birthDate.value == null
                                                  ? const Color(0xACACACAC)
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today,
                                        color: Color(0xFF146EF5)),
                                  ],
                                ),
                              ),
                            )),
                        if (controller.birthDateError.value.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 17),
                            child: Obx(() => Text(
                                  controller.birthDateError.value,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 172, 43, 34),
                                    fontSize: 12,
                                  ),
                                )),
                          ),
                      ],
                    ),
                  ),

                  // =============== EMAIL FIELD ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(3)['start']!,
                    endInterval: _intervals.getFieldInterval(3)['end']!,
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

                  // =============== PASSWORD FIELD ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(4)['start']!,
                    endInterval: _intervals.getFieldInterval(4)['end']!,
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
                                        color: const Color(0xFF146EF5),
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

                  // =============== SIGN-UP BUTTON ===============
                  StaggeredFormField(
                    controller: animationController,
                    startInterval: _intervals.getFieldInterval(5)['start']!,
                    endInterval: _intervals.getFieldInterval(5)['end']!,
                    child: Obx(() => AnimatedButton(
                          isLoading: controller.isLoading.value,
                          loadingWidget: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.signup,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const CircularProgressIndicator(
                                color: Colors.white),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.signup,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
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
                    controller: animationController,
                    startInterval: 0.75,
                    endInterval: 0.95,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color(0xACACACAC),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xACACACAC),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color(0xACACACAC),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // =============== LOGIN BUTTON ===============
                        AnimatedButton(
                          child: OutlinedButton(
                            onPressed: () {
                              Get.off(() => LoginView());
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
