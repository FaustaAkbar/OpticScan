import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/utils/animations/animation.dart';
import 'package:IntelliSight/services/user_service.dart';

class SplashscreenController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController textController;
  late Animation<double> logoScaleAnimation;
  final String splashText = "Apply your future seamlessly.";
  late LetterAnimationController letterAnimationController;
  var showIcon = false.obs;
  late UserService _userService;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
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
    // cek apakah user sudah login
    try {
      // ambil service User
      _userService = Get.find<UserService>();
      // cek apakah user sudah login
      final isAuthenticated = await _userService.checkAuthStatus();

      await Future.delayed(const Duration(milliseconds: 1000));
      textController.forward().then((_) {
        // navigasi ke HOME jika sudah login, jika tidak maka ke LOGIN
        String route = isAuthenticated ? Routes.HOME : Routes.LOGIN;
        Get.offNamed(
          route,
          arguments: {
            'transition': Transition.fadeIn,
            'duration': const Duration(milliseconds: 800),
          },
        );
      });
    } catch (e) {
      // jika service User tidak tersedia, langsung ke LOGIN
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
