import 'package:flutter/material.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/project/sign_in.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void isLogout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
      (route) => false,
    );
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[MainScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(child: Text("data")),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Home"),

              onTap: () {
                isLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
