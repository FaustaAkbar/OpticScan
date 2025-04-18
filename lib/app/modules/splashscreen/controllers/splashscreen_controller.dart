import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/utils/animations/animation.dart';

class SplashscreenController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController textController;
  late Animation<double> logoScaleAnimation;

  final String splashText = "Apply your future seamlessly.";
  late LetterAnimationController letterAnimationController;

  var showIcon = false.obs;

  @override
  void onInit() {
    super.onInit();

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

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    showIcon.value = true;
    logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    await letterAnimationController.animateLetters();

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

  @override
  void onClose() {
    logoController.dispose();
    textController.dispose();
    letterAnimationController.dispose();
    super.onClose();
  }
}
