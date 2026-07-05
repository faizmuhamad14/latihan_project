import 'dart:io';

import 'package:flutter/material.dart';
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
    final isCat = pet.jenis.toLowerCase() == 'kucing';
    final isDog = pet.jenis.toLowerCase() == 'anjing';

    final Color accentColor = isCat
        ? AppColors.teritary2
        : (isDog ? AppColors.netral2 : AppColors.secondary2);

    final Color accentBg = isCat
        ? AppColors.teritary.withAlpha(50)
        : (isDog
              ? AppColors.primary.withAlpha(50)
              : AppColors.secondary.withAlpha(50));

    final String speciesEmoji = isCat ? "🐱" : (isDog ? "🐶" : "🐾");

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Hero Image Section ---
            _buildHeroImage(pet, accentColor, speciesEmoji),

            // --- Info Section ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Informasi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.netral,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showEditDetailPet,
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: accentColor,
                        ),
                        label: Text(
                          "Edit",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Info cards grid
                  _buildInfoRow([
                    _buildInfoCard(
                      icon: Icons.pets_rounded,
                      label: "Nama",
                      value: pet.nama,
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                    _buildInfoCard(
                      icon: Icons.category_rounded,
                      label: "Jenis",
                      value: pet.jenis,
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoRow([
                    _buildInfoCard(
                      icon: Icons.cake_rounded,
                      label: "Umur",
                      value: pet.umur,
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                    _buildInfoCard(
                      icon: Icons.star_rounded,
                      label: "Ras",
                      value: pet.ras.isNotEmpty ? pet.ras : "-",
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoRow([
                    _buildInfoCard(
                      icon: pet.gender == "Jantan"
                          ? Icons.male_rounded
                          : Icons.female_rounded,
                      label: "Gender",
                      value: pet.gender ?? "-",
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                    _buildInfoCard(
                      icon: Icons.monitor_weight_rounded,
                      label: "Berat",
                      value: pet.berat != null ? "${pet.berat} Kg" : "-",
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoRow([
                    _buildInfoCard(
                      icon: Icons.calendar_month_rounded,
                      label: "Tanggal Lahir",
                      value: pet.tanggalLahir != null &&
                              pet.tanggalLahir!.isNotEmpty
                          ? pet.tanggalLahir!
                          : "-",
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                    _buildInfoCard(
                      icon: Icons.home_rounded,
                      label: "Tanggal Adopsi",
                      value: pet.tanggalAdop != null &&
                              pet.tanggalAdop!.isNotEmpty
                          ? pet.tanggalAdop!
                          : "-",
                      accentColor: accentColor,
                      accentBg: accentBg,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeroImage(PetModel pet, Color accentColor, String emoji) {
    return Stack(
      children: [
        // Image
        Container(
          width: double.infinity,
          height: 320,
          decoration: BoxDecoration(
            color: AppColors.backgroundItem,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: pet.gambarPet != null
                ? Image.file(
                    File(pet.gambarPet!),
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Icon(
                      Icons.pets_rounded,
                      size: 80,
                      color: accentColor.withAlpha(100),
                    ),
                  ),
          ),
        ),

        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(140),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.nama,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$emoji ${pet.jenis} • ${pet.ras.isNotEmpty ? pet.ras : 'Campuran'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(200),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(List<Widget> children) {
    return Row(
      children: children
          .map(
            (child) => Expanded(child: child),
          )
          .expand(
            (widget) => [widget, const SizedBox(width: 12)],
          )
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
    required Color accentBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withAlpha(30),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: accentColor.withAlpha(180),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.netral,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundBttn,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Edit Informasi Pet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Gender",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 8),

                    Wrap(
                      spacing: 10,
                      children: [
                        ChoiceChip(
                          label: const Text("Jantan"),
                          selected: selectedGender == "Jantan",
                          selectedColor: AppColors.primary,
                          onSelected: (value) {
                            setModalState(() {
                              selectedGender = "Jantan";
                            });
                          },
                        ),

                        ChoiceChip(
                          label: const Text("Betina"),
                          selected: selectedGender == "Betina",
                          selectedColor: AppColors.primary,
                          onSelected: (value) {
                            setModalState(() {
                              selectedGender = "Betina";
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: beratController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Berat (Kg)",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: tanggalLahirController,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Lahir",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: tanggalAdopController,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Adopsi",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await DBHelper().updatePet(
                            PetModel(
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
                            ),
                          );

                          Navigator.pop(context);

                          setState(() {
                            widget.pet.gender = selectedGender;
                            widget.pet.berat = int.tryParse(
                              beratController.text,
                            );
                            widget.pet.tanggalLahir =
                                tanggalLahirController.text;
                            widget.pet.tanggalAdop = tanggalAdopController.text;
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Simpan"),
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
