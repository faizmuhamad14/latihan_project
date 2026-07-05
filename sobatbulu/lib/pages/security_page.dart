import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/database/db_helper.dart';

class SecurityPage extends StatefulWidget {
  final String email;

  const SecurityPage({super.key, required this.email});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Logic ---

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final result = await DBHelper().updatePassword(
      email: widget.email,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    switch (result) {
      case 'success':
        _showSnackBar("Kata sandi berhasil diubah", isSuccess: true);
        // Bersihkan field dan kembali
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        Navigator.pop(context);
        break;
      case 'wrong_password':
        _showSnackBar("Kata sandi lama salah", isSuccess: false);
        break;
      default:
        _showSnackBar("Gagal mengubah kata sandi", isSuccess: false);
    }
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isSuccess ? AppColors.secondary2 : AppColors.logoutText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Keamanan & Kata Sandi",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textBttn,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.textBttn,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 40,
                  color: AppColors.netral2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Ubah kata sandi akun Anda",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.altNetral,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Form fields
            _buildPasswordField(
              label: "Kata Sandi Lama",
              controller: _oldPasswordController,
              isVisible: _isOldVisible,
              onToggle: () => setState(() => _isOldVisible = !_isOldVisible),
              hint: "Masukkan kata sandi lama",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kata sandi lama tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildPasswordField(
              label: "Kata Sandi Baru",
              controller: _newPasswordController,
              isVisible: _isNewVisible,
              onToggle: () => setState(() => _isNewVisible = !_isNewVisible),
              hint: "Masukkan kata sandi baru",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kata sandi baru tidak boleh kosong";
                }
                if (value.length < 6) {
                  return "Kata sandi minimal 6 karakter";
                }
                if (value == _oldPasswordController.text) {
                  return "Kata sandi baru harus berbeda dari yang lama";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildPasswordField(
              label: "Konfirmasi Kata Sandi Baru",
              controller: _confirmPasswordController,
              isVisible: _isConfirmVisible,
              onToggle: () =>
                  setState(() => _isConfirmVisible = !_isConfirmVisible),
              hint: "Ulangi kata sandi baru",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Konfirmasi kata sandi tidak boleh kosong";
                }
                if (value != _newPasswordController.text) {
                  return "Kata sandi tidak cocok";
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.teksButton,
                        ),
                      )
                    : const Text(
                        "Ubah Kata Sandi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teksButton,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.netral,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          style: const TextStyle(fontSize: 16, color: AppColors.netral),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.altNetral.withAlpha(120),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.netral2,
              size: 22,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                isVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.altNetral,
                size: 22,
              ),
            ),
            filled: true,
            fillColor: AppColors.defaultWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.item, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.netral2,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.logoutText,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
