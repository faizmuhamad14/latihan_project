import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/pages/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textBttn,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.pets, color: AppColors.textBttn),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              ClipRRect(child: Image.asset('assets/images/orang.jpg')),
              Container(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      isLogout();
                    },
                    child: Text("Logout"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void isLogout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen(nama: '')),
      (route) => false,
    );
  }
}
