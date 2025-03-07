import 'package:flutter/material.dart';
import 'package:opticscan/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:opticscan/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:opticscan/utils/theme/custom_themes/text_field_theme.dart';

class OAppTheme {
  OAppTheme._();

  static ThemeData themeApp = ThemeData(
    primaryColor: const Color(0xFFFFFFFF),
    fontFamily: "Cabin",
    elevatedButtonTheme: OElevatedButtonTheme.elevatedButtonTheme,
    outlinedButtonTheme: OoutlinedButtonTheme.outlinedButtonTheme,
    inputDecorationTheme: OTextFormFieldTheme.inputDecorationTheme,
  );
}
