import 'package:flutter/material.dart';
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
          margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Column(children: [Text("Rate"), Text("${produk.rate}")]),
              Column(children: [Text("Harga"), Text("${produk.harga}")]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Kategori"), Text(produk.kategori)],
              ),
              Column(
                children: [
                  Text("Rekomendasi Jenis Hewan"),
                  Wrap(
                    children: produk.jenisHewan.map((jenis) {
                      return Chip(label: Text(jenis));
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Rekomendasi Ras Hewan"),
                  Wrap(
                    children: produk.ras.map((ras) {
                      return Chip(label: Text(ras));
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Rekomendasi Umur Hewan"),
                  Wrap(
                    children: produk.umur.map((umur) {
                      return Chip(label: Text(umur));
                    }).toList(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Deskripsi"),
                  Text(produk.deskripsi, textAlign: TextAlign.left),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
