import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    // Compress image automatically to keep Base64 string small
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 70,
    );
    if (image == null) return null;
    return File(image.path);
  }

  /// Copies a temporary file (e.g. from cache) to the permanent Application Documents Directory.
  static Future<File> saveImagePermanently(File file, String prefix) async {
    final directory = await getApplicationDocumentsDirectory();
    final String extension = p.extension(file.path);
    final String fileName = "${prefix}_${DateTime.now().millisecondsSinceEpoch}$extension";
    final String permanentPath = p.join(directory.path, fileName);
    return file.copy(permanentPath);
  }

  /// Returns the Base64 representation of the file prefixed with 'base64:'
  /// so it is stored directly in Firestore and visible to all users.
  static Future<String?> uploadToPublicStorage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'base64:$base64String';
    } catch (e) {
      // Log/ignore errors
    }
    return null;
  }

  /// Builds a Widget to display the image regardless of whether it is an
  /// HTTP URL, Asset path, Local file, or Base64 encoded string.
  static Widget buildImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path.startsWith('base64:')) {
      try {
        final base64Data = path.substring(7);
        return Image.memory(
          base64Decode(base64Data),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height),
        );
      } catch (e) {
        return _buildErrorWidget(width, height);
      }
    } else if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height),
      );
    } else if (path.startsWith('assets')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height),
      );
    } else if (path.isNotEmpty) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(width, height),
      );
    } else {
      return _buildErrorWidget(width, height);
    }
  }

  static Widget _buildErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
    );
  }
}
