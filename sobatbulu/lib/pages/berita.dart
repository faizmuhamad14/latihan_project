import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/models/info_model.dart';
import 'package:sobatbulu_app/models/image_picker.dart';

class BeritaPage extends StatefulWidget {
  final InfoModel infoBerita;
  const BeritaPage({super.key, required this.infoBerita});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late InfoModel _currentArticle;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.infoBerita;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            spacing: 15,
            children: [
              Text(_currentArticle.title, style: AppTextStyle.produkTitle),
              SizedBox(
                width: double.infinity,
                height: 290,
                child: ImagePickerService.buildImage(
                  _currentArticle.gambar,
                  fit: BoxFit.cover,
                ),
              ),
              Text(_currentArticle.deskripsi, style: AppTextStyle.subProduk),
            ],
          ),
        ),
      ),
    );
  }
}
