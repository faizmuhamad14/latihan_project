import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/models/location.dart';
import 'package:sobatbulu_app/services/location_service.dart';
import 'package:sobatbulu_app/services/upload_location_service.dart';
import 'package:sobatbulu_app/pages/upload_success_page.dart';
import 'package:sobatbulu_app/utils/map_launcher.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final service = LocationService();

  Future<void> _handleUpload(BuildContext context) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final uploadCount = await UploadLocationService().uploadLocations();
      
      if (context.mounted) {
        // Pop loading dialog
        Navigator.pop(context);
        
        // Navigate to success page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadSuccessPage(count: uploadCount),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Pop loading dialog
        Navigator.pop(context);
        
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengunggah data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Lokasi Petshop"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_rounded),
            tooltip: "Unggah Data Lokasi",
            onPressed: () => _handleUpload(context),
          ),
        ],
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
                      "Data lokasi petshop di database masih kosong. Ketuk tombol di bawah untuk mengunggah data dari file local JSON sekali jalan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _handleUpload(context),
                      icon: const Icon(Icons.cloud_upload_rounded),
                      label: const Text("Unggah Data Sekarang"),
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

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    openMap(lokasi.latitude, lokasi.longitude);
                  },
                  title: Text(lokasi.nama),
                  subtitle: Text(lokasi.alamat),
                  trailing: const Icon(Icons.location_on),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
