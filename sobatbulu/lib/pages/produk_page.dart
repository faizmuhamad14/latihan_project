import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/data/list_data_map.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/pages/detail_produk.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String? selectedJenis;
  String? selectedRas;
  String? selectedUmur;
  String selectedCategory = "Semua";
  final categories = [
    "Semua",
    "Makanan Kucing",
    "Makanan Anjing",
    "Perawatan",
    "Aksesoris",
    "Kesehatan",
    "Mainan",
    "Kandang",
  ];
  List<ProdukPetshop> get filteredProducts {
    return produkPetshop.where((product) {
      final matchCategory =
          selectedCategory == "Semua" || product.kategori == selectedCategory;

      final matchJenis =
          selectedJenis == null || product.jenisHewan.contains(selectedJenis);

      final matchUmur =
          selectedUmur == null || product.umur.contains(selectedUmur);

      return matchCategory && matchJenis && matchUmur;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      showFilterBottomSheet();
                    },
                    icon: Icon(Icons.filter_alt_rounded),
                  ),
                  Container(
                    width: 332,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(5, 20, 5, 5),
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
                ],
              ),
            ),
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
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (value) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Produk Makanan"),
                        Text("${filteredProducts.length} Hasil"),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.52,
                          ),
                      itemBuilder: (context, index) {
                        final data = filteredProducts[index];
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
                                      borderRadius: BorderRadius.circular(8),
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProduk(produk: data),
                                            ),
                                          );
                                        },
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColors.defaultWhite,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Produk",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // JENIS HEWAN
                  const Text(
                    "Jenis Hewan",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: PetData.jenisHewan.map((jenis) {
                      return ChoiceChip(
                        label: Text(jenis),
                        selected: selectedJenis == jenis,
                        onSelected: (value) {
                          setModalState(() {
                            selectedJenis = jenis;
                            selectedRas = null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),
                  if (selectedJenis != null) ...[
                    // const SizedBox(height: 20),
                    const Text(
                      "Ras Hewan",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      children: PetData.petBreeds[selectedJenis]!.map((ras) {
                        return ChoiceChip(
                          label: Text(ras),

                          selected: selectedRas == ras,

                          onSelected: (value) {
                            setModalState(() {
                              selectedRas = ras;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  // UMUR
                  const Text(
                    "Umur",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: PetData.umurPet.map((umur) {
                      return ChoiceChip(
                        label: Text(umur["label"]!),
                        selected: selectedUmur == umur["label"],
                        onSelected: (value) {
                          setModalState(() {
                            selectedUmur = umur["label"];
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.filter,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedJenis = null;
                              selectedUmur = null;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: AppColors.defaultBlack),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.filter,
                          ),
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Terapkan",
                            style: TextStyle(color: AppColors.defaultBlack),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
