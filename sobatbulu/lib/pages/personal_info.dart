import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/models/user_model.dart';

class PersonalInfoPage extends StatefulWidget {
  final String email;

  const PersonalInfoPage({super.key, required this.email});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kotaController = TextEditingController();
  final _noTelpController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kotaController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }

  // --- Data Operations ---

  Future<void> _loadUserData() async {
    final user = await DBHelper().getUserByEmail(widget.email);

    if (user != null) {
      _namaController.text = user.nama;
      _kotaController.text = user.kota;
      _noTelpController.text = user.noTelp;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await DBHelper().updateUserInfo(
      email: widget.email,
      nama: _namaController.text.trim(),
      kota: _kotaController.text.trim(),
      noTelp: _noTelpController.text.trim(),
    );

    // Sync nama ke SharedPreferences agar konsisten di seluruh app
    if (success) {
      await PreferenceHandler.saveNama(_namaController.text.trim());
    }

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Informasi berhasil disimpan"
              : "Gagal menyimpan informasi",
        ),
        backgroundColor: success ? AppColors.secondary2 : AppColors.logoutText,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Informasi Pribadi",
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
      actions: [
        if (!_isEditing)
          IconButton(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_rounded, color: AppColors.textBttn),
          ),
      ],
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
                  Icons.person_rounded,
                  size: 40,
                  color: AppColors.netral2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.altNetral,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Form fields
            _buildInfoField(
              label: "Nama",
              controller: _namaController,
              icon: Icons.person_outline_rounded,
              hint: "Masukkan nama lengkap",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: "Kota",
              controller: _kotaController,
              icon: Icons.location_city_rounded,
              hint: "Masukkan kota tempat tinggal",
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: "No. Telepon",
              controller: _noTelpController,
              icon: Icons.phone_rounded,
              hint: "Masukkan nomor telepon",
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 10) {
                  return "Nomor telepon minimal 10 digit";
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save / Cancel buttons
            if (_isEditing) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
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
          enabled: _isEditing,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontSize: 16, color: AppColors.netral),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.altNetral.withAlpha(120),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: _isEditing ? AppColors.netral2 : AppColors.altNetral,
              size: 22,
            ),
            filled: true,
            fillColor: _isEditing
                ? AppColors.defaultWhite
                : AppColors.backgroundItem,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.item,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.item.withAlpha(80),
                width: 1,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() => _isEditing = false);
              _loadUserData(); // Reset ke data awal
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.netral2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Batal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.netral2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveUserData,
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
                    "Simpan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teksButton,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
