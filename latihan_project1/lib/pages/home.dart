import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/database/db_helper.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/models/pet_model.dart';
import 'package:latihan_project1/pages/sign_in.dart';

class HomePageScreen extends StatefulWidget {
  final String nama;
  const HomePageScreen({super.key, required this.nama});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
  final _formKey = GlobalKey<FormState>();
  void isLogout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
      (route) => false,
    );
  }

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
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(children: [Text("Halo, ${widget.nama}")]),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Container(child: Icon(Icons.add)),
              Text("Add New Pet"),
            ],
          ),
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
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(pet.nama),
                        subtitle: Text('Password: ${pet.nama}'),
                        trailing: IconButton(
                          onPressed: () => _showBottomSheet(context, pet),
                          icon: Icon(Icons.edit_document),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  isLogout();
                },
                child: Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, PetModel pet) {
    final namaController = TextEditingController(text: pet.nama);
    final jenisController = TextEditingController(text: pet.jenis);

    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsetsGeometry.all(5),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Add New Pet"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Pet Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: jenisController,
                  decoration: const InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(),
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.check_circle_outline_rounded),
                      label: Text("Save Pet Profile"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.check_circle_outline_rounded),
                      label: Text(""),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
