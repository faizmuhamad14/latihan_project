import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/models/image_picker.dart';
import 'package:sobatbulu_app/pages/change_password.dart';
import 'package:sobatbulu_app/pages/edit_profile.dart';
import 'package:sobatbulu_app/pages/sign_in.dart';
import 'package:sobatbulu_app/pages/tentang_kami.dart';
import 'package:sobatbulu_app/pages/kebijakan_privasi.dart';
import 'package:sobatbulu_app/pages/add_product_page.dart';
import 'package:sobatbulu_app/pages/add_article_page.dart';
import 'package:sobatbulu_app/services/auth_service.dart';
import 'package:sobatbulu_app/pages/manage_products_page.dart';
import 'package:sobatbulu_app/pages/manage_articles_page.dart';
import 'package:sobatbulu_app/data/list_data_map.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/services/product_service.dart';
import 'package:sobatbulu_app/pages/add_location_page.dart';
import 'package:sobatbulu_app/pages/manage_locations_page.dart';


class ProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  const ProfilePage({super.key, required this.nama, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage;
  late String _nama;
  late String _email;
  String _role = 'user';
  bool _isMigrating = false;

  Future<void> _migrateMockData() async {
    setState(() {
      _isMigrating = true;
    });

    try {
      final service = ProductService();
      int count = 0;
      for (final mockProduct in produkPetshop) {
        final productToUpload = ProdukPetshop(
          nama: mockProduct.nama,
          kategori: mockProduct.kategori,
          harga: mockProduct.harga,
          gambar: mockProduct.gambar, // Menggunakan gambar bawaan lokal
          rate: mockProduct.rate,
          jenisHewan: mockProduct.jenisHewan,
          umur: mockProduct.umur,
          ras: mockProduct.ras,
          deskripsi: mockProduct.deskripsi,
        );
        await service.addProduct(productToUpload);
        count++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Migrasi berhasil! $count produk diunggah dengan gambar bawaan.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal migrasi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMigrating = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nama = widget.nama;
    _email = widget.email;
    loadProfileImage();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = await AuthService().getUserByEmail(_email);
    if (user != null && mounted) {
      setState(() {
        _role = user.role;
      });
    }
  }

  Future<void> loadProfileImage() async {
    final imagePath = await PreferenceHandler.getProfileImage(_email);

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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
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
                Text(_nama, style: AppTextStyle.title),
                Text(_email, style: AppTextStyle.subProduk),
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
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      nama: _nama,
                                      email: _email,
                                    ),
                                  ),
                                );
                                if (result != null && result is Map<String, String>) {
                                  setState(() {
                                    _nama = result['nama'] ?? _nama;
                                    _email = result['email'] ?? _email;
                                  });
                                }
                              },
                              child: Row(
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
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePasswordPage(
                                      email: _email,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
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
                            ),
                          ],
                        ),
                      ),
                      if (_role == 'admin') ...[
                        const Text("Manajemen Konten", style: TextStyle(fontSize: 18)),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            spacing: 10,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddProductPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.add_shopping_cart_rounded, size: 26),
                                        Text(
                                          "Tambah Produk",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddArticlePage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.add_box_rounded, size: 26),
                                        Text(
                                          "Tambah Artikel",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManageProductsPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.edit_note_rounded, size: 26),
                                        Text(
                                          "Kelola Produk",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManageArticlesPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.edit_calendar_rounded, size: 26),
                                        Text(
                                          "Kelola Artikel",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddLocationPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.add_location_alt_rounded, size: 26),
                                        Text(
                                          "Tambah Lokasi",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManageLocationsPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: const [
                                        Icon(Icons.edit_location_alt_rounded, size: 26),
                                        Text(
                                          "Kelola Lokasi",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: _isMigrating ? null : _migrateMockData,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: [
                                        const Icon(Icons.cloud_upload_rounded, size: 26),
                                        Text(
                                          _isMigrating ? "Mengunggah..." : "Migrasi Data Bawaan",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    _isMigrating
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TentangKamiPage(),
                                  ),
                                );
                              },
                              child: Row(
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
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const KebijakanPrivasiPage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      const Icon(Icons.question_answer_rounded),
                                      const Text(
                                        "Kebijakan Privasi",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.chevron_right_rounded),
                                ],
                              ),
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
    ),
  );
}

  Future<void> pickImage() async {
    final image = await ImagePickerService.pickImageFromGallery();

    if (image != null) {
      final permanentFile = await ImagePickerService.saveImagePermanently(image, "profile");
      await PreferenceHandler.saveProfileImage(_email, permanentFile.path);

      setState(() {
        selectedImage = permanentFile;
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
