import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:IntelliSight/utils/constants/color.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashContent();
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> {
  late SplashscreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SplashscreenController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.showIcon.value
                ? AnimatedBuilder(
                    animation: controller.logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.logoScaleAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/icons/icon.png',
                            width: 20,
                            height: 20,
                            color: primaryColor,
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink()),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AnimatedBuilder(
                      animation: controller.textController,
                      builder: (context, child) {
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(controller.splashText.length,
                              (index) {
                            final int seamlesslyStartIndex =
                                "Apply your future ".length;
                            bool isHighlighted = index >=
                                    seamlesslyStartIndex &&
                                index <
                                    seamlesslyStartIndex + "seamlessly".length;

                            return AnimatedBuilder(
                              animation: controller.letterAnimationController
                                  .letterControllers[index],
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: controller.letterAnimationController
                                      .letterOpacityAnimations[index],
                                  child: SlideTransition(
                                    position: controller
                                        .letterAnimationController
                                        .letterOffsetAnimations[index],
                                    child: Transform.scale(
                                      scale: controller
                                          .letterAnimationController
                                          .letterScaleAnimations[index]
                                          .value,
                                      child: Text(
                                        controller.splashText[index],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: isHighlighted
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isHighlighted
                                              ? primaryColor
                                              : Colors.black87,
                                          decoration: isHighlighted
                                              ? TextDecoration.underline
                                              : null,
                                          decorationColor: isHighlighted
                                              ? primaryColor.withAlpha(76)
                                              : null,
                                          decorationThickness:
                                              isHighlighted ? 2 : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
