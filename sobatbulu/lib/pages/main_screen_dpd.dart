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
          item: ItemConfig(icon: Icon(Icons.home), title: "Beranda"),
        ),
        PersistentTabConfig(
          screen: ProdukPage(),
          item: ItemConfig(
            icon: Icon(Icons.shopping_bag_rounded),
            title: "Produk",
          ),
        ),
        PersistentTabConfig(
          screen: InformationKedua(),
          item: ItemConfig(
            icon: Icon(Icons.medical_information_rounded),
            title: "Informasi",
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(nama: widget.nama, email: widget.email),
          item: ItemConfig(icon: Icon(Icons.person_2_rounded), title: "Profil"),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style9BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(),
      ),
    );
  }
}
