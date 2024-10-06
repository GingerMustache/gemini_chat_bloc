import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:image_picker/image_picker.dart';

abstract interface class StorageRepositoryAbstract {
  Future<String> saveImageToStorage(
      {required XFile image, required String messageId});
  Future<void> testUse(String text);
}

@immutable
class FirebaseStorageRepository implements StorageRepositoryAbstract {
  final _storageRef = FirebaseStorage.instance;

  @override
  Future<String> saveImageToStorage(
      {required XFile image, required String messageId}) async {
    try {
      Reference ref = _storageRef.ref('images').child(messageId);
      TaskSnapshot snapshot = await ref.putFile(File(image.path));
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw (Exception(e.toString()));
      //TODO need to handle error, and logged it
    }
  }

  @override
  Future<void> testUse(String text) async {
    Reference ref = _storageRef.ref('test').child('test_child');
    await ref.putString(text);
  }
}
