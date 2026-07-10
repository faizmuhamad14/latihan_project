import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class SyaratKetentuanPage extends StatelessWidget {
  const SyaratKetentuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Syarat & Ketentuan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textBttn,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBttn),
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
                  colors: [AppColors.secondary.withValues(alpha: 0.3), Colors.white],
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
                      color: AppColors.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Syarat & Ketentuan Layanan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Terakhir diperbarui: 8 Juli 2026",
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
                  Text(
                    "Ketentuan Penggunaan Aplikasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Selamat datang di Sobat Bulu. Sebelum Anda mendaftar atau masuk ke dalam aplikasi kami, mohon untuk membaca syarat dan ketentuan ini dengan seksama. Dengan menggunakan aplikasi Sobat Bulu, Anda setuju untuk terikat oleh seluruh ketentuan yang tertera di bawah ini.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Poin Penting Ketentuan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildTermsCard(
                    icon: Icons.account_box_outlined,
                    title: "1. Keabsahan Akun Pengguna",
                    description:
                        "Setiap pengguna wajib memberikan informasi yang akurat, lengkap, dan terbaru saat mendaftarkan akun. Menjaga kerahasiaan kata sandi akun sepenuhnya merupakan tanggung jawab pengguna.",
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),

                  _buildTermsCard(
                    icon: Icons.pets_outlined,
                    title: "2. Pengelolaan Profil Hewan",
                    description:
                        "Aplikasi ini menyediakan fitur pencatatan dan pengelolaan hewan peliharaan. Pengguna dilarang menyalahgunakan fitur ini untuk menyebarkan informasi palsu atau gambar yang tidak pantas.",
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 10),

                  _buildTermsCard(
                    icon: Icons.shopping_bag_outlined,
                    title: "3. Transaksi Produk & Layanan",
                    description:
                        "Informasi produk petshop yang ditampilkan dalam aplikasi bertujuan sebagai katalog informasi. Pengguna setuju untuk mematuhi prosedur pembelian resmi yang diarahkan oleh admin/aplikator.",
                    color: AppColors.teritary2,
                  ),
                  const SizedBox(height: 10),

                  _buildTermsCard(
                    icon: Icons.gavel_outlined,
                    title: "4. Pembatasan Penggunaan",
                    description:
                        "Pengguna dilarang melakukan tindakan yang dapat merusak, mengganggu, atau membebani server aplikasi Sobat Bulu, termasuk melakukan modifikasi kode atau ekstraksi data secara tidak sah.",
                    color: AppColors.textBttn,
                  ),
                  const SizedBox(height: 10),

                  _buildTermsCard(
                    icon: Icons.update_outlined,
                    title: "5. Perubahan Syarat Layanan",
                    description:
                        "Kami berhak mengubah syarat dan ketentuan ini kapan saja. Perubahan ketentuan akan diinformasikan dalam aplikasi dan penggunaan berkelanjutan berarti menyetujui syarat terbaru.",
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),

                  // Kontak Dukungan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Punya Pertanyaan?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.netral,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Apabila Anda membutuhkan bantuan lebih lanjut atau memiliki pertanyaan terkait syarat dan ketentuan layanan kami, silakan menghubungi tim admin kami.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.email_outlined, size: 18, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              "support@sobatbulu.com",
                              style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Copyright
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

  Widget _buildTermsCard({
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
                  style: TextStyle(
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
}