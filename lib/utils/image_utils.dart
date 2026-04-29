import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage([ImageSource source = ImageSource.camera, int? imageQuality]) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if(kDebugMode) print("Picked file path: ${pickedFile.path}");
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if(kDebugMode) print("Error picking image: $e");
      return null;
    }
  }
}

