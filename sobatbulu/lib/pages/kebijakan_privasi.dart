import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Kebijakan Privasi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textBttn,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textBttn),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.3), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.gpp_good_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Privasi & Keamanan Anda",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Terakhir diperbarui: 6 Juli 2026",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[550],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deskripsi Singkat
                  const Text(
                    "Komitmen Kami",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Di Sobat Bulu, kami sangat menghargai privasi Anda dan hewan peliharaan kesayangan Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, menjaga, dan melindungi informasi pribadi Anda saat menggunakan aplikasi kami.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Poin-poin Kebijakan
                  const Text(
                    "Detail Kebijakan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildPrivacyCard(
                    icon: Icons.assignment_ind_outlined,
                    title: "1. Informasi yang Kami Kumpulkan",
                    description:
                        "Kami mengumpulkan data akun seperti nama, alamat email, kata sandi, serta informasi hewan peliharaan Anda (seperti jenis, umur, riwayat kesehatan) untuk personalisasi layanan.",
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),

                  _buildPrivacyCard(
                    icon: Icons.settings_suggest_outlined,
                    title: "2. Penggunaan Informasi",
                    description:
                        "Data yang dikumpulkan digunakan untuk mengelola profil, menyediakan pelacakan kondisi hewan, memproses transaksi produk, serta meningkatkan kualitas dan fitur aplikasi Sobat Bulu.",
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 10),

                  _buildPrivacyCard(
                    icon: Icons.security_outlined,
                    title: "3. Keamanan Data Anda",
                    description:
                        "Kami berkomitmen penuh untuk mengamankan data pribadi Anda menggunakan protokol enkripsi standar industri guna mencegah akses tidak sah, kebocoran, atau perubahan data.",
                    color: AppColors.teritary2,
                  ),
                  const SizedBox(height: 10),

                  _buildPrivacyCard(
                    icon: Icons.share_outlined,
                    title: "4. Berbagi dengan Pihak Ketiga",
                    description:
                        "Sobat Bulu tidak menjual atau menyewakan informasi pribadi Anda. Informasi hanya dibagikan dengan mitra pihak ketiga terpercaya untuk memproses pembayaran atau fungsionalitas hosting dengan persetujuan Anda.",
                    color: AppColors.textBttn,
                  ),
                  const SizedBox(height: 10),

                  _buildPrivacyCard(
                    icon: Icons.cookie_outlined,
                    title: "5. Cookie dan Pelacakan",
                    description:
                        "Aplikasi ini menggunakan penyimpanan lokal dan preferensi perangkat untuk mengingat sesi masuk Anda dan preferensi pengaturan profil demi kelancaran penggunaan aplikasi.",
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),

                  // Hubungi Kami (Pertanyaan)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hubungi Kami",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.netral,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Jika Anda memiliki pertanyaan, keluhan, atau kekhawatiran tentang privasi data Anda, silakan hubungi tim dukungan kami melalui kontak di bawah ini.",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textBttn,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          text: "privacy@sobatbulu.com",
                        ),
                        const SizedBox(height: 8),
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          text: "+62 812-3456-7890",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Copyright / Penutup
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        "© 2026 Sobat Bulu. Hak Cipta Dilindungi Undang-Undang.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
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

  Widget _buildPrivacyCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.netral,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textBttn),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textBttn,
          ),
        ),
      ],
    );
  }
}
