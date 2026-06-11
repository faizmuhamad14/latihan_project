import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/pages/information.dart';
import 'package:sobatbulu_app/pages/location.dart';

class InformationKedua extends StatefulWidget {
  const InformationKedua({super.key});

  @override
  State<InformationKedua> createState() => _InformationKeduaState();
}

class _InformationKeduaState extends State<InformationKedua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF647B83),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationPage()),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 26),
                    Text(
                      "Informasi & Fakta Seru",
                      style: AppTextStyle.informasiPage,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8F715B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationPage()),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.location_on_outlined, size: 26),
                    Text(
                      "Lokasi Vet & Petshop Terdekat",
                      style: AppTextStyle.informasiPage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
