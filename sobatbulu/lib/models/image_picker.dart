import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
}
