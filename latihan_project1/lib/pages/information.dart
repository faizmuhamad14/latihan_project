import 'package:flutter/material.dart';
import 'package:latihan_project1/views/berita.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Information"),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeritaPage(),
                            ),
                          ),
                          child: Container(
                            child: Text(
                              "Paws & Play: Fakta Unik & Trik Cerdas Seputar Anabul Kesayanganmu!",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
