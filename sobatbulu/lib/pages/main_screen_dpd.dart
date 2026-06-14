import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sobatbulu_app/pages/home.dart';
import 'package:sobatbulu_app/pages/information2.dart';
import 'package:sobatbulu_app/pages/produk_page.dart';
import 'package:sobatbulu_app/pages/profile.dart';

class MainScreenDpd extends StatefulWidget {
  final String nama;
  final String email;
  const MainScreenDpd({super.key, required this.nama, required this.email});

  @override
  State<MainScreenDpd> createState() => _MainScreenDpd();
}

class _MainScreenDpd extends State<MainScreenDpd> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomePageScreen(nama: widget.nama),
          item: ItemConfig(
            textStyle: TextStyle(fontSize: 16),
            icon: Icon(Icons.home, size: 28),
            title: "Beranda",
            activeForegroundColor: Color(0xFF7D949D),
          ),
        ),
        PersistentTabConfig(
          screen: ProdukPage(),
          item: ItemConfig(
            textStyle: TextStyle(fontSize: 16),
            icon: Icon(Icons.shopping_bag_rounded, size: 28),
            title: "Produk",
            activeForegroundColor: Color(0xFF7D949D),
          ),
        ),
        PersistentTabConfig(
          screen: InformationKedua(),
          item: ItemConfig(
            textStyle: TextStyle(fontSize: 16),
            icon: Icon(Icons.medical_information_rounded, size: 28),
            title: "Informasi",
            activeForegroundColor: Color(0xFF7D949D),
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(nama: widget.nama, email: widget.email),
          item: ItemConfig(
            textStyle: TextStyle(fontSize: 16),
            icon: Icon(Icons.person_2_rounded, size: 28),
            title: "Profil",
            activeForegroundColor: Color(0xFF7D949D),
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(),
      ),
    );
  }
}
