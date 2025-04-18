import 'package:flutter/material.dart';

class OTextFormFieldTheme {
  OTextFormFieldTheme._();

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xACACACAC)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xACACACAC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xACACACAC)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xACACACAC)),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 14.0,
    ),
    hintStyle: const TextStyle(
        color: Color(0xACACACAC), fontWeight: FontWeight.w400, fontSize: 12),
  );
}
