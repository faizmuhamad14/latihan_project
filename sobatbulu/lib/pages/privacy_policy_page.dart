import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  // --- Data ---

  static const List<Map<String, String>> _policies = [
    {
      "title": "Pengumpulan Informasi",
      "content":
          "Kami mengumpulkan informasi yang Anda berikan secara langsung saat "
              "mendaftar akun, seperti nama, email, kota, dan nomor telepon. "
              "Selain itu, kami menyimpan data hewan peliharaan yang Anda "
              "tambahkan ke dalam aplikasi.",
    },
    {
      "title": "Penggunaan Informasi",
      "content":
          "Informasi yang dikumpulkan digunakan untuk menyediakan dan "
              "meningkatkan layanan aplikasi Sobat Bulu, termasuk mengelola "
              "akun pengguna, menyimpan data hewan peliharaan, serta "
              "memberikan rekomendasi produk dan informasi yang relevan.",
    },
    {
      "title": "Penyimpanan Data",
      "content":
          "Seluruh data Anda disimpan secara lokal di perangkat Anda. "
              "Kami tidak mengirim data pribadi ke server eksternal tanpa "
              "persetujuan Anda. Data akan tetap tersimpan selama aplikasi "
              "terinstal di perangkat.",
    },
    {
      "title": "Keamanan Data",
      "content":
          "Kami berkomitmen untuk melindungi informasi pribadi Anda. "
              "Meskipun tidak ada metode transmisi melalui internet yang "
              "100% aman, kami berusaha menggunakan cara yang dapat diterima "
              "secara komersial untuk melindungi data Anda.",
    },
    {
      "title": "Hak Pengguna",
      "content":
          "Anda memiliki hak untuk mengakses, memperbarui, atau menghapus "
              "informasi pribadi Anda kapan saja melalui menu pengaturan "
              "akun di dalam aplikasi. Anda juga dapat menghapus akun Anda "
              "beserta seluruh data yang terkait.",
    },
    {
      "title": "Perubahan Kebijakan",
      "content":
          "Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. "
              "Perubahan akan diberitahukan melalui pembaruan aplikasi. "
              "Penggunaan berkelanjutan atas aplikasi setelah perubahan "
              "dianggap sebagai persetujuan terhadap kebijakan yang diperbarui.",
    },
    {
      "title": "Hubungi Kami",
      "content":
          "Jika Anda memiliki pertanyaan atau saran mengenai Kebijakan "
              "Privasi ini, jangan ragu untuk menghubungi kami melalui "
              "email di support@sobatbulu.com.",
    },
  ];

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 40,
                color: AppColors.netral2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Terakhir diperbarui: Juli 2025",
              style: TextStyle(
                fontSize: 13,
                color: AppColors.altNetral,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Intro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withAlpha(60),
                width: 1,
              ),
            ),
            child: const Text(
              "Sobat Bulu menghargai privasi Anda. Kebijakan ini "
              "menjelaskan bagaimana kami mengumpulkan, menggunakan, "
              "dan melindungi informasi pribadi Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.netral,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Policy sections
          ...List.generate(
            _policies.length,
            (index) => _buildPolicySection(
              number: index + 1,
              title: _policies[index]["title"]!,
              content: _policies[index]["content"]!,
            ),
          ),

          const SizedBox(height: 12),

          // Footer
          Center(
            child: Text(
              "© 2025 Sobat Bulu. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.altNetral.withAlpha(150),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required int number,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundItem,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "$number",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.netral2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Content
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
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.altNetral.withAlpha(220),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
