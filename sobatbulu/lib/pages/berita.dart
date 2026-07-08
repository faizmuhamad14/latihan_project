import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/constant/text_style.dart';
import 'package:sobatbulu_app/models/info_model.dart';
import 'package:sobatbulu_app/pages/edit_article_page.dart';
import 'package:sobatbulu_app/services/article_service.dart';
import 'package:sobatbulu_app/models/image_picker.dart';

class BeritaPage extends StatefulWidget {
  final InfoModel infoBerita;
  const BeritaPage({super.key, required this.infoBerita});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late InfoModel _currentArticle;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.infoBerita;
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data()?['role'] == 'admin' && mounted) {
          setState(() {
            _isAdmin = true;
          });
        }
      }
    } catch (e) {
      // Ignored
    }
  }

  Future<void> _editArticle() async {
    final updated = await Navigator.push<InfoModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticlePage(article: _currentArticle),
      ),
    );
    if (updated != null && mounted) {
      setState(() {
        _currentArticle = updated;
      });
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Artikel"),
        content: const Text("Apakah Anda yakin ingin menghapus artikel ini secara permanen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ArticleService().deleteArticle(_currentArticle.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Artikel berhasil dihapus!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus artikel: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_isAdmin && _currentArticle.id != null) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: _editArticle,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _confirmDelete,
            ),
          ]
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            spacing: 15,
            children: [
              Text(_currentArticle.title, style: AppTextStyle.produkTitle),
              SizedBox(
                width: double.infinity,
                height: 290,
                child: ImagePickerService.buildImage(
                  _currentArticle.gambar,
                  fit: BoxFit.cover,
                ),
              ),
              Text(_currentArticle.deskripsi, style: AppTextStyle.subProduk),
            ],
          ),
        ),
      ),
    );
  }
}
