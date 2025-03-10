import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/controllers/signup_controller.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Staggered animations for each element
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _nameFieldFadeAnimation;
  late Animation<double> _birthDateFieldFadeAnimation;
  late Animation<double> _emailFieldFadeAnimation;
  late Animation<double> _passwordFieldFadeAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<double> _dividerFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Main fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Staggered animations for each section
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
    ));

    _nameFieldFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.35, curve: Curves.easeOut),
    ));

    _birthDateFieldFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.25, 0.45, curve: Curves.easeOut),
    ));

    _emailFieldFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
    ));

    _passwordFieldFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.45, 0.65, curve: Curves.easeOut),
    ));

    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
    ));

    _dividerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 0.95, curve: Curves.easeOut),
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // =============== HEADER ===============
                    FadeTransition(
                      opacity: _headerFadeAnimation,
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
                    FadeTransition(
                      opacity: _nameFieldFadeAnimation,
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
                    FadeTransition(
                      opacity: _birthDateFieldFadeAnimation,
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
                                onTap: () =>
                                    controller.selectBirthDate(context),
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
                                                controller.birthDate.value ==
                                                        null
                                                    ? FontWeight.w400
                                                    : null,
                                            fontSize:
                                                controller.birthDate.value ==
                                                        null
                                                    ? 12
                                                    : null,
                                            color: controller.birthDate.value ==
                                                    null
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
                    FadeTransition(
                      opacity: _emailFieldFadeAnimation,
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
                    FadeTransition(
                      opacity: _passwordFieldFadeAnimation,
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
                                obscureText:
                                    !controller.isPasswordVisible.value,
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
                    FadeTransition(
                      opacity: _buttonFadeAnimation,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.95, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Obx(() => ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.signup,
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // =============== DIVIDER SECTION ===============
                    FadeTransition(
                      opacity: _dividerFadeAnimation,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.95, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Get.to(() => LoginView());
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}
