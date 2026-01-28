import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffF5F6FA),
    primaryColor: const Color(0xff4F6EF7),
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      primary: Color(0xff4F6EF7),
      background: Color(0xffF5F6FA),
      surface: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff0F1115),
    primaryColor: const Color(0xff4F6EF7),
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff4F6EF7),
      background: Color(0xff0F1115),
      surface: Color(0xff1A1C22),
    ),
  );
}
