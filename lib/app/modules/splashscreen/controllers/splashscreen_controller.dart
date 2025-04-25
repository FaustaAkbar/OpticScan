import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/utils/animations/animation.dart';
import 'package:opticscan/services/user_service.dart';

class SplashscreenController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController textController;
  late Animation<double> logoScaleAnimation;

  final String splashText = "Apply your future seamlessly.";
  late LetterAnimationController letterAnimationController;

  var showIcon = false.obs;
  // Using late to get the service during onInit, not during controller creation
  late UserService _userService;

  @override
  void onInit() {
    super.onInit();

    // Setup animations
    _setupAnimations();

    // Start the animation sequence
    _startAnimationSequence();
  }

  void _setupAnimations() {
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: logoController,
      curve: Curves.elasticOut,
    ));

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    letterAnimationController = LetterAnimationController(
      vsync: this,
      text: splashText,
    );
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    showIcon.value = true;
    logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    await letterAnimationController.animateLetters();

    // Check if user is already logged in
    try {
      // Try to get UserService (which should be initialized by now)
      _userService = Get.find<UserService>();
      await _userService.checkAuthStatus();

      await Future.delayed(const Duration(milliseconds: 1000));
      textController.forward().then((_) {
        // Navigate to HOME if logged in, otherwise to LOGIN
        String route =
            _userService.isLoggedIn.value ? Routes.HOME : Routes.LOGIN;

        Get.offNamed(
          route,
          arguments: {
            'transition': Transition.fadeIn,
            'duration': const Duration(milliseconds: 800),
          },
        );
      });
    } catch (e) {
      // If UserService is not available yet, just go to login
      await Future.delayed(const Duration(milliseconds: 1000));
      textController.forward().then((_) {
        Get.offNamed(
          Routes.LOGIN,
          arguments: {
            'transition': Transition.fadeIn,
            'duration': const Duration(milliseconds: 800),
          },
        );
      });
    }
  }

  @override
  void onClose() {
    logoController.dispose();
    textController.dispose();
    letterAnimationController.dispose();
    super.onClose();
  }
}
