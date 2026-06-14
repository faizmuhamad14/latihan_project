import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/data/list_model_berita.dart';
import 'package:sobatbulu_app/models/info_model.dart';
import 'package:sobatbulu_app/pages/berita.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String selectedKategori = "Semua";
  final categories = ["Semua", "Artikel", "FunFact"];
  List<InfoModel> get filteredBerita {
    return infoBerita.where((berita) {
      final matchCategory =
          selectedKategori == "Semua" || berita.kategori == selectedKategori;

      return matchCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(backgroundColor: Color(0xFFFFFFFF), elevation: 0),
      body: Container(
        margin: EdgeInsets.only(top: 1),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: EdgeInsetsGeometry.all(5),
                      child: ChoiceChip(
                        selectedColor: AppColors.teritary2,
                        backgroundColor: Colors.white,
                        label: Text(
                          category,
                          style: TextStyle(color: AppColors.netral),
                        ),
                        selected: selectedKategori == category,
                        onSelected: (value) {
                          setState(() {
                            selectedKategori = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: AppColors.teritary,
              ),
              child: Center(
                child: Text(
                  "Informasi & Fakta Seru!",
                  style: AppTextStyle.informasiPage,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 14),
                shrinkWrap: true,
                itemCount: filteredBerita.length,
                itemBuilder: (context, index) {
                  final info = filteredBerita[index];
                  return ListTile(
                    title: Text(info.title, style: AppTextStyle.subProduk),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeritaPage(infoBerita: info),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
