import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:image_picker/image_picker.dart';

@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future sendMessage({
    required String apiKey,
    required String promptText,
    required XFile image,
  }) async {}
}
