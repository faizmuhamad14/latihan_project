import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

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

  /// Uploads a file to Catbox.moe and returns the public network URL.
  static Future<String?> uploadToPublicStorage(File file) async {
    try {
      final uri = Uri.parse('https://catbox.moe/user/api.php');
      final request = http.MultipartRequest('POST', uri);
      request.fields['reqtype'] = 'fileupload';
      request.files.add(
        await http.MultipartFile.fromPath(
          'fileToUpload',
          file.path,
        ),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        if (responseData.trim().startsWith('http')) {
          return responseData.trim();
        }
      }
    } catch (e) {
      // Log/ignore errors
    }
    return null;
  }
}
