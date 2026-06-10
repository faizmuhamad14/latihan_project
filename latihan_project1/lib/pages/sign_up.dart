import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_project1/database/db_helper.dart';
import 'package:latihan_project1/models/user_model.dart';
import 'package:latihan_project1/pages/sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  void register() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    final kota = kotaController.text;
    final nama = namaController.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi semua field!')));
      return;
    }

    final pengguna = UserModelSQL(
      nama: nama,
      email: email,
      password: pass,
      kota: kota,
    );

    bool success = await DBHelper().registerUser(pengguna);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat')));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFFaec6cf), Colors.white, Color(0xFFffdab9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 2),
          margin: EdgeInsets.all(24),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                spacing: 9,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffaec6cf),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/images/logo_bg.png"),
                    ),
                  ),
                  Text(
                    "Buat Akun Baru",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Bergabunglah dengan Sobat Bulu untuk merawat hewan peliharaan Anda dengan lebih baik.",
                  ),
                  // SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 7,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Lengkap",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: namaController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            hintText: "Masukkan nama lengkap anda",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            hintText: "Masukkan email anda",
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        Text(
                          "Kata Sandi",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Buat kata sandi",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        Text(
                          "Kota Asal",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: kotaController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            hintText: "Kota Asal",
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // color: Color(0xffaec6cf),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.blue[100],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Icon(Icons.shield),
                          Expanded(
                            child: Text(
                              "Data Anda dan hewan peliharaan Anda aman bersama Kami. Kami menghargai privasi dan keamanan Anda",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 1),
                      backgroundColor: Color(0xFFaec6cf),
                    ),
                    onPressed: register,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Daftar",
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right_alt_sharp,
                          color: Color(0xFF777777),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Sudah punya akun? ",
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            ),

                          text: "Masuk di sini",
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
          ),
        ),
      ),
    );
  }
}
