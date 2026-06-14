import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/models/info_model.dart';

class BeritaPage extends StatelessWidget {
  final InfoModel infoBerita;
  const BeritaPage({super.key, required this.infoBerita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultWhite,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            spacing: 15,
            children: [
              Text(infoBerita.title, style: AppTextStyle.produkTitle),
              SizedBox(
                width: double.infinity,
                height: 290,
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
