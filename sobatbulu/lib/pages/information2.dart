import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/pages/information.dart';
import 'package:sobatbulu_app/pages/location.dart';

class InformationKedua extends StatefulWidget {
  const InformationKedua({super.key});

  @override
  State<InformationKedua> createState() => _InformationKeduaState();
}

class _InformationKeduaState extends State<InformationKedua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft off-white background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              constraints: const BoxConstraints(
                maxWidth: 480,
              ), // Maximum width constraint for tablet/desktop
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon / Logo
                  const Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage("assets/images/icon2.png"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header Title
                  Text(
                    "Layanan Sobat Bulu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.netral,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Temukan artikel edukatif seru seputar peliharaan atau cari lokasi klinik dokter hewan dan petshop terdekat di sekitar Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.netral.withAlpha(160),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Card 1: Informasi & Fakta Seru
                  _buildMenuCard(
                    context: context,
                    title: "Informasi & Fakta Seru",
                    subtitle:
                        "Baca kumpulan artikel edukatif dan fakta menyenangkan seputar hewan peliharaan.",
                    icon: Icons.article_rounded,
                    backgroundColor: const Color(0xFF647B83),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InformationPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card 2: Lokasi Vet & Petshop Terdekat
                  _buildMenuCard(
                    context: context,
                    title: "Lokasi Vet & Petshop",
                    subtitle:
                        "Cari tahu lokasi klinik dokter hewan terdekat untuk perawatan peliharaan Anda.",
                    icon: Icons.map_rounded,
                    backgroundColor: const Color(0xFF8F715B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationPage()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withAlpha(50),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 26, color: Colors.white),
                  ),
                  const SizedBox(width: 16),

                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withAlpha(200),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Chevron indicator
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white70,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
