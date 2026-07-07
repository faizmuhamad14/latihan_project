import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/pages/main_screen_dpd.dart';
import 'package:sobatbulu_app/pages/sign_up.dart';
import 'package:sobatbulu_app/services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final pass = passwordController.text;

    try {
      final pengguna = await _authService.login(
        email: email,
        password: pass,
      );

      if (!mounted) return;
      if (pengguna != null) {
        await PreferenceHandler.saveEmail(pengguna.email);
        await PreferenceHandler.setLogin(true);
        await PreferenceHandler.saveNama(pengguna.nama);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainScreenDpd(nama: pengguna.nama, email: pengguna.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email belum terdaftar atau kata sandi salah"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFaec6cf), Colors.white, Color(0xFFffdab9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
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
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            "assets/images/logo_bg.png",
                          ),
                        ),
                        // Icon(
                        //   Icons.pets,
                        //   size: 35,
                        //   color: Color(0xFF4B626A),
                        // ),
                      ),
                      Text(
                        "Sobat Bulu",
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
                                labelText: "Masukkan alamat email",
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
                                // Text(
                                //   "Lupa kata sandi?",
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w600,
                                //     color: Color(0xFF4B626A),
                                //   ),
                                // ),
                              ],
                            ),
                            TextFormField(
                              obscureText: true,
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
                            SizedBox(height: 5),
                             SizedBox(
                               width: double.infinity,
                               child: ElevatedButton(
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
                                 onPressed: _isLoading
                                     ? null
                                     : () {
                                         if (_formKey.currentState!.validate()) {
                                           login();
                                         }
                                       },
                                 child: _isLoading
                                     ? const SizedBox(
                                         height: 20,
                                         width: 20,
                                         child: CircularProgressIndicator(
                                           strokeWidth: 2,
                                           valueColor: AlwaysStoppedAnimation<Color>(
                                             Color(0xFF091D2E),
                                           ),
                                         ),
                                       )
                                     : Row(
                                         spacing: 10,
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
                             ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
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
