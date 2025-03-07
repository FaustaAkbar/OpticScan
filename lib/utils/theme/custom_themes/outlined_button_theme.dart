import 'package:flutter/material.dart';

class OoutlinedButtonTheme {
  OoutlinedButtonTheme._();

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF4ABED9),
      minimumSize: const Size(double.infinity, 50),
      side: const BorderSide(color: Color(0xFF4ABED9)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
