import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/models/location.dart';
import 'package:sobatbulu_app/services/location_service.dart';
import 'package:sobatbulu_app/utils/map_launcher.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final service = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Lokasi Petshop"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<LocationModel>>(
        stream: service.getLocations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final locations = snapshot.data!;

          if (locations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_off_rounded,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Belum Ada Data Lokasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Data lokasi petshop di database masih kosong. Silakan hubungi admin untuk menambahkan lokasi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final lokasi = locations[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFEFEDEE),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lokasi.nama,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.netral,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              lokasi.rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.netral2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lokasi.alamat,
                            style: TextStyle(
                              color: AppColors.textcard,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (lokasi.telepon.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lokasi.telepon,
                              style: TextStyle(
                                color: AppColors.textcard,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (lokasi.layanan.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: lokasi.layanan.map((layanan) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.chip,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              layanan,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.teksButton,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.teksButton,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (lokasi.mapsUrl != null && lokasi.mapsUrl!.isNotEmpty) {
                            openMap(lokasi.mapsUrl!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Link Google Maps tidak tersedia untuk lokasi ini"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text(
                          "Petunjuk Arah (Maps)",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}