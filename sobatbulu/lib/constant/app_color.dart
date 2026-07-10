import 'package:flutter/rendering.dart';

class AppColors {
  static bool get isDark => false;

  static Color get primary => isDark ? const Color(0xFF6B8B9B) : const Color(0xFFaec6cf);
  static Color get secondary => isDark ? const Color(0xFF5B825B) : const Color(0xFFb2d8b2);
  static Color get secondary2 => isDark ? const Color(0xFF81C784) : const Color(0xFF446648);
  static Color get teritary => isDark ? const Color(0xFFD8A878) : const Color(0xFFffdab9);
  static Color get teritary2 => isDark ? const Color(0xFFBCAAA4) : const Color(0xFF8F715B);
  static Color get netral => isDark ? const Color(0xFFECEFF1) : const Color(0xFF2c3e50);
  static Color get netral2 => isDark ? const Color(0xFFB0BEC5) : const Color(0xFF4E6073);
  static Color get altTeritary => isDark ? const Color(0xFF8D6E63) : const Color(0xFFdebba1);
  static Color get altNetral => isDark ? const Color(0xFF90A4AE) : const Color(0xFF777777);

  static Color get bottomNav => isDark ? const Color(0xFF2E4C32) : const Color(0xFF496B4B);
  static Color get backgroundItem => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEFEDEE);
  static Color get backgroundBttn => isDark ? const Color(0xFF252525) : const Color(0xFFE9E8E8);
  static Color get item => isDark ? const Color(0xFF455A64) : const Color(0xFFC2C7CA);
  static Color get logout => isDark ? const Color(0xFF5C0006) : const Color(0xFFFFDAD6);
  static Color get logoutText => isDark ? const Color(0xFFFFDAD6) : const Color(0xFF93000A);
  static Color get textBttn => isDark ? const Color(0xFFECEFF1) : const Color(0xFF4B626A);
  static Color get textcard => isDark ? const Color(0xFFCFD8DC) : const Color(0xFF42484A);

  static Color get isFed => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEFEDEE);
  static Color get isFed2 => isDark ? const Color(0xFF2E5C2E) : const Color(0xFFC3EAC3);
  static Color get teksButton => isDark ? const Color(0xFFECEFF1) : const Color(0xFF3C535B);
  static Color get isDrink => isDark ? const Color(0xFF37474F) : const Color(0xFFAEC6CF);

  static Color get chip => isDark ? const Color(0xFF37474F) : const Color(0xFFCEE7F0);
  static Color get defaultWhite => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  static Color get defaultBlack => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get filter => isDark ? const Color(0xFF37474F) : const Color(0xFFCEE7F0);
}
