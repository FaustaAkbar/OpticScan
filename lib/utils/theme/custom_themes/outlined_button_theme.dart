import 'package:flutter/material.dart';
import 'package:IntelliSight/utils/constants/color.dart';

class OoutlinedButtonTheme {
  OoutlinedButtonTheme._();

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      minimumSize: const Size(double.infinity, 50),
      side: BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
