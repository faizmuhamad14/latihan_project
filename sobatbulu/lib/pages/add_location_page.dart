import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/services/location_service.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _mapsUrlController = TextEditingController();
  
  double _rating = 4.5;
  final List<String> _selectedLayanan = [];
  final List<String> _availableLayanan = [
    "Petshop",
    "Klinik",
    "Grooming",
    "Hotel",
    "Penitipan",
    "Konsultasi",
  ];

  bool _isLoading = false;

  void _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final locationData = {
      'nama': _namaController.text.trim(),
      'alamat': _alamatController.text.trim(),
      'telepon': _teleponController.text.trim(),
      'rating': _rating,
      'layanan': _selectedLayanan,
      'mapsUrl': _mapsUrlController.text.trim(),
      'latitude': -6.200000, // Default coordinates for Jakarta area
      'longitude': 106.816666,
    };

    try {
      await LocationService().addLocation(locationData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi berhasil ditambahkan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan lokasi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _mapsUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Lokasi Baru"),
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
                    // Nama Lokasi
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Petshop / Klinik",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.store_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama lokasi tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Alamat
                    TextFormField(
                      controller: _alamatController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Alamat Lengkap",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Alamat tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Telepon
                    TextFormField(
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Nomor Telepon",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone_rounded),
                        hintText: "Contoh: 081234567890",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Google Maps URL
                    TextFormField(
                      controller: _mapsUrlController,
                      decoration: const InputDecoration(
                        labelText: "Link Google Maps URL",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map_rounded),
                        hintText: "https://maps.google.com/...",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Rating
                    const Text(
                      "Rating Lokasi",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: _rating,
                            min: 1.0,
                            max: 5.0,
                            divisions: 40,
                            label: _rating.toString(),
                            activeColor: Colors.amber,
                            onChanged: (value) {
                              setState(() {
                                _rating = double.parse(value.toStringAsFixed(1));
                              });
                            },
                          ),
                        ),
                        Text(
                          _rating.toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Layanan Checkboxes
                    const Text(
                      "Pilih Layanan Tersedia",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableLayanan.map((layanan) {
                        final isSelected = _selectedLayanan.contains(layanan);
                        return FilterChip(
                          label: Text(layanan),
                          selected: isSelected,
                          selectedColor: AppColors.secondary,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                _selectedLayanan.add(layanan);
                              } else {
                                _selectedLayanan.remove(layanan);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveLocation,
                        child: const Text(
                          "Simpan Lokasi",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
