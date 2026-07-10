import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/pages/sign_in.dart';
import 'package:sobatbulu_app/services/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;

  const ChangePasswordPage({super.key, required this.email});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final oldPass = oldPasswordController.text;
    final newPass = newPasswordController.text;

    try {
      // Verifikasi dan update kata sandi melalui Firebase
      final success = await AuthService().updatePassword(
        oldPassword: oldPass,
        newPassword: newPass,
      );

      if (!mounted) return;

      if (success) {
        // Juga update di SQLite lokal sebagai sinkronisasi
        await DBHelper().updateUserByEmail(
          widget.email,
          password: newPass,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Kata sandi berhasil diubah'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Gagal mengubah kata sandi'),
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
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(e.toString().replaceAll('Exception: ', ''))),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
          "Keamanan & Kata Sandi",
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
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange[700], size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Untuk keamanan akun Anda, masukkan kata sandi lama sebelum membuat kata sandi baru.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Kata sandi lama
                _buildLabel("Kata Sandi Lama"),
                SizedBox(height: 6),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: _obscureOld,
                  decoration: _inputDecoration(
                    hintText: "Masukkan kata sandi lama",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOld ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureOld = !_obscureOld);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kata sandi lama tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Kata Sandi Baru",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                SizedBox(height: 18),

                // Kata sandi baru
                _buildLabel("Kata Sandi Baru"),
                SizedBox(height: 6),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: _obscureNew,
                  decoration: _inputDecoration(
                    hintText: "Masukkan kata sandi baru",
                    icon: Icons.lock_reset,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureNew = !_obscureNew);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kata sandi baru tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "Kata sandi minimal 6 karakter";
                    }
                    if (value == oldPasswordController.text) {
                      return "Kata sandi baru tidak boleh sama dengan yang lama";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Konfirmasi kata sandi
                _buildLabel("Konfirmasi Kata Sandi Baru"),
                SizedBox(height: 6),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: _inputDecoration(
                    hintText: "Konfirmasi kata sandi baru",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Konfirmasi kata sandi tidak boleh kosong";
                    }
                    if (value != newPasswordController.text) {
                      return "Kata sandi tidak cocok";
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
                    onPressed: _isLoading ? null : _changePassword,
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
                              Icon(Icons.shield_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Ubah Kata Sandi",
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
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 15),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[800],
                    ),
                    onPressed: () {
                      _showDeleteAccountDialog();
                    },
                    icon: const Icon(Icons.delete_forever_rounded, size: 20),
                    label: const Text(
                      "Hapus Akun SobatBulu Anda",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
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

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Hapus Akun",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Apakah Anda yakin ingin menghapus akun Anda secara permanen? Semua data Anda akan dihapus dan tindakan ini tidak dapat dibatalkan.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Masukkan Kata Sandi Anda untuk konfirmasi:",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Kata Sandi",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Kata sandi tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    "Batal",
                    style: TextStyle(
                      color: AppColors.textBttn,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isDeleting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setDialogState(() {
                            isDeleting = true;
                          });

                          try {
                            final success = await AuthService().deleteAccount(
                              passwordController.text,
                            );

                            if (success) {
                              await PreferenceHandler.logout();

                              if (context.mounted) {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => SignInPage()),
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Akun Anda berhasil dihapus secara permanen.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } else {
                              throw 'Gagal menghapus akun.';
                            }
                          } catch (e) {
                            setDialogState(() {
                              isDeleting = false;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Hapus Akun",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
