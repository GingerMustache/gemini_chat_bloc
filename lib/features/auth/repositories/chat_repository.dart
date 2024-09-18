// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:gemini_chat_bloc/features/auth/data/models/message.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/storage_repository.dart';

@immutable
class ChatRepository {
  ChatRepository({
    required this.storageRepository,
  });

  final StorageRepositoryAbstract storageRepository;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future sendMessage({
    required String apiKey,
    required String promptText,
    required XFile image,
  }) async {
    final textModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    final imageModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final userId = _auth.currentUser!.uid;
    final sentMessageId = const Uuid().v4();

    Message message = Message(
      id: sentMessageId,
      message: promptText,
      createdAt: DateTime.now(),
      isMine: true,
    );

    if (image != null) {
      // Save image to Firebase Storage and get download url
      final downloadUrl = await storageRepository.saveImageToStorage(
        image: image,
        messageId: sentMessageId,
      );

      message = message.copyWith(
        imageUrl: downloadUrl,
      );
    }

    // Save Message to Firebase
    await _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .doc(sentMessageId)
        .set(message.toMap());

    // Create a response
    GenerateContentResponse response;

    try {
      if (image == null) {
        // Make a text only request to Gemini API
        response = await textModel.generateContent([Content.text(promptText)]);
      } else {
        // convert it to Uint8List
        final imageBytes = await image.readAsBytes();

        // Define your parts
        final prompt = TextPart(promptText);
        final mimeType = image.getMimeTypeFromExtension();
        final imagePart = DataPart(mimeType, imageBytes);

        // Make a mutli-model request to Gemini API
        response = await imageModel.generateContent([
          Content.multi([
            prompt,
            imagePart,
          ])
        ]);
      }

      final responseText = response.text;

      // Save the response in Firebase
      final receivedMessageId = const Uuid().v4();

      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
        createdAt: DateTime.now(),
        isMine: false,
      );

      // Save Message to Firebase
      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
