// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' show immutable;

@immutable
class Message {
  final String id;
  final String message;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isMine;

  const Message({
    required this.id,
    required this.message,
    this.imageUrl,
    required this.createdAt,
    required this.isMine,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'imageUrl': imageUrl,
      'createAt': createdAt.millisecondsSinceEpoch,
      'isMine': isMine,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      message: map['message'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
      isMine: map['isMine'] as bool,
    );
  }

  Message copyWith({
    String? id,
    String? message,
    String? imageUrl,
    DateTime? createdAt,
    bool? isMine,
  }) {
    return Message(
      id: id ?? this.id,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
    );
  }
}
