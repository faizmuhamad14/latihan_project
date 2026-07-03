import 'package:flutter/material.dart';
import 'package:sobatbulu_app/constant/app_color.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Tentang Kami",
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
            // Header dengan logo & nama aplikasi
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.3), Colors.white],
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
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage("assets/images/logo_bg.png"),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    "Sobat Bulu",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.netral,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    // TODO: Ganti dengan versi aplikasi
                    "Versi 1.0.0",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deskripsi aplikasi
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.pets, color: AppColors.textBttn, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Tentang Aplikasi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.netral,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          // TODO: Ganti dengan deskripsi aplikasi
                          "Deskripsi aplikasi akan ditampilkan di sini. Jelaskan tujuan dan manfaat aplikasi Sobat Bulu untuk pengguna.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Fitur unggulan
                  Text(
                    "Fitur Unggulan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  SizedBox(height: 12),
                  // TODO: Ganti isi fitur sesuai kebutuhan
                  _buildFeatureCard(
                    icon: Icons.pets,
                    title: "Judul Fitur 1",
                    description: "Deskripsi fitur 1 di sini.",
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 10),
                  _buildFeatureCard(
                    icon: Icons.monitor_heart_outlined,
                    title: "Judul Fitur 2",
                    description: "Deskripsi fitur 2 di sini.",
                    color: AppColors.secondary,
                  ),
                  SizedBox(height: 10),
                  _buildFeatureCard(
                    icon: Icons.store_outlined,
                    title: "Judul Fitur 3",
                    description: "Deskripsi fitur 3 di sini.",
                    color: AppColors.teritary,
                  ),
                  SizedBox(height: 24),

                  // Tim pengembang
                  Text(
                    "Tim Pengembang",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.netral,
                    ),
                  ),
                  SizedBox(height: 12),
                  // TODO: Ganti dengan data tim pengembang
                  _buildTeamMember(
                    name: "Nama Anggota 1",
                    role: "Role / Jabatan",
                  ),
                  _buildTeamMember(
                    name: "Nama Anggota 2",
                    role: "Role / Jabatan",
                  ),
                  _buildTeamMember(
                    name: "Nama Anggota 3",
                    role: "Role / Jabatan",
                  ),
                  SizedBox(height: 24),

                  // Kontak
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hubungi Kami",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.netral,
                          ),
                        ),
                        SizedBox(height: 12),
                        // TODO: Ganti dengan kontak asli
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          text: "email@contoh.com",
                        ),
                        SizedBox(height: 8),
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          text: "+62 xxx-xxxx-xxxx",
                        ),
                        SizedBox(height: 8),
                        _buildContactItem(
                          icon: Icons.language,
                          text: "www.contoh.com",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Copyright
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        // TODO: Ganti tahun dan nama
                        "© 2025 Sobat Bulu. All rights reserved.",
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 14),
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
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(Icons.person, color: AppColors.textBttn, size: 22),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.netral,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
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
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textBttn,
          ),
        ),
      ],
    );
  }
}
