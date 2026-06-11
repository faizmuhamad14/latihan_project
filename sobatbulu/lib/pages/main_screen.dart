import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/pages/home.dart';
import 'package:sobatbulu_app/pages/information.dart';
import 'package:sobatbulu_app/pages/produk_page.dart';
import 'package:sobatbulu_app/pages/profile.dart';

class MainScreenSatu extends StatefulWidget {
  final String nama;
  final String email;
  const MainScreenSatu({super.key, required this.nama, required this.email});

  @override
  State<MainScreenSatu> createState() => _MainScreenSatuState();
}

class _MainScreenSatuState extends State<MainScreenSatu> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    HomePageScreen(nama: widget.nama),
    ProdukPage(),
    InformationPage(),
    ProfilePage(nama: widget.nama, email: widget.email),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_sharp),
            label: "Product",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_rounded),
            label: "Information",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.bottomNav,
        backgroundColor: AppColors.backgroundItem,
      ),
    );
  }
}
