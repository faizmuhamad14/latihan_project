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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 28, 16, 10),
        child: Container(
          color: AppColors.defaultWhite,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: widget.pet.gambarPet != null
                    ? Image.file(
                        File(widget.pet.gambarPet!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.pets, size: 100),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Informasi"),
                  TextButton(
                    onPressed: _showEditDetailPet,
                    child: Text("Edit"),
                  ),
                ],
              ),
              Column(
                spacing: 20,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Nama"), Text(widget.pet.nama)],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Jenis"), Text(widget.pet.jenis)],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Umur"), Text(widget.pet.umur)],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Ras"), Text(widget.pet.ras)],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Gender"),
                            Text(
                              widget.pet.gender == null
                                  ? "-"
                                  : "${widget.pet.gender}",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Berat"),
                            Text(
                              widget.pet.berat == null
                                  ? "-"
                                  : "${widget.pet.berat}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tanggal Lahir"),
                            Text(
                              widget.pet.tanggalLahir == null
                                  ? "-"
                                  : "${widget.pet.tanggalLahir}",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tanggal Adop"),
                            Text(
                              widget.pet.tanggalAdop == null
                                  ? "-"
                                  : "${widget.pet.tanggalAdop}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
