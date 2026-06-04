import 'package:flutter/material.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/pages/home.dart';
import 'package:latihan_project1/pages/sign_up.dart';

class SplashScreen extends StatefulWidget {
  final String nama;
  const SplashScreen({super.key, required this.nama});
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
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageScreen(nama: widget.nama),
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
