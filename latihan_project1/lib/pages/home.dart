import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/database/db_helper.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/models/user_model.dart';
import 'package:latihan_project1/pages/sign_in.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePageScreen> {
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
          Expanded(
            child: FutureBuilder<List<UserModelSQL>>(
              future: DBHelper().getAllUsers(),
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
                  return const Center(child: Text('Tidak ada data pengguna.'));
                }

                final daftarPengguna = snapshot.data!;

                return ListView.builder(
                  itemCount: daftarPengguna.length,
                  itemBuilder: (context, index) {
                    final user = daftarPengguna[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(user.email),
                        subtitle: Text('Password: ${user.password}'),
                        trailing: IconButton(
                          onPressed: () => _showBottomSheet(context, user),
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

  void _showBottomSheet(BuildContext context, UserModelSQL user) {
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: user.password);
    final kotaController = TextEditingController(text: user.kota);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ), // RoundedRectangleBorder
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ), // EdgeInsets.only
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Kelola Pengguna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ), // Text
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ), // InputDecoration
              ), // TextField
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ), // InputDecoration
              ), // TextField
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ), // Text
                    onPressed: () async {
                      final updatedUser = UserModelSQL(
                        nama: user.nama,
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        kota: kotaController.text,
                      ); // UserModelSQL

                      bool success = await DBHelper().updateUser(updatedUser);
                      if (success && context.mounted) {
                        Navigator.pop(context);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil diperbarui'),
                          ), // SnackBar
                        );
                      }
                    },
                  ), // ElevatedButton.icon
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ), // Text
                    onPressed: () async {
                      await DBHelper().deleteUser(user.email);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil dihapus'),
                          ), // SnackBar
                        );
                      }
                    },
                  ), // ElevatedButton.icon
                ],
              ), // Row
              const SizedBox(height: 20),
            ],
          ), // Column
        ); // Padding
      },
    );
  }
}
