// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:gemini_chat_bloc/common/extensions/image_mim_type.dart';
import 'package:gemini_chat_bloc/features/auth/data/models/message.dart';
import 'package:gemini_chat_bloc/features/first/repository/storage_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

abstract interface class SendMessage {
  Future sendMessage({
    required String apiKey,
    required String promptText,
    required XFile? image,
  });
}

@immutable
class ChatRepository {
  ChatRepository({
    required this.storageRepository,
  });

  final StorageRepositoryAbstract storageRepository;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final StreamController<Message> messagesListController =
      StreamController<Message>();

  Future sendMessage({
    required String apiKey,
    required XFile? image,
    required String promptText,
  }) async {
    // Define your model
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

  //! Send Text Only Prompt
  Future sendTextMessage({
    required String textPrompt,
    required String apiKey,
  }) async {
    try {
      // Define your model
      final textModel =
          GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);

      final userId = _auth.currentUser!.uid;
      final sentMessageId = const Uuid().v4();

      Message message = Message(
        id: sentMessageId,
        message: textPrompt,
        createdAt: DateTime.now(),
        isMine: true,
      );

      // Save Message to Firebase
      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(sentMessageId)
          .set(message.toMap());

      // Make a text only request to Gemini API and save the response
      final response =
          await textModel.generateContent([Content.text(textPrompt)]);

      final responseText = response.text;

      // Save the response in Firebase
      final receivedMessageId = const Uuid().v4();

      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
        createdAt: DateTime.now(),
        isMine: false,
      );

      messagesListController.add(responseMessage);

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
