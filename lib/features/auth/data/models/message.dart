// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' show immutable;

@immutable
class Message {
  final String id;
  final String message;
  final String? imageUrl;
  final DateTime createAt;
  final bool isMine;

  const Message({
    required this.id,
    required this.message,
    required this.imageUrl,
    required this.createAt,
    required this.isMine,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'imageUrl': imageUrl,
      'createAt': createAt.millisecondsSinceEpoch,
      'isMine': isMine,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      message: map['message'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
      isMine: map['isMine'] as bool,
    );
  }
}
