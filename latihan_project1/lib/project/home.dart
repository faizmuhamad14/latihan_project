import 'package:flutter/material.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/project/sign_in.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
  void isLogout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              isLogout();
            },
            child: Text("Logout"),
          ),
        ),
      ),
    );
  }
}
