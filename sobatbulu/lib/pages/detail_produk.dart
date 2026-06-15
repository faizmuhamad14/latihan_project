import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/models/rupiah.dart';

class DetailProduk extends StatelessWidget {
  final ProdukPetshop produk;
  const DetailProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text("Detail Produk"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 26, 15, 10),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 15,
                      offset: Offset(3, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  child: Image.asset(
                    produk.gambar,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(16, 6, 16, 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 15,
                      offset: Offset(3, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    produk.nama,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(16, 6, 16, 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 15,
                      offset: Offset(3, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rate", style: AppTextStyle.produkTitle),
                        Text(
                          "${produk.rate}/5.0",
                          style: AppTextStyle.subProduk,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kisaran Harga", style: AppTextStyle.produkTitle),
                        Text(
                          CurrencyHelper.format(produk.harga),
                          style: AppTextStyle.subProduk,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kategori", style: AppTextStyle.produkTitle),
                        Text(produk.kategori, style: AppTextStyle.subProduk),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rekomendasi Jenis Hewan",
                          style: AppTextStyle.produkTitle,
                        ),
                        Wrap(
                          spacing: 5,
                          children: produk.jenisHewan.map((jenis) {
                            return Chip(
                              backgroundColor: AppColors.secondary,
                              label: Text(jenis, style: AppTextStyle.subProduk),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rekomendasi Ras Hewan",
                          style: AppTextStyle.produkTitle,
                        ),
                        Wrap(
                          spacing: 5,
                          children: produk.ras.map((ras) {
                            return Chip(
                              backgroundColor: AppColors.secondary,
                              label: Text(ras, style: AppTextStyle.subProduk),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rekomendasi Umur Hewan",
                          style: AppTextStyle.produkTitle,
                        ),
                        Wrap(
                          spacing: 5,
                          children: produk.umur.map((umur) {
                            return Chip(
                              backgroundColor: AppColors.secondary,
                              label: Text(umur, style: AppTextStyle.subProduk),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Deskripsi", style: AppTextStyle.produkTitle),
                        Text(
                          produk.deskripsi,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.subProduk,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
