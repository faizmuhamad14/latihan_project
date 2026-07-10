import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class AppTextStyle {
  static TextStyle get title => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get subtitle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textcard,
  );

  static TextStyle get logout => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.logoutText,
  );

  static TextStyle get body => const TextStyle(fontSize: 14);

  static TextStyle get button => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get produkTitle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get subProduk => const TextStyle(fontSize: 16);

  static TextStyle get addPet => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.netral,
  );

  // text style untuk informasi
  static TextStyle get informasiPage => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xffffffff),
  );
}
