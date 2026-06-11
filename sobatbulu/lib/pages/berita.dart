import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/models/info_model.dart';

class BeritaPage extends StatelessWidget {
  final InfoModel infoBerita;
  const BeritaPage({super.key, required this.infoBerita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(infoBerita.title, style: AppTextStyle.produkTitle),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.asset(infoBerita.gambar),
              ),
              Text(infoBerita.deskripsi, style: AppTextStyle.subProduk),
            ],
          ),
        ),
      ),
    );
  }
}
