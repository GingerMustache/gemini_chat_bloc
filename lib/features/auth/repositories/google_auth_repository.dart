import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider;
import 'package:flutter/material.dart' show immutable;
import 'package:flutter/widgets.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/auth_provider.dart';

@immutable
class AuthProviderGoogle implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> sendEmailVerification() {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    final googleUser = await _googleSignIn.signIn();

    // if (googleUser == null)
    //  return null;
    //TODO need to make error implementation, google user is null

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);

    return AuthUser(email: googleUser?.email, isEmailVerified: true);
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
