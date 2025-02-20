import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static String _generateUniqueFileName() {
    final DateTime now = DateTime.now();
    return '${now.millisecondsSinceEpoch}.jpg';
  }

  /// Function for upload an image
  static Future<String?> uploadImage(File image, String path) async {
    try {
      final String fileName =
          _generateUniqueFileName() + image.path.split('.').last;

      final Reference storageRef = _storage.ref().child(path + fileName);
      final UploadTask uploadTask = storageRef.putFile(image);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      log(" ---- Error uploading image: $e");
      return null;
    }
  }

  /// Function for upload multiple images
  static Future<List<String>> uploadMultipleImages(
      List<File> images, String path) async {
    List<String> downloadURLs = [];

    for (var image in images) {
      try {
        final String? downloadURL = await uploadImage(image, path);

        if (downloadURL != null) {
          downloadURLs.add(downloadURL);
        }
      } catch (e) {
        log(" ---- Error uploading image ${image.path}: $e");
      }
    }

    return downloadURLs;
  }
}
