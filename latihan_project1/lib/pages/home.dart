import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/database/db_helper.dart';
import 'package:latihan_project1/models/pet_model.dart';

class HomePageScreen extends StatefulWidget {
  final String nama;
  const HomePageScreen({super.key, required this.nama});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
  String? selectedJenis;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sobat Bulu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textBttn,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.pets, color: AppColors.textBttn),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        ],
      ),
      body: FutureBuilder<List<PetModel>>(
        future: DBHelper().getAllPet(),
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
                        "Halo, ${widget.nama}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.netral,
                        ),
                      ),
                      Text(
                        pets.isEmpty
                            ? "You haven't added any pets yet."
                            : "Here is how your companions are doing today",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: FutureBuilder<List<PetModel>>(
                  future: DBHelper().getAllPet(),
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
                        return Card(
                          elevation: 5,
                          color: Color(0xFFFFFFFF),
                          shadowColor: Colors.black,
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.pets, color: AppColors.netral),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pet.nama,
                                  style: TextStyle(
                                    color: AppColors.netral,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showBottomSheet(
                                      context,
                                      pet,
                                      // PetModel(
                                      //   nama: pet.nama,
                                      //   jenis: pet.jenis,
                                      // ),
                                    );
                                  },
                                  icon: Icon(Icons.edit_document),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  "Type : ${pet.jenis}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textcard,
                                  ),
                                ),
                                Text(
                                  "Pet Number : ${index + 1}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            // Text('Nama Pet: ${pet.nama}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () =>
                      _showBottomSheet(context, PetModel(nama: '', jenis: '')),
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 152,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Icon(Icons.add, size: 50),
                        ),
                        Text("Add New Pet"),
                        Text("Bring another companion into your care."),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, PetModel pets) {
    String? selectedJenis = pets.jenis.isNotEmpty ? pets.jenis : null;
    final isEdit = pets.id != null;
    final namaController = TextEditingController(text: pets.nama);
    final jenisController = TextEditingController(text: pets.jenis);

    Widget buildPetChip({
      required String emoji,
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return ChoiceChip(
        selected: selected,
        onSelected: (_) => onTap(),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),

            const SizedBox(height: 8),

            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    showModalBottomSheet(
      backgroundColor: AppColors.backgroundBttn,
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsetsGeometry.fromLTRB(10, 7, 10, 7),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 2,
                  children: [
                    Text(
                      isEdit ? "Edit Pet" : "Add New Pet",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: "Pet Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: const Text(
                            "Pet Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              buildPetChip(
                                emoji: "🐱",
                                label: "Kucing",
                                selected: selectedJenis == "Kucing",
                                onTap: () {
                                  setModalState(() {
                                    selectedJenis = "Kucing";
                                  });
                                },
                              ),

                              buildPetChip(
                                emoji: "🐶",
                                label: "Anjing",
                                selected: selectedJenis == "Anjing",
                                onTap: () {
                                  setModalState(() {
                                    selectedJenis = "Anjing";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (namaController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pet named cannot be empty"),
                                ),
                              );
                              return;
                            }

                            if (isEdit) {
                              await DBHelper().updatePet(
                                PetModel(
                                  id: pets.id,
                                  nama: namaController.text,
                                  jenis: selectedJenis ?? "",
                                ),
                              );
                            } else {
                              await DBHelper().insertPet(
                                PetModel(
                                  nama: namaController.text,
                                  jenis: jenisController.text,
                                ),
                              );
                            }
                            Navigator.pop(context);
                            setState(() {});
                          },
                          icon: Icon(Icons.check_circle_outline_rounded),
                          label: Text("Save Pet Profile"),
                        ),
                        if (isEdit)
                          ElevatedButton.icon(
                            onPressed: () async {
                              await DBHelper().deletePet(pets.id!);

                              Navigator.pop(context);

                              setState(() {});
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete Pet Profile"),
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
    );
  }
}
