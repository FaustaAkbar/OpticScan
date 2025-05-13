import 'package:flutter/material.dart';
import 'package:IntelliSight/utils/constants/color.dart';

class StylishProgressIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool hasGlow;

  const StylishProgressIndicator({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    this.color,
    this.backgroundColor,
    this.hasGlow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = color ?? primaryColor;
    final Color bgColor = backgroundColor ?? Colors.blue.withOpacity(0.2);

    return Container(
      width: size,
      height: size,
      decoration: hasGlow
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: indicatorColor.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            )
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0, // Full circle
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(bgColor),
            ),
          ),
          // Actual progress indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          ),
        ],
      ),
    );
  }
}

// A simpler version for buttons and smaller UI elements
class ButtonProgressIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const ButtonProgressIndicator({
    Key? key,
    this.size = 20.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = color ?? Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }
}
