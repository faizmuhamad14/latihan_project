import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sobatbulu_app/models/info_model.dart';
import 'package:sobatbulu_app/services/article_service.dart';
import 'package:sobatbulu_app/pages/edit_article_page.dart';

class ManageArticlesPage extends StatelessWidget {
  const ManageArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kelola Artikel"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<InfoModel>>(
        stream: ArticleService().getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text("Belum ada artikel di database."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: article.gambar.startsWith('http')
                          ? Image.network(article.gambar, fit: BoxFit.cover)
                          : article.gambar.startsWith('assets')
                              ? Image.asset(article.gambar, fit: BoxFit.cover)
                              : Image.file(File(article.gambar), fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(article.kategori),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditArticlePage(article: article),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Artikel"),
                              content: const Text("Apakah Anda yakin ingin menghapus artikel ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && article.id != null) {
                            await ArticleService().deleteArticle(article.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Artikel berhasil dihapus")),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
