import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/text_style.dart';
import 'package:latihan_project1/models/model_data.dart';

class DetailProduk extends StatelessWidget {
  final ProdukPetshop produk;
  const DetailProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16),
                child: Image.asset(
                  produk.gambar,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(
                produk.nama,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Column(
                children: [
                  Text("Rate", style: AppTextStyle.produkTitle),
                  Text("${produk.rate}", style: AppTextStyle.subProduk),
                ],
              ),
              Column(
                children: [
                  Text("Kisaran Harga", style: AppTextStyle.produkTitle),
                  Text("${produk.harga}", style: AppTextStyle.subProduk),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Kategori", style: AppTextStyle.produkTitle),
                  Text(produk.kategori, style: AppTextStyle.subProduk),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Rekomendasi Jenis Hewan",
                    style: AppTextStyle.produkTitle,
                  ),
                  Wrap(
                    children: produk.jenisHewan.map((jenis) {
                      return Chip(
                        label: Text(jenis, style: AppTextStyle.subProduk),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Rekomendasi Ras Hewan",
                    style: AppTextStyle.produkTitle,
                  ),
                  Wrap(
                    spacing: 5,
                    children: produk.ras.map((ras) {
                      return Chip(
                        label: Text(ras, style: AppTextStyle.subProduk),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Rekomendasi Umur Hewan",
                    style: AppTextStyle.produkTitle,
                  ),
                  Wrap(
                    children: produk.umur.map((umur) {
                      return Chip(
                        label: Text(umur, style: AppTextStyle.subProduk),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
