import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';
import 'package:opticscan/utils/animations/animation.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;

  final String _text = "Apply your future seamlessly.";
  late LetterAnimationController _letterAnimationController;

  bool _showIcon = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _letterAnimationController = LetterAnimationController(
      vsync: this,
      text: _text,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _showIcon = true;
    });
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    await _letterAnimationController.animateLetters();

    await Future.delayed(const Duration(milliseconds: 1000));

    _textController.forward().then((_) {
      Get.off(
        () => const LoginView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _letterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =============== Logo Animation ===============
            if (_showIcon)
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF146EF5).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.visibility_outlined,
                        size: 40,
                        color: Color(0xFF146EF5),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 40),

            // =============== Text Animation ===============
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(_text.length, (index) {
                            final int seamlesslyStartIndex =
                                "Apply your future ".length;
                            bool isHighlighted = index >=
                                    seamlesslyStartIndex &&
                                index <
                                    seamlesslyStartIndex + "seamlessly".length;

                            return AnimatedBuilder(
                              animation: _letterAnimationController
                                  .letterControllers[index],
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _letterAnimationController
                                      .letterOpacityAnimations[index],
                                  child: SlideTransition(
                                    position: _letterAnimationController
                                        .letterOffsetAnimations[index],
                                    child: Transform.scale(
                                      scale: _letterAnimationController
                                          .letterScaleAnimations[index].value,
                                      child: Text(
                                        _text[index],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: isHighlighted
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isHighlighted
                                              ? const Color(0xFF146EF5)
                                              : Colors.black87,
                                          decoration: isHighlighted
                                              ? TextDecoration.underline
                                              : null,
                                          decorationColor: isHighlighted
                                              ? const Color(0xFF146EF5)
                                                  .withValues(alpha: 0.3)
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
