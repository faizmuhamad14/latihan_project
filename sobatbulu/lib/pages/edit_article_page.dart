import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sobatbulu_app/constant/app_color.dart';
import 'package:sobatbulu_app/models/info_model.dart';
import 'package:sobatbulu_app/services/article_service.dart';
import 'package:sobatbulu_app/models/image_picker.dart';

class EditArticlePage extends StatefulWidget {
  final InfoModel article;
  const EditArticlePage({super.key, required this.article});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _selectedCategory;
  final List<String> _categories = ["Artikel", "FunFact"];

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController = TextEditingController(text: widget.article.deskripsi);
    _selectedCategory = widget.article.kategori;
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerService.pickImageFromGallery();
    if (image != null) {
      final savedImage = await ImagePickerService.saveImagePermanently(image, "article");
      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  void _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String finalImageUrl = widget.article.gambar;
    if (_selectedImage != null) {
      final publicUrl = await ImagePickerService.uploadToPublicStorage(_selectedImage!);
      if (publicUrl != null) {
        finalImageUrl = publicUrl;
      } else {
        finalImageUrl = _selectedImage!.path;
      }
    }

    final updatedArticle = InfoModel(
      id: widget.article.id,
      title: _titleController.text.trim(),
      kategori: _selectedCategory,
      gambar: finalImageUrl,
      deskripsi: _descriptionController.text.trim(),
    );

    try {
      if (widget.article.id != null) {
        await ArticleService().updateArticle(widget.article.id!, updatedArticle);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Artikel berhasil diperbarui!')),
          );
          Navigator.pop(context, updatedArticle);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Artikel ini tidak dapat diedit di database.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui artikel: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      );
    }

    if (widget.article.gambar.startsWith('http')) {
      return Image.network(
        widget.article.gambar,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      );
    }

    if (widget.article.gambar.startsWith('assets')) {
      return Image.asset(
        widget.article.gambar,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(widget.article.gambar),
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Artikel"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gambar Artikel",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Colors.grey.shade400,
                          strokeWidth: 2,
                          dashPattern: const [6, 4],
                          radius: const Radius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildImagePreview(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Judul Artikel",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Mengapa Kucing Takut Air?",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Judul tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kategori",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Konten/Deskripsi Artikel",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText: "Tuliskan isi artikel lengkap di sini...",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Konten tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveArticle,
                        child: const Text(
                          "Perbarui Artikel",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
