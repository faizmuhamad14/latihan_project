import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/data/list_map.dart';
import 'package:sobatbulu_app/models/image_picker.dart';
import 'package:sobatbulu_app/models/model_data.dart';
import 'package:sobatbulu_app/services/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _rateController = TextEditingController(text: "4.8");
  final _descriptionController = TextEditingController();

  String _selectedCategory = "Makanan Kucing";
  final List<String> _categories = [
    "Makanan Kucing",
    "Makanan Anjing",
    "Perawatan",
    "Aksesoris",
    "Kesehatan",
    "Mainan",
    "Kandang",
  ];

  final List<String> _jenisOptions = ["Kucing", "Anjing"];
  final List<String> _selectedJenis = [];

  final List<String> _umurOptions = ["Anak", "Dewasa", "Senior"];
  final List<String> _selectedUmur = [];
  final List<String> _selectedRas = [];

  File? _selectedImage;
  bool _isLoading = false;

  List<String> _getAvailableRas() {
    final List<String> available = [];
    if (_selectedJenis.contains("Kucing")) {
      available.addAll(PetData.petBreeds["Kucing"] ?? []);
    }
    if (_selectedJenis.contains("Anjing")) {
      available.addAll(PetData.petBreeds["Anjing"] ?? []);
    }
    return available.toSet().toList();
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerService.pickImageFromGallery();
    if (image != null) {
      final savedImage = await ImagePickerService.saveImagePermanently(
        image,
        "product",
      );
      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar produk terlebih dahulu')),
      );
      return;
    }
    if (_selectedJenis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu rekomendasi jenis hewan'),
        ),
      );
      return;
    }
    if (_selectedUmur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu rekomendasi umur hewan'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Upload to public storage first
    String imageUrl = _selectedImage!.path;
    final publicUrl = await ImagePickerService.uploadToPublicStorage(
      _selectedImage!,
    );
    if (publicUrl != null) {
      imageUrl = publicUrl;
    }

    final product = ProdukPetshop(
      nama: _nameController.text.trim(),
      kategori: _selectedCategory,
      harga: int.tryParse(_priceController.text) ?? 0,
      gambar: imageUrl,
      rate: double.tryParse(_rateController.text) ?? 0,
      jenisHewan: _selectedJenis,
      umur: _selectedUmur,
      ras: _selectedRas,
      deskripsi: _descriptionController.text.trim(),
    );

    try {
      await ProductService().addProduct(product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menambahkan produk: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _rateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Produk Baru"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gambar Produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Colors.grey.shade400,
                          strokeWidth: 2,
                          dashPattern: const [6, 4],
                          radius: const Radius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Ketuk untuk memilih gambar dari galeri",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Nama Produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Royal Canin Hairball",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Nama produk tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kategori",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Harga (Rp)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Contoh: 85000",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Harga tidak boleh kosong";
                        }
                        if (int.tryParse(value) == null) {
                          return "Harga harus berupa angka valid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Rating Produk (0.0 - 5.0)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _rateController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Contoh: 4.8",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Rating tidak boleh kosong";
                        }
                        final parsed = double.tryParse(value);
                        if (parsed == null || parsed < 0.0 || parsed > 5.0) {
                          return "Rating harus di antara 0.0 dan 5.0";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Rekomendasi Jenis Hewan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: _jenisOptions.map((jenis) {
                        final isSelected = _selectedJenis.contains(jenis);
                        return FilterChip(
                          selectedColor: AppColors.primary,
                          label: Text(jenis),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedJenis.add(jenis);
                              } else {
                                _selectedJenis.remove(jenis);
                                // Clear selected breeds that are no longer available
                                final allowedBreeds = _getAvailableRas();
                                _selectedRas.removeWhere(
                                  (ras) => !allowedBreeds.contains(ras),
                                );
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Rekomendasi Umur Hewan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: _umurOptions.map((umur) {
                        final isSelected = _selectedUmur.contains(umur);
                        return FilterChip(
                          selectedColor: AppColors.primary,
                          label: Text(umur),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedUmur.add(umur);
                              } else {
                                _selectedUmur.remove(umur);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Rekomendasi Ras Hewan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _getAvailableRas().isEmpty
                        ? const Text(
                            "Pilih Rekomendasi Jenis Hewan terlebih dahulu untuk melihat pilihan ras",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: _getAvailableRas().map((ras) {
                              final isSelected = _selectedRas.contains(ras);
                              return FilterChip(
                                selectedColor: AppColors.primary,
                                label: Text(ras),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedRas.add(ras);
                                    } else {
                                      _selectedRas.remove(ras);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 16),
                    const Text(
                      "Deskripsi Produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            "Masukkan deskripsi lengkap mengenai produk ini...",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Deskripsi produk tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveProduct,
                        child: const Text(
                          "Simpan Produk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
