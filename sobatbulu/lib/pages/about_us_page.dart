import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // --- Data ---

  static const String _appVersion = "1.0.0";

  static const String _description =
      "Sobat Bulu adalah aplikasi pendamping hewan peliharaan yang membantu "
      "Anda merawat, memantau, dan memberikan yang terbaik untuk sahabat "
      "berbulu Anda. Dari pencatatan profil hewan, kebutuhan nutrisi, "
      "hingga informasi produk — semuanya dalam satu aplikasi.";

  static const List<Map<String, String>> _teamMembers = [
    {
      "nama": "Muhamad Faiz",
      "role": "Developer",
    },
  ];

  static const List<Map<String, dynamic>> _features = [
    {
      "icon": "pets",
      "title": "Profil Hewan",
      "desc": "Catat dan kelola informasi hewan peliharaan Anda.",
    },
    {
      "icon": "store",
      "title": "Produk & Kebutuhan",
      "desc": "Temukan produk terbaik untuk hewan kesayangan.",
    },
    {
      "icon": "article",
      "title": "Informasi & Edukasi",
      "desc": "Artikel dan tips merawat hewan peliharaan.",
    },
  ];

  // --- Icon Helper ---

  IconData _getFeatureIcon(String key) {
    switch (key) {
      case "pets":
        return Icons.pets_rounded;
      case "store":
        return Icons.storefront_rounded;
      case "article":
        return Icons.article_rounded;
      default:
        return Icons.star_rounded;
    }
  }

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
        "Tentang Kami",
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
        children: [
          _buildLogoSection(),
          const SizedBox(height: 24),
          _buildDescriptionSection(),
          const SizedBox(height: 24),
          _buildFeaturesSection(),
          const SizedBox(height: 24),
          _buildTeamSection(),
          const SizedBox(height: 24),
          _buildFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/images/iconsobatbulu.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.pets_rounded,
                  size: 44,
                  color: AppColors.netral2,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Sobat Bulu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.netral,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Versi $_appVersion",
          style: TextStyle(
            fontSize: 13,
            color: AppColors.altNetral.withAlpha(180),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
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
        _description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: AppColors.netral,
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Fitur Utama",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.netral,
          ),
        ),
        const SizedBox(height: 12),
        ..._features.map((feature) => _buildFeatureItem(
              icon: _getFeatureIcon(feature["icon"] as String),
              title: feature["title"] as String,
              desc: feature["desc"] as String,
            )),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundItem,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(70),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.netral2, size: 22),
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
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.altNetral.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tim Pengembang",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.netral,
          ),
        ),
        const SizedBox(height: 12),
        ..._teamMembers.map((member) => _buildTeamMemberItem(
              nama: member["nama"]!,
              role: member["role"]!,
            )),
      ],
    );
  }

  Widget _buildTeamMemberItem({
    required String nama,
    required String role,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundItem,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.teritary.withAlpha(70),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.teritary2,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.netral,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.altNetral.withAlpha(200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Divider(color: AppColors.item.withAlpha(80)),
        const SizedBox(height: 8),
        Text(
          "© 2025 Sobat Bulu. All rights reserved.",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.altNetral.withAlpha(150),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Dibuat dengan ❤️ untuk pecinta hewan",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.altNetral.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
