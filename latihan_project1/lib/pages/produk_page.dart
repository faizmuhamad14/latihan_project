import 'package:flutter/material.dart';
import 'package:latihan_project1/constant/app_color.dart';
import 'package:latihan_project1/data/list_data_map.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 24, 10, 15),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Royal Canin",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 10, 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Semua"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Makanan"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Kebersihan"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Obat"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Mainan"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Pakaian"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text("Kandang"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Produk Makanan"), Text("10 Hasil")],
                    ),
                  ),
                  SizedBox(height: 5),
                  GridView.builder(
                    padding: EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: produkPetshop.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.55,
                        ),
                    itemBuilder: (context, index) {
                      final data = produkPetshop[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.item),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                data.gambar,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              spacing: 5,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(data.kategori),
                                ),
                                Text(data.nama),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.altTeritary,
                                    ),
                                    Text("${data.rate}"),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Column(
                                  spacing: 8,
                                  children: [
                                    Text("${data.harga}"),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.backgroundBttn,
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Lihat Detail",
                                        style: TextStyle(
                                          color: AppColors.textBttn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
