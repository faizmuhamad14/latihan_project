import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/database/db_helper.dart';
import 'package:sobatbulu_app/database/preference.dart';
import 'package:sobatbulu_app/models/pet_model.dart';

class HomePageScreen extends StatefulWidget {
  final String nama;
  const HomePageScreen({super.key, required this.nama});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
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
                                SizedBox(height: 100),
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
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 26,
                          ),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 15,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                            "assets/images/kucing.jpg",
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            pet.nama,
                                            style: TextStyle(
                                              color: AppColors.netral,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            ("${pet.jenis} • ${pet.ras}"),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.textcard,
                                            ),
                                          ),
                                          Text(
                                            pet.umur,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.textcard,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.notification_add_outlined,
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
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await DBHelper().toggleFeed(pet);
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: pet.isFed == 1
                                              ? AppColors.isFed2
                                              : AppColors.isFed,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.restaurant),
                                            Text(
                                              pet.isFed == 1
                                                  ? "✓ Sudah Makan"
                                                  : "Sudah Makan",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await DBHelper().toggleDrink(pet);
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: pet.isDrink == 1
                                              ? AppColors.isDrink
                                              : AppColors.isFed,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.restaurant),
                                            Text(
                                              pet.isDrink == 1
                                                  ? "✓ Sudah Minum"
                                                  : "Sudah Minum",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
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
                  onTap: () => _showBottomSheet(
                    context,
                    PetModel(
                      nama: '',
                      jenis: '',
                      umur: '',
                      ownerEmail: '',
                      ras: '',
                    ),
                  ),
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
                      spacing: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Icon(Icons.add, size: 50),
                        ),
                        Text("Tambahkan Pet Baru", style: AppTextStyle.addPet),
                        Text("Tambahkan hewan peliharaan baru."),
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
                                  selectedColor: AppColors.chip,
                                  label: Text(jenis),

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
                                selectedColor: AppColors.chip,
                                label: Text(ras),

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
                              selectedColor: AppColors.chip,
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
