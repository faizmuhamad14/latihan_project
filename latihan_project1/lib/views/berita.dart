import 'package:flutter/material.dart';
import 'package:latihan_project1/models/info_model.dart';

class BeritaPage extends StatelessWidget {
  final InfoModel infoBerita;
  const BeritaPage({super.key, required this.infoBerita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: Column(children: [Text("")])),
    );
  }
}
