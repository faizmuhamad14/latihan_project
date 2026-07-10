import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/models/pet_model.dart';

class DetailPet extends StatefulWidget {
  final PetModel pet;
  const DetailPet({super.key, required this.pet});

  @override
  State<DetailPet> createState() => _DetailPetState();
}

class _DetailPetState extends State<DetailPet> {
  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBttn, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: Icon(Icons.edit_rounded, color: AppColors.textBttn, size: 20),
                    onPressed: _showEditDetailPet,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: pet.gambarPet != null
                  ? Stack(
                      children: [
                        // Blurred Background to cover the container beautifully
                        Positioned.fill(
                          child: Image.file(
                            File(pet.gambarPet!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                        // Foreground Crisp Image showing the pet without cropping (contain fit)
                        Center(
                          child: Image.file(
                            File(pet.gambarPet!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, Color(0xFF9CB8C1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.pets_rounded,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -15, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Name & Breed/Type info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.nama,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.netral,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${pet.jenis} • ${pet.ras}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: pet.gender == "Jantan"
                              ? Colors.blue.withValues(alpha: 0.15)
                              : pet.gender == "Betina"
                                  ? Colors.pink.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              pet.gender == "Jantan"
                                  ? Icons.male_rounded
                                  : pet.gender == "Betina"
                                      ? Icons.female_rounded
                                      : Icons.question_mark_rounded,
                              color: pet.gender == "Jantan"
                                  ? Colors.blue[800]
                                  : pet.gender == "Betina"
                                      ? Colors.pink[800]
                                      : Colors.grey[800],
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pet.gender ?? "-",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: pet.gender == "Jantan"
                                    ? Colors.blue[800]
                                    : pet.gender == "Betina"
                                        ? Colors.pink[800]
                                        : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // main info cards
                  Text(
                    "Informasi Utama",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _buildInfoCard("Umur", pet.umur, Icons.hourglass_bottom_rounded, AppColors.secondary2),
                      _buildInfoCard("Berat", pet.berat != null ? "${pet.berat} Kg" : "-", Icons.monitor_weight_outlined, AppColors.teritary2),
                      _buildInfoCard("Jenis", pet.jenis, Icons.pets_rounded, AppColors.primary),
                      _buildInfoCard("Ras", pet.ras, Icons.category_rounded, AppColors.textBttn),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Detail Dates section
                  Text(
                    "Detail Tanggal & Riwayat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.cake_outlined,
                          title: "Tanggal Lahir",
                          value: pet.tanggalLahir == null || pet.tanggalLahir!.isEmpty ? "-" : pet.tanggalLahir!,
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        _buildDetailRow(
                          icon: Icons.home_outlined,
                          title: "Tanggal Adopsi",
                          value: pet.tanggalAdop == null || pet.tanggalAdop!.isEmpty ? "-" : pet.tanggalAdop!,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Catatan Pemilik section
                  Text(
                    "Catatan Pemilik",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.teritary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.teritary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.note_alt_outlined, color: AppColors.teritary2),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pet.catatan == null || pet.catatan!.isEmpty
                                ? "Belum ada catatan tambahan tentang ${pet.nama}."
                                : pet.catatan!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.netral,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textBttn, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.netral,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDetailPet() {
    String? selectedGender = widget.pet.gender;

    final beratController = TextEditingController(
      text: widget.pet.berat?.toString() ?? "",
    );

    final tanggalLahirController = TextEditingController(
      text: widget.pet.tanggalLahir ?? "",
    );

    final tanggalAdopController = TextEditingController(
      text: widget.pet.tanggalAdop ?? "",
    );

    final catatanController = TextEditingController(
      text: widget.pet.catatan ?? "",
    );

    Future<void> selectDate(BuildContext context, TextEditingController controller) async {
      DateTime initialDate = DateTime.now();
      if (controller.text.isNotEmpty) {
        try {
          initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
        } catch (_) {
          // If parsing fails, fall back to current date
        }
      }
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary, // Header background & selected day circle
                onPrimary: AppColors.textBttn, // Header text & selected day text
                surface: Colors.white, // Background of dialog
                onSurface: AppColors.netral, // Text color inside dialog
              ),
              datePickerTheme: DatePickerThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textBttn, // OK/Cancel button color
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Edit Informasi Hewan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.netral,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.netral,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 12,
                      children: [
                        ChoiceChip(
                          label: const Text("Jantan"),
                          selected: selectedGender == "Jantan",
                          selectedColor: AppColors.primary.withValues(alpha: 0.3),
                          checkmarkColor: AppColors.textBttn,
                          labelStyle: TextStyle(
                            color: selectedGender == "Jantan" ? AppColors.textBttn : Colors.black,
                            fontWeight: selectedGender == "Jantan" ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (value) {
                            setModalState(() {
                              selectedGender = "Jantan";
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text("Betina"),
                          selected: selectedGender == "Betina",
                          selectedColor: AppColors.primary.withValues(alpha: 0.3),
                          checkmarkColor: AppColors.textBttn,
                          labelStyle: TextStyle(
                            color: selectedGender == "Betina" ? AppColors.textBttn : Colors.black,
                            fontWeight: selectedGender == "Betina" ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (value) {
                            setModalState(() {
                              selectedGender = "Betina";
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: beratController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Berat (Kg)",
                        prefixIcon: const Icon(Icons.monitor_weight_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: tanggalLahirController,
                      readOnly: true,
                      onTap: () => selectDate(context, tanggalLahirController),
                      decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: tanggalAdopController,
                      readOnly: true,
                      onTap: () => selectDate(context, tanggalAdopController),
                      decoration: InputDecoration(
                        labelText: "Tanggal Adopsi",
                        prefixIcon: const Icon(Icons.home_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Catatan Tambahan",
                        prefixIcon: const Icon(Icons.note_alt_outlined),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final updatedPet = PetModel(
                            id: widget.pet.id,
                            nama: widget.pet.nama,
                            jenis: widget.pet.jenis,
                            ras: widget.pet.ras,
                            umur: widget.pet.umur,
                            ownerEmail: widget.pet.ownerEmail,
                            gambarPet: widget.pet.gambarPet,
                            gender: selectedGender,
                            berat: beratController.text.isEmpty
                                ? null
                                : int.tryParse(beratController.text),
                            tanggalLahir: tanggalLahirController.text,
                            tanggalAdop: tanggalAdopController.text,
                            catatan: catatanController.text,
                          );

                          await DBHelper().updatePet(updatedPet);

                          if (!context.mounted) return;
                          Navigator.pop(context);

                          setState(() {
                            widget.pet.gender = selectedGender;
                            widget.pet.berat = int.tryParse(beratController.text);
                            widget.pet.tanggalLahir = tanggalLahirController.text;
                            widget.pet.tanggalAdop = tanggalAdopController.text;
                            widget.pet.catatan = catatanController.text;
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}