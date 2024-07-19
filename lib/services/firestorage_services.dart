import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String fileName, File file) async {
    final imageReference = _storage.ref().child("events").child("$fileName.jpg");
    final uploadTask = imageReference.putFile(file);

    String imageUrl = "";
    await uploadTask.whenComplete(() async {
      imageUrl = await imageReference.getDownloadURL();
    });

    return imageUrl;
  }

  Future<String> changeFile({
    required String oldImageUrl,
    required File newFile,
  }) async {
    final imageReference = _storage.refFromURL(oldImageUrl);
    final uploadTask = imageReference.putFile(newFile);

    String imageUrl = "";
    await uploadTask.whenComplete(() async {
      imageUrl = await imageReference.getDownloadURL();
    });

    return imageUrl;
  }

  Future<void> deleteFile(String fileUrl) async {
    final imageReference = _storage.refFromURL(fileUrl);
    await imageReference.delete();
  }
}
