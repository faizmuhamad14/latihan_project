import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/data/list_data_map.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/models/rupiah.dart';
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
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showFilterBottomSheet();
                    },
                    icon: const Icon(Icons.filter_alt_rounded),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(5, 20, 15, 5),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Royal Canin",
                          fillColor: const Color(0xffffffff),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 5),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.all(5),
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
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Produk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${filteredProducts.length} Hasil",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double screenWidth = MediaQuery.of(
                          context,
                        ).size.width;

                        // Determine crossAxisCount based on screen width
                        int crossAxisCount = 2;
                        if (screenWidth > 1200) {
                          crossAxisCount = 5;
                        } else if (screenWidth > 900) {
                          crossAxisCount = 4;
                        } else if (screenWidth > 600) {
                          crossAxisCount = 3;
                        }

                        // Calculate width and childAspectRatio dynamically to maintain card height
                        final double horizontalSpacing = 32.0;
                        final double crossAxisSpacing = 8.0;
                        final double itemWidth =
                            (screenWidth -
                                horizontalSpacing -
                                (crossAxisCount - 1) * crossAxisSpacing) /
                            crossAxisCount;

                        // We target a stable card height of 340px
                        final double itemHeight = 340.0;
                        final double childAspectRatio = itemWidth / itemHeight;

                        return GridView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: crossAxisSpacing,
                                mainAxisSpacing: 12,
                                childAspectRatio: childAspectRatio,
                              ),
                          itemBuilder: (context, index) {
                            final data = filteredProducts[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppColors.item),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(5),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.asset(
                                      data.gambar,
                                      width: double.infinity,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                              8,
                                              4,
                                              8,
                                              4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              data.kategori,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 38,
                                            child: Text(
                                              data.nama,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: AppColors.altTeritary,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${data.rate}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                CurrencyHelper.format(
                                                  data.harga,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.defaultBlack,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 36,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors
                                                        .backgroundBttn,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailProduk(
                                                              produk: data,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Lihat Detail",
                                                    style: TextStyle(
                                                      color: AppColors.textBttn,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter Produk",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jenis Hewan",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: PetData.jenisHewan.map((jenis) {
                                return ChoiceChip(
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.defaultWhite,
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

                            if (selectedJenis != null) ...[
                              const SizedBox(height: 15),
                              const Text(
                                "Ras Hewan",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: PetData.petBreeds[selectedJenis]!.map(
                                  (ras) {
                                    return ChoiceChip(
                                      selectedColor: AppColors.primary,
                                      label: Text(ras),
                                      backgroundColor: AppColors.defaultWhite,
                                      selected: selectedRas == ras,
                                      onSelected: (value) {
                                        setModalState(() {
                                          selectedRas = ras;
                                        });
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                            ],

                            const SizedBox(height: 15),
                            const Text(
                              "Umur",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: PetData.umurPet.map((umur) {
                                return ChoiceChip(
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.defaultWhite,
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedJenis = null;
                                selectedUmur = null;
                                selectedRas = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                color: AppColors.defaultBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Terapkan",
                              style: TextStyle(
                                color: AppColors.defaultBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
