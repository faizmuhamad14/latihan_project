import 'package:flutter/material.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/pages/main_screen_dpd.dart';
import 'package:latihan_project1/pages/sign_in.dart';

class SplashScreen extends StatefulWidget {
  final String nama;
  final String email;
  const SplashScreen({super.key, required this.nama, required this.email});
  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (!PreferenceHandler.isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      print("IS LOGIN = ${PreferenceHandler.isLogin}");
      print("NAMA = ${await PreferenceHandler.getNama()}");
      final nama = await PreferenceHandler.getNama();
      final email = await PreferenceHandler.getEmail();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreenDpd(nama: nama, email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Color(0xFFEBF4F6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/images/logo1.png')],
        ),
      ),
    );
  }
}
