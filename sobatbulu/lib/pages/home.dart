import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/models/image_picker.dart';
import 'package:sobatbulu_app/models/pet_model.dart';
import 'package:sobatbulu_app/pages/detail_pet.dart';

class HomePageScreen extends StatefulWidget {
  final String nama;
  const HomePageScreen({super.key, required this.nama});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
  File? selectedPetImage;
  String? selectedJenis;
  final _formKey = GlobalKey<FormState>();
  late Future<String> userEmail;
  Future<List<PetModel>> getUserPets() async {
    final email = await PreferenceHandler.getEmail();

    return DBHelper().getPetByUser(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sobat Bulu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.netral,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.pets, color: AppColors.netral),
        // actions: <Widget>[
        //   IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        // ],
      ),
      body: FutureBuilder<List<PetModel>>(
        future: getUserPets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pets = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 15),
              // Carousel Banner Section
              const HomeCarousel(),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, ${widget.nama}!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.netral,
                        ),
                      ),
                      pets.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kamu belum menambahkan Pet apapun.",
                                  style: AppTextStyle.subtitle,
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: Lottie.asset(
                                    "assets/lottie/addPet.json",
                                    width: 250,
                                    height: 250,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Inilah kabar hewan peliharaan Anda hari ini",
                              style: AppTextStyle.subtitle,
                            ),
                      // Text(
                      //   pets.isEmpty
                      //       ? "Kamu belum menambahkan Pet apapun."
                      //       : "Inilah kabar hewan peliharaan Anda hari ini.",
                      //   style: TextStyle(fontSize: 18),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: FutureBuilder<List<PetModel>>(
                  future: getUserPets(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text(''));
                    }

                    final daftarPengguna = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: daftarPengguna.length,
                      itemBuilder: (context, index) {
                        final pet = daftarPengguna[index];

                        // Dynamic styling based on pet type using theme colors from AppColors
                        final isCat = pet.jenis.toLowerCase() == 'kucing';
                        final isDog = pet.jenis.toLowerCase() == 'anjing';

                        final Color accentColor = isCat
                            ? AppColors.teritary2
                            : (isDog
                                  ? AppColors.netral2
                                  : AppColors.secondary2);

                        final Color cardBgColor = isCat
                            ? AppColors.teritary.withAlpha(35)
                            : (isDog
                                  ? AppColors.primary.withAlpha(35)
                                  : AppColors.secondary.withAlpha(35));

                        final Color badgeBgColor = isCat
                            ? AppColors.teritary.withAlpha(70)
                            : (isDog
                                  ? AppColors.primary.withAlpha(70)
                                  : AppColors.secondary.withAlpha(70));

                        final String speciesEmoji = isCat
                            ? "🐱"
                            : (isDog ? "🐶" : "🐾");

                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: accentColor.withAlpha(35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withAlpha(12),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPet(pet: pet),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Pet Image with dynamic frame border
                                      Container(
                                        width: 85,
                                        height: 85,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          border: Border.all(
                                            color: accentColor.withAlpha(60),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(10),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: pet.gambarPet != null
                                              ? Image.file(
                                                  File(pet.gambarPet!),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  color: badgeBgColor,
                                                  child: Icon(
                                                    Icons.pets_rounded,
                                                    size: 36,
                                                    color: accentColor,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Pet Information Info Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              pet.nama,
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.netral,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pet.ras.isNotEmpty
                                                  ? pet.ras
                                                  : 'Campuran',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.netral
                                                    .withAlpha(160),
                                              ),
                                            ),
                                            const SizedBox(height: 10),

                                            // Modern tags/chips
                                            Row(
                                              children: [
                                                _buildPetBadge(
                                                  label:
                                                      "$speciesEmoji ${pet.jenis}",
                                                  bgColor: badgeBgColor,
                                                  textColor: accentColor,
                                                ),
                                                const SizedBox(width: 8),
                                                _buildPetBadge(
                                                  label: "🎂 ${pet.umur}",
                                                  bgColor: Colors.white,
                                                  textColor: AppColors.netral
                                                      .withAlpha(200),
                                                  hasBorder: true,
                                                  borderColor: AppColors.netral
                                                      .withAlpha(30),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Right-side actions (Edit & Chevron)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _showBottomSheet(context, pet);
                                            },
                                            icon: Icon(
                                              Icons.edit_rounded,
                                              color: accentColor,
                                              size: 18,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(8),
                                              minimumSize: const Size(36, 36),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: BorderSide(
                                                  color: accentColor.withAlpha(
                                                    50,
                                                  ),
                                                  width: 1,
                                                ),
                                              ),
                                              elevation: 1,
                                              shadowColor: Colors.black
                                                  .withAlpha(30),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: accentColor.withAlpha(120),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add_rounded, color: AppColors.defaultWhite, size: 50),
        onPressed: () => _showBottomSheet(
          context,
          PetModel(ras: '', nama: '', jenis: '', ownerEmail: '', umur: ''),
        ),
      ),
    );
  }

  Widget _buildPetBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
    bool hasBorder = false,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: hasBorder && borderColor != null
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userEmail = PreferenceHandler.getEmail();
  }

  void _showBottomSheet(BuildContext context, PetModel pets) {
    final isEdit = pets.id != null;
    final namaController = TextEditingController(text: pets.nama);

    String? selectedJenis = pets.jenis.isNotEmpty ? pets.jenis : null;
    String? selectedRas = pets.ras.isNotEmpty ? pets.ras : null;
    String? selectedUmur = pets.umur.isNotEmpty ? pets.umur : null;

    File? selectedPetImage;

    if (isEdit && pets.gambarPet != null) {
      selectedPetImage = File(pets.gambarPet!);
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Dynamic accent color based on selected pet type
            final bool isCat = selectedJenis?.toLowerCase() == 'kucing';
            final bool isDog = selectedJenis?.toLowerCase() == 'anjing';
            final Color accentColor = isCat
                ? AppColors.teritary2
                : (isDog ? AppColors.netral2 : AppColors.primary);
            final Color accentBg = isCat
                ? AppColors.teritary.withAlpha(60)
                : (isDog
                      ? AppColors.primary.withAlpha(60)
                      : AppColors.primary.withAlpha(40));

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.92,
              ),
              decoration: BoxDecoration(
                color: AppColors.defaultWhite,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Drag Handle ──
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.netral.withAlpha(40),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // ── Header Section with Gradient ──
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withAlpha(100),
                                AppColors.secondary.withAlpha(80),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(180),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  isEdit
                                      ? Icons.edit_note_rounded
                                      : Icons.pets_rounded,
                                  color: AppColors.netral,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEdit
                                          ? "Edit Pet Profile"
                                          : "Tambah Pet Baru",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.netral,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isEdit
                                          ? "Perbarui informasi hewan kesayanganmu"
                                          : "Lengkapi data hewan kesayanganmu",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.netral.withAlpha(160),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Pet Image Picker ──
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final image =
                                  await ImagePickerService.pickImageFromGallery();
                              if (image != null) {
                                setModalState(() {
                                  selectedPetImage = image;
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accentColor.withAlpha(80),
                                      width: 3,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentColor.withAlpha(30),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: accentBg,
                                    backgroundImage: selectedPetImage != null
                                        ? FileImage(selectedPetImage!)
                                        : null,
                                    child: selectedPetImage == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .add_a_photo_outlined,
                                                size: 28,
                                                color: accentColor,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Upload",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: accentColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                ),
                                // Camera badge
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.defaultWhite,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(20),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 14,
                                      color: AppColors.defaultWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ── Pet Name Input ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: namaController,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.netral,
                            ),
                            decoration: InputDecoration(
                              labelText: "Nama Pet",
                              labelStyle: TextStyle(
                                color: AppColors.netral.withAlpha(140),
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: "Masukkan nama hewan peliharaanmu",
                              hintStyle: TextStyle(
                                color: AppColors.netral.withAlpha(80),
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: accentColor,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundItem.withAlpha(120),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: AppColors.netral.withAlpha(25),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: accentColor.withAlpha(150),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ── Jenis Hewan Section ──
                        _buildSectionHeader(
                          icon: Icons.category_rounded,
                          label: "Jenis Hewan",
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: PetData.jenisHewan.map((jenis) {
                              final bool isSelected = selectedJenis == jenis;
                              final bool isKucing =
                                  jenis.toLowerCase() == 'kucing';
                              final Color chipColor = isKucing
                                  ? AppColors.teritary
                                  : AppColors.primary;
                              final Color chipTextColor = isKucing
                                  ? AppColors.teritary2
                                  : AppColors.netral2;
                              final IconData chipIcon = isKucing
                                  ? Icons.cruelty_free_rounded
                                  : Icons.pets_rounded;

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: isKucing ? 6 : 0,
                                    left: isKucing ? 0 : 6,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedJenis = jenis;
                                        // reset ras ketika jenis berubah
                                        selectedRas = null;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? chipColor.withAlpha(70)
                                            : AppColors.backgroundItem
                                                .withAlpha(100),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? chipColor.withAlpha(180)
                                              : AppColors.netral.withAlpha(20),
                                          width: isSelected ? 1.8 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color:
                                                      chipColor.withAlpha(30),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            chipIcon,
                                            size: 26,
                                            color: isSelected
                                                ? chipTextColor
                                                : AppColors.netral
                                                    .withAlpha(100),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            jenis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? chipTextColor
                                                  : AppColors.netral
                                                      .withAlpha(140),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // ── Ras Hewan Section ──
                        if (selectedJenis != null) ...[
                          const SizedBox(height: 22),
                          _buildSectionHeader(
                            icon: Icons.pets_rounded,
                            label: "Ras Hewan",
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 10,
                              children:
                                  PetData.petBreeds[selectedJenis]!.map((ras) {
                                final bool isSelected = selectedRas == ras;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedRas = ras;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? accentBg
                                          : AppColors.backgroundItem
                                              .withAlpha(100),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? accentColor.withAlpha(150)
                                            : AppColors.netral.withAlpha(20),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected) ...[
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 16,
                                            color: accentColor,
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Text(
                                          ras,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? accentColor
                                                : AppColors.netral
                                                    .withAlpha(160),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],

                        const SizedBox(height: 22),

                        // ── Umur Section ──
                        _buildSectionHeader(
                          icon: Icons.cake_rounded,
                          label: "Umur",
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: PetData.umurPet.asMap().entries.map((entry) {
                              final int idx = entry.key;
                              final Map<String, String> umur = entry.value;
                              final bool isSelected =
                                  selectedUmur == umur["label"];
                              final List<IconData> umurIcons = [
                                Icons.child_care_rounded,
                                Icons.self_improvement_rounded,
                                Icons.elderly_rounded,
                              ];

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: idx == 0 ? 0 : 4,
                                    right: idx == PetData.umurPet.length - 1
                                        ? 0
                                        : 4,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedUmur = umur["label"];
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? accentBg
                                            : AppColors.backgroundItem
                                                .withAlpha(100),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? accentColor.withAlpha(150)
                                              : AppColors.netral.withAlpha(20),
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: accentColor
                                                      .withAlpha(20),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            umurIcons[idx],
                                            size: 22,
                                            color: isSelected
                                                ? accentColor
                                                : AppColors.netral
                                                    .withAlpha(100),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            umur["label"]!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? accentColor
                                                  : AppColors.netral
                                                      .withAlpha(160),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            umur["desc"]!,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isSelected
                                                  ? accentColor.withAlpha(180)
                                                  : AppColors.netral
                                                      .withAlpha(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Action Buttons ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Save Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.teksButton,
                                    elevation: 3,
                                    shadowColor: AppColors.primary.withAlpha(80),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (namaController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "Nama pet tidak boleh kosong",
                                          ),
                                          backgroundColor: Colors.red.shade400,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: const EdgeInsets.all(16),
                                        ),
                                      );
                                      return;
                                    }

                                    String? finalImagePath = pets.gambarPet;
                                    if (selectedPetImage != null &&
                                        selectedPetImage!.path !=
                                            pets.gambarPet) {
                                      final permanentFile =
                                          await ImagePickerService
                                              .saveImagePermanently(
                                                selectedPetImage!,
                                                "pet",
                                              );
                                      finalImagePath = permanentFile.path;
                                    }

                                    if (isEdit) {
                                      final email =
                                          await PreferenceHandler.getEmail();
                                      await DBHelper().updatePet(
                                        PetModel(
                                          id: pets.id,
                                          nama: namaController.text,
                                          jenis: selectedJenis ?? "",
                                          umur: selectedUmur ?? "",
                                          ownerEmail: email,
                                          ras: selectedRas ?? "",
                                          gambarPet: finalImagePath,
                                        ),
                                      );
                                    } else {
                                      final email =
                                          await PreferenceHandler.getEmail();
                                      await DBHelper().insertPet(
                                        PetModel(
                                          nama: namaController.text,
                                          jenis: selectedJenis ?? "",
                                          umur: selectedUmur ?? "",
                                          ownerEmail: email,
                                          ras: selectedRas ?? "",
                                          gambarPet: finalImagePath,
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: AppColors.teksButton,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isEdit
                                            ? "Simpan Perubahan"
                                            : "Simpan Pet Profile",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.teksButton,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Delete Button (only for edit)
                              if (isEdit) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          AppColors.logoutText,
                                      side: BorderSide(
                                        color: AppColors.logoutText
                                            .withAlpha(80),
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      backgroundColor:
                                          AppColors.logout.withAlpha(60),
                                    ),
                                    onPressed: () async {
                                      // Show confirmation dialog
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .warning_amber_rounded,
                                                color:
                                                    AppColors.logoutText,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text("Hapus Pet?"),
                                            ],
                                          ),
                                          content: Text(
                                            "Apakah kamu yakin ingin menghapus ${pets.nama}? Data tidak dapat dikembalikan.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      ctx, false),
                                              child: Text(
                                                "Batal",
                                                style: TextStyle(
                                                  color: AppColors.netral,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.logoutText,
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      ctx, true),
                                              child: const Text(
                                                "Hapus",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await DBHelper()
                                            .deletePet(pets.id!);
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                          color: AppColors.logoutText,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Hapus Pet Profile",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.logoutText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Helper widget to build consistent section headers with icon and label
  Widget _buildSectionHeader({
    required IconData icon,
    required String label,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.netral,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  final List<String> _carouselImages = [
    "assets/images/carousel1.png",
    "assets/images/carousel2.png",
  ];

  final List<String> _bannerTitles = [
    "Edukasi Sobat Bulu",
    "Promo Makanan Kucing",
  ];

  final List<String> _bannerSubtitles = [
    "Pelajari tips merawat hewan peliharaan agar selalu sehat.",
    "Dapatkan diskon hingga 20% untuk makanan kucing premium.",
  ];

  final List<Color> _placeholderGradientsStart = [
    const Color(0xFFaec6cf), // primary pastel blue
    const Color(0xFFffdab9), // peach
  ];

  final List<Color> _placeholderGradientsEnd = [
    const Color(0xFF7A9FA9),
    const Color(0xFFE4A26F),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentIndex < _carouselImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(
            height: 140, // Elegant height for banner
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _carouselImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _carouselImages[index],
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            // Beautiful pastel gradient placeholder if the image file is not found
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _placeholderGradientsStart[index],
                                    _placeholderGradientsEnd[index],
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(50),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            "Info Bulu",
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _bannerTitles[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _bannerSubtitles[index],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      index == 0
                                          ? Icons.library_books_rounded
                                          : Icons.local_offer_rounded,
                                      size: 40,
                                      color: Colors.white.withAlpha(140),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _carouselImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentIndex == index ? 16 : 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.primary
                      : AppColors.netral.withAlpha(30),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}