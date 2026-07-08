import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final String nama;
  final String email;

  const EditProfilePage({super.key, required this.nama, required this.email});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController teleponController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    emailController = TextEditingController(text: widget.email);
    teleponController = TextEditingController();
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    final currentUser = AuthService().currentUser;
    if (currentUser != null) {
      final user = await AuthService().getUserByUid(currentUser.uid);
      if (user != null && user.telepon.isNotEmpty) {
        setState(() {
          teleponController.text = user.telepon;
        });
        return;
      }
    }
    final phone = await PreferenceHandler.getTelepon(widget.email);
    if (phone.isNotEmpty) {
      setState(() {
        teleponController.text = phone;
      });
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newNama = namaController.text.trim();
    final newEmail = emailController.text.trim();
    final newTelepon = teleponController.text.trim();

    try {
      // 1. Update in Firebase
      final currentUser = AuthService().currentUser;
      bool firebaseSuccess = false;

      if (currentUser != null) {
        await AuthService().updateProfile(
          uid: currentUser.uid,
          nama: newNama,
          telepon: newTelepon,
        );

        if (newEmail != widget.email) {
          await AuthService().updateEmail(
            newEmail: newEmail,
            uid: currentUser.uid,
          );
        }
        firebaseSuccess = true;
      }

      // 2. Update in SQLite
      final success = await DBHelper().updateUserByEmail(
        widget.email,
        nama: newNama,
        email: newEmail != widget.email ? newEmail : null,
      );

      if (!mounted) return;

      if (firebaseSuccess || success) {
        // Update SharedPreferences
        await PreferenceHandler.saveNama(newNama);
        if (newEmail != widget.email) {
          await PreferenceHandler.saveEmail(newEmail);
        }
        await PreferenceHandler.saveTelepon(newEmail, newTelepon);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Profil berhasil diperbarui'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Navigator.pop(context, {
          'nama': newNama,
          'email': newEmail,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Gagal memperbarui profil'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Informasi Pribadi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textBttn,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBttn),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header info
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.textBttn, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Perbarui informasi pribadi Anda di bawah ini.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textBttn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Nama field
                _buildLabel("Nama Lengkap"),
                SizedBox(height: 6),
                TextFormField(
                  controller: namaController,
                  decoration: _inputDecoration(
                    hintText: "Masukkan nama lengkap",
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Email field
                _buildLabel("Email"),
                SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    hintText: "Masukkan email",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    if (!value.contains('@')) {
                      return "Format email tidak valid";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Nomor Telepon field
                _buildLabel("Nomor Telepon"),
                SizedBox(height: 6),
                TextFormField(
                  controller: teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    hintText: "Masukkan nomor telepon",
                    icon: Icons.phone_outlined,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 10) {
                      return "Nomor telepon minimal 10 digit";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                // Tombol simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.netral,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _saveProfile,
                    child: _isLoading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.netral,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Simpan Perubahan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 12),

                // Tombol batal
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: AppColors.textBttn),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Color(0xFFF8F9FA),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
