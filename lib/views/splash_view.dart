import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';

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
  final List<AnimationController> _letterControllers = [];
  final List<Animation<double>> _letterScaleAnimations = [];
  final List<Animation<double>> _letterOpacityAnimations = [];
  final List<Animation<Offset>> _letterOffsetAnimations = [];

  bool _showIcon = false;

  // Find the start index of "seamlessly" in the text
  final int _seamlesslyStartIndex = "Apply your future ".length;

  @override
  void initState() {
    super.initState();

    // Logo animation
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

    // Text animation setup
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create controllers for each letter
    for (int i = 0; i < _text.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      final scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      final opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ));

      final offsetAnimation = Tween<Offset>(
        begin: Offset(0, -1.0 - (i % 3) * 0.5), // Varied starting positions
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      _letterControllers.add(controller);
      _letterScaleAnimations.add(scaleAnimation);
      _letterOpacityAnimations.add(opacityAnimation);
      _letterOffsetAnimations.add(offsetAnimation);
    }

    // Start the animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // First show the logo
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _showIcon = true;
    });
    _logoController.forward();

    // Then animate each letter with a delay
    await Future.delayed(const Duration(milliseconds: 800));

    for (int i = 0; i < _text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      _letterControllers[i].forward();
    }

    // After all letters are animated, wait and then navigate
    await Future.delayed(const Duration(milliseconds: 1000));

    // Final flourish animation
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
    for (var controller in _letterControllers) {
      controller.dispose();
    }
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
            // Logo Animation
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
                        color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.visibility_outlined,
                        size: 40,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 40),

            // Text Animation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wrap in a flexible to handle text overflow
                  Flexible(
                    child: AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(_text.length, (index) {
                            // Check if this letter is part of "seamlessly"
                            bool isHighlighted = index >=
                                    _seamlesslyStartIndex &&
                                index <
                                    _seamlesslyStartIndex + "seamlessly".length;

                            return AnimatedBuilder(
                              animation: _letterControllers[index],
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _letterOpacityAnimations[index],
                                  child: SlideTransition(
                                    position: _letterOffsetAnimations[index],
                                    child: Transform.scale(
                                      scale:
                                          _letterScaleAnimations[index].value,
                                      child: Text(
                                        _text[index],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: isHighlighted
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isHighlighted
                                              ? const Color(0xFF1A73E8)
                                              : Colors.black87,
                                          decoration: isHighlighted
                                              ? TextDecoration.underline
                                              : null,
                                          decorationColor: isHighlighted
                                              ? const Color(0xFF1A73E8)
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
