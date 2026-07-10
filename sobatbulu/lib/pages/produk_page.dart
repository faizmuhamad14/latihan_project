import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/models/image_picker.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/models/rupiah.dart';
import 'package:sobatbulu_app/pages/detail_produk.dart';
import 'package:sobatbulu_app/services/product_service.dart';

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
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

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

  late final StreamSubscription<List<ProdukPetshop>> _productSubscription;
  List<ProdukPetshop> _firestoreProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _productSubscription = ProductService().getProducts().listen(
      (products) {
        if (mounted) {
          setState(() {
            _firestoreProducts = products;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _productSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<ProdukPetshop> get filteredProducts {
    final List<ProdukPetshop> allProducts = _firestoreProducts;
    return allProducts.where((product) {
      final matchSearch =
          searchQuery.isEmpty ||
          product.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.kategori.toLowerCase().contains(searchQuery.toLowerCase());

      final matchCategory =
          selectedCategory == "Semua" || product.kategori == selectedCategory;

      final matchJenis =
          selectedJenis == null || product.jenisHewan.contains(selectedJenis);

      final matchUmur =
          selectedUmur == null || product.umur.contains(selectedUmur);

      return matchSearch && matchCategory && matchJenis && matchUmur;
    }).toList();
  }

  Widget _buildProductImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return ImagePickerService.buildImage(
      path,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft premium background
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      searchQuery = "";
                                    });
                                  },
                                )
                              : null,
                          hintText: "Cari makanan, shampoo, pasir...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Styled Filter Button
                  GestureDetector(
                    onTap: showFilterBottomSheet,
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (selectedJenis != null || selectedUmur != null)
                              ? AppColors.secondary2
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: (selectedJenis != null || selectedUmur != null)
                            ? AppColors.secondary2
                            : AppColors.netral,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Selector Chips Row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selectedColor: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade100,
                        backgroundColor: Colors.grey.shade50,
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.netral,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (value) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        elevation: isSelected ? 2 : 0,
                        pressElevation: 1,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Results Info & Grid List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.teritary2,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Produk Pilihan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              Text(
                                "${filteredProducts.length} Hasil",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: filteredProducts.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 80,
                                          color: Colors.grey.shade300,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Produk Tidak Ditemukan",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Coba periksa ejaan pencarian Anda atau atur ulang filter produk.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double screenWidth = MediaQuery.of(
                                      context,
                                    ).size.width;

                                    // Determine crossAxisCount based on screen width for responsive sizing
                                    int crossAxisCount = 2;
                                    if (screenWidth > 1200) {
                                      crossAxisCount = 6;
                                    } else if (screenWidth > 900) {
                                      crossAxisCount = 5;
                                    } else if (screenWidth > 750) {
                                      crossAxisCount = 4;
                                    } else if (screenWidth > 500) {
                                      crossAxisCount = 3;
                                    } else {
                                      crossAxisCount = 2;
                                    }

                                    // Calculate actual width available for cells inside the padding
                                    final double crossAxisSpacing = 8.0;
                                    final double gridWidth =
                                        constraints.maxWidth -
                                        32.0; // Subtract horizontal padding (16 left + 16 right)
                                    final double itemWidth =
                                        (gridWidth -
                                            (crossAxisCount - 1) *
                                                crossAxisSpacing) /
                                        crossAxisCount;

                                    // Target card height
                                    final double itemHeight = 335.0;
                                    final double childAspectRatio =
                                        itemWidth / itemHeight;

                                    return GridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      physics: const BouncingScrollPhysics(),
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
                                            border: Border.all(
                                              color: AppColors.item,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  5,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        15,
                                                      ),
                                                      topRight: Radius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                child: _buildProductImage(
                                                  data.gambar,
                                                  width: double.infinity,
                                                  height: 140,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                              8,
                                                              4,
                                                              8,
                                                              4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .secondary,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          data.kategori,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 38,
                                                        child: Text(
                                                          data.nama,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.star_rounded,
                                                            color: AppColors
                                                                .altTeritary,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "${data.rate}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .defaultBlack,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 36,
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .backgroundBttn,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => DetailProduk(
                                                                          produk:
                                                                              data,
                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                "Lihat Detail",
                                                                style: TextStyle(
                                                                  color: AppColors
                                                                      .textBttn,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filter Produk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jenis Hewan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: PetData.jenisHewan.map((jenis) {
                                final isSelected = selectedJenis == jenis;
                                return ChoiceChip(
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Colors.grey.shade100,
                                  label: Text(
                                    jenis,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.netral,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (value) {
                                    setModalState(() {
                                      selectedJenis = value ? jenis : null;
                                      selectedRas = null;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: 0.8,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            if (selectedJenis != null) ...[
                              const SizedBox(height: 16),
                              const Text(
                                "Ras Hewan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: PetData.petBreeds[selectedJenis]!.map(
                                  (ras) {
                                    final isSelected = selectedRas == ras;
                                    return ChoiceChip(
                                      selectedColor: AppColors.primary,
                                      label: Text(
                                        ras,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.netral,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey.shade100,
                                      selected: isSelected,
                                      onSelected: (value) {
                                        setModalState(() {
                                          selectedRas = value ? ras : null;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.grey.shade300,
                                          width: 0.8,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ],

                            const SizedBox(height: 16),
                            const Text(
                              "Umur",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: PetData.umurPet.map((umur) {
                                final isSelected =
                                    selectedUmur == umur["label"];
                                return ChoiceChip(
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Colors.grey.shade100,
                                  label: Text(
                                    umur["label"]!,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.netral,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (value) {
                                    setModalState(() {
                                      selectedUmur = value
                                          ? umur["label"]
                                          : null;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: 0.8,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Color(0xFF2C3E50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                              "Reset Filter",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary2,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Terapkan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
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