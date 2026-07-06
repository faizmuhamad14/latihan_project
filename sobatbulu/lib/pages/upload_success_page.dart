import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class UploadSuccessPage extends StatelessWidget {
  final int count;
  const UploadSuccessPage({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final bool isAlreadyUploaded = count == 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon / Animation container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAlreadyUploaded
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.secondary.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAlreadyUploaded ? AppColors.primary : AppColors.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: (isAlreadyUploaded ? AppColors.primary : AppColors.secondary)
                              .withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      isAlreadyUploaded ? Icons.info_outline_rounded : Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Status Title
              Text(
                isAlreadyUploaded ? "Data Sudah Sinkron" : "Unggah Data Berhasil!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.netral,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              
              // Status Description
              Text(
                isAlreadyUploaded
                    ? "Data lokasi petshop sudah ada di Firebase Firestore dan tidak perlu diunggah ulang."
                    : "Semua data lokasi petshop dari file JSON telah berhasil diunggah dan disinkronisasikan ke Firebase Firestore.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),

              // Upload Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  spacing: 12,
                  children: [
                    _buildInfoRow(
                      label: "Tipe Data",
                      value: "Lokasi Petshop",
                    ),
                    _buildInfoRow(
                      label: "Total Unggah",
                      value: isAlreadyUploaded ? "0 Baru (Sudah Ada)" : "$count Lokasi",
                      valueColor: isAlreadyUploaded ? AppColors.textBttn : AppColors.secondary2,
                    ),
                    _buildInfoRow(
                      label: "Sumber File",
                      value: "location.json",
                    ),
                    _buildInfoRow(
                      label: "Target Database",
                      value: "Firebase Firestore",
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),

              // Action button to go back
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Pop to return to the location page
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Kembali ke Halaman Lokasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.netral,
          ),
        ),
      ],
    );
  }
}
