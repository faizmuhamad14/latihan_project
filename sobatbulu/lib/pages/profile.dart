import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/models/image_picker.dart';
import 'package:sobatbulu_app/pages/sign_in.dart';

class ProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  const ProfilePage({super.key, required this.nama, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage;
  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final imagePath = await PreferenceHandler.getProfileImage(widget.email);

    if (imagePath != null) {
      setState(() {
        selectedImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
        // actions: <Widget>[
        //   IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        // ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          spacing: 10,
          children: [
            Column(
              spacing: 5,
              children: [
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : const AssetImage("assets/images/boxicon.jpg")
                              as ImageProvider,
                  ),
                ),
                Text(widget.nama, style: AppTextStyle.title),
                Text(widget.email, style: AppTextStyle.subProduk),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                Icon(Icons.chevron_right_rounded),
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
                                      "Tentang Kami",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.logout,
                            foregroundColor: AppColors.logoutText,

                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.logoutText),
                              borderRadius: BorderRadiusGeometry.circular(12),
                            ),
                          ),
                          onPressed: () {
                            isLogout();
                          },
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.exit_to_app_rounded, size: 18),
                              Text("Keluar", style: AppTextStyle.logout),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final image = await ImagePickerService.pickImageFromGallery();

    if (image != null) {
      await PreferenceHandler.saveProfileImage(widget.email, image.path);

      setState(() {
        selectedImage = image;
      });
    }
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
