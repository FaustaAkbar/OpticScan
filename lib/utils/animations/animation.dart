import 'package:flutter/material.dart';

/// Animation durations
class AnimationDurations {
  static const Duration splash = Duration(milliseconds: 2000);
  static const Duration formEntrance = Duration(milliseconds: 1800);
  static const Duration buttonScale = Duration(milliseconds: 1000);
  static const Duration fieldStagger = Duration(milliseconds: 100);
}

/// Animation curves
class AnimationCurves {
  static const Curve main = Curves.easeOut;
  static const Curve elastic = Curves.elasticOut;
  static const Curve field = Curves.easeOutCubic;
}

/// Animation controller provider mixin
mixin FormAnimationControllerProvider<T extends StatefulWidget> on State<T> {
  late AnimationController animationController;

  /// Initialize the animation controller
  void initAnimationController(TickerProvider vsync, {Duration? duration}) {
    animationController = AnimationController(
      vsync: vsync,
      duration: duration ?? AnimationDurations.formEntrance,
    );
  }

  /// Start the animation
  void startAnimation() {
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

/// Form animation builder
class FormAnimationBuilder extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final bool enableSlideAnimation;

  const FormAnimationBuilder({
    super.key,
    required this.controller,
    required this.child,
    this.enableSlideAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    // Main fade animation
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: AnimationCurves.main,
    ));

    // Slide animation (optional)
    final slideAnimation = enableSlideAnimation
        ? Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: controller,
            curve: AnimationCurves.main,
          ))
        : null;

    return FadeTransition(
      opacity: fadeAnimation,
      child: slideAnimation != null
          ? SlideTransition(position: slideAnimation, child: child)
          : child,
    );
  }
}

/// Staggered form field animation
class StaggeredFormField extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final double startInterval;
  final double endInterval;

  const StaggeredFormField({
    super.key,
    required this.controller,
    required this.child,
    required this.startInterval,
    required this.endInterval,
  });

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(startInterval, endInterval, curve: AnimationCurves.field),
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}

/// Button animation builder
class AnimatedButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? loadingWidget;

  const AnimatedButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: AnimationDurations.buttonScale,
      curve: AnimationCurves.elastic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: isLoading && loadingWidget != null ? loadingWidget : child,
    );
  }
}

/// Helper class to create staggered intervals for form fields
class StaggeredIntervals {
  final int totalFields;
  final double startTime;
  final double endTime;
  final double overlap;

  StaggeredIntervals({
    required this.totalFields,
    this.startTime = 0.0,
    this.endTime = 0.8,
    this.overlap = 0.5,
  });

  /// Get start and end intervals for a field at a specific index
  Map<String, double> getFieldInterval(int index) {
    final fieldDuration =
        (endTime - startTime) / (totalFields * (1 - overlap) + overlap);
    final start = startTime + index * fieldDuration * (1 - overlap);
    final end = start + fieldDuration;

    return {
      'start': start.clamp(0.0, 1.0),
      'end': end.clamp(0.0, 1.0),
    };
  }
}

/// Letter animation controller for splash screen
class LetterAnimationController {
  final TickerProvider vsync;
  final String text;
  final List<AnimationController> letterControllers = [];
  final List<Animation<double>> letterScaleAnimations = [];
  final List<Animation<double>> letterOpacityAnimations = [];
  final List<Animation<Offset>> letterOffsetAnimations = [];

  LetterAnimationController({
    required this.vsync,
    required this.text,
  }) {
    _initControllers();
  }

  void _initControllers() {
    for (int i = 0; i < text.length; i++) {
      final controller = AnimationController(
        vsync: vsync,
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
        begin: Offset(0, -1.0 - (i % 3) * 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      letterControllers.add(controller);
      letterScaleAnimations.add(scaleAnimation);
      letterOpacityAnimations.add(opacityAnimation);
      letterOffsetAnimations.add(offsetAnimation);
    }
  }

  Future<void> animateLetters() async {
    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      letterControllers[i].forward();
    }
  }

  void dispose() {
    for (var controller in letterControllers) {
      controller.dispose();
    }
  }
}
