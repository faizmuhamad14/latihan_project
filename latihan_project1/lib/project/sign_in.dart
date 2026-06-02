import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_project1/database/db_helper.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/project/home.dart';
import 'package:latihan_project1/project/sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  void login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    final pengguna = await DBHelper().loginUser(email, pass);

    if (!mounted) return;
    if (pengguna != null) {
      await PreferenceHandler.setLogin(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFaec6cf), Colors.white, Color(0xFFffdab9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            margin: EdgeInsets.fromLTRB(20, 28, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    "assets/images/kucing.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 210, left: 10, right: 10),
                  child: Column(
                    spacing: 5,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFAEC6CF),
                        ),
                        child: Icon(
                          Icons.pets,
                          size: 35,
                          color: Color(0xFF4B626A),
                        ),
                      ),
                      Text(
                        "Sahabat Bulu",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B626A),
                        ),
                      ),
                      Container(
                        width: 280,
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 14),
                        child: Text(
                          "Selamat Datang! Silahkan masuk untuk melihat profil hewan peliharaan Anda.",
                          style: TextStyle(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Masukkam alamat email",
                                hintText: "Masukkan alamat email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email tidak boleh kosong";
                                } else if (!value.contains('@')) {
                                  return "Format email tidak valid";
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kata Sandi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Lupa kata sandi?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4B626A),
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Masukkan kata sandi",
                                hintText: "Masukkan kata sandi",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Kata sandi tidak boleh kosong";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    8,
                                  ),
                                ),
                                elevation: 0,
                                side: BorderSide(color: Color(0xFFC2C7CA)),
                                backgroundColor: Color(0xFFAEC6CF),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  login();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Berhasil Login"),
                                      content: Column(
                                        children: [Text("berhasil")],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await PreferenceHandler.setLogin(
                                              true,
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePageScreen(),
                                              ),
                                            );
                                          },

                                          child: Text("Lanjutkan"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: Color(0xFF091D2E),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Icon(Icons.login, color: Color(0xFF091D2E)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      Text.rich(
                        TextSpan(
                          text: "Belum Punya Akun? ",
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                ),
                              text: "Daftar Sekarang",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
