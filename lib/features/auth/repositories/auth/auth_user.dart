import 'package:firebase_auth/firebase_auth.dart' as fb show User;
import 'package:supabase_flutter/supabase_flutter.dart' as sb show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  final fb.User? fbUserInstance;
  final sb.User? sbUserInstance;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    this.fbUserInstance,
    this.sbUserInstance,
  });

  factory AuthUser.notVerified(String email) => AuthUser(
        email: email,
        isEmailVerified: false,
      );

  factory AuthUser.fromFirebase(fb.User user) {
    return AuthUser(
      email: user.email,
      isEmailVerified: user.emailVerified,
      fbUserInstance: user,
    );
  }

  factory AuthUser.fromSupaBase(sb.User user) {
    return AuthUser(
      email: user.email,
      isEmailVerified: false,
      sbUserInstance: user,
    );
  }
}
