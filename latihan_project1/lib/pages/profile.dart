import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/pages/sign_in.dart';

class ProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  const ProfilePage({super.key, required this.nama, required this.email});

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
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/orang.jpg"),
              ),
              Text(widget.nama),
              Text(widget.email),
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
          Container(
            margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: Column(
              children: [
                Column(
                  spacing: 7,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pengaturan Akun", style: TextStyle(fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(Icons.person, size: 26),
                                  Text(
                                    "Informasi Pribadi",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.security),
                              Text(
                                "Keamanan & Kata Sandi",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text("Dukungan", style: TextStyle(fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(Icons.group, size: 26),
                                  Text(
                                    "About Us",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.question_answer_rounded),
                              Text(
                                "Kebijakan Privasi",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void isLogout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignInPage()),
      (route) => false,
    );
  }
}
