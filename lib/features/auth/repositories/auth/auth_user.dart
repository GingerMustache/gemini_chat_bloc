import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  final User? userInstance;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    this.userInstance,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      email: user.email,
      isEmailVerified: user.emailVerified,
      userInstance: user,
    );
  }
}
