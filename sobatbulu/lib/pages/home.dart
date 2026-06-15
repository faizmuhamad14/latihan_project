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
                                SizedBox(height: 150),
                                Center(
                                  child: Lottie.asset(
                                    "assets/lottie/addPet.json",
                                    width: 300,
                                    height: 300,
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
              SizedBox(height: 15),
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
                      itemCount: daftarPengguna.length,
                      itemBuilder: (context, index) {
                        final pet = daftarPengguna[index];
                        return Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            decoration: BoxDecoration(
                              color: Color(0xffE8F2FF),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 15,
                                  offset: Offset(3, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 20,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.defaultWhite,
                                      radius: 40,
                                      backgroundImage: pet.gambarPet != null
                                          ? FileImage(File(pet.gambarPet!))
                                          : null,

                                      child: pet.gambarPet == null
                                          ? const Icon(
                                              Icons.pets,
                                              size: 30,
                                              color: AppColors.defaultBlack,
                                            )
                                          : null,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet.nama,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,

                                            color: Color(0xff2C3E50),
                                          ),
                                        ),
                                        Text(
                                          "${pet.jenis} • ${pet.umur}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          pet.ras,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.secondary2,
                                      ),
                                      icon: Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.defaultWhite,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _showBottomSheet(context, pet);
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.netral2,
                                      ),
                                      icon: Icon(
                                        Icons.edit_document,
                                        color: AppColors.defaultWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
      backgroundColor: AppColors.backgroundBttn,

      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),

              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(
                          isEdit ? "Edit Pet" : "Add New Pet",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            labelText: "Pet Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
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

                            child: CircleAvatar(
                              backgroundColor: AppColors.defaultWhite,
                              radius: 50,
                              backgroundImage: selectedPetImage != null
                                  ? FileImage(selectedPetImage!)
                                  : null,

                              child: selectedPetImage == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: AppColors.defaultBlack,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Jenis Hewan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 5),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: PetData.jenisHewan.map((jenis) {
                                return ChoiceChip(
                                  selectedColor: AppColors.primary,
                                  label: Text(jenis),
                                  backgroundColor: AppColors.defaultWhite,
                                  selected: selectedJenis == jenis,

                                  onSelected: (value) {
                                    setModalState(() {
                                      selectedJenis = jenis;

                                      // reset ras ketika jenis berubah
                                      selectedRas = null;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        if (selectedJenis != null) ...[
                          SizedBox(height: 10),

                          Text(
                            "Ras Hewan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 5),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: PetData.petBreeds[selectedJenis]!.map((
                              ras,
                            ) {
                              return ChoiceChip(
                                selectedColor: AppColors.primary,
                                label: Text(ras),
                                backgroundColor: AppColors.defaultWhite,
                                selected: selectedRas == ras,

                                onSelected: (value) {
                                  setModalState(() {
                                    selectedRas = ras;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                        SizedBox(height: 10),

                        Text(
                          "Umur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 5),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: PetData.umurPet.map((umur) {
                            return ChoiceChip(
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.defaultWhite,
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    umur["label"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    umur["desc"]!,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                              selected: selectedUmur == umur["label"],
                              onSelected: (value) {
                                setModalState(() {
                                  selectedUmur = umur["label"];
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        Column(
                          spacing: 8,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () async {
                                if (namaController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Pet named cannot be empty",
                                      ),
                                    ),
                                  );
                                  return;
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
                                      isFed: pets.isFed,
                                      isDrink: pets.isDrink,
                                      ras: selectedRas ?? "",
                                      gambarPet: selectedPetImage?.path,
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
                                      gambarPet: selectedPetImage?.path,
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppColors.teksButton,
                              ),
                              label: Text(
                                "Save Pet Profile",
                                style: TextStyle(color: AppColors.teksButton),
                              ),
                            ),
                            if (isEdit)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                onPressed: () async {
                                  await DBHelper().deletePet(pets.id!);

                                  Navigator.pop(context);

                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.teksButton,
                                ),
                                label: const Text(
                                  "Delete Pet Profile",
                                  style: TextStyle(color: AppColors.teksButton),
                                ),
                              ),
                          ],
                        ),
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
}
