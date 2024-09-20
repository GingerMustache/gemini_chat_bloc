import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthRepositoryAbstract {
  Future<Object?> signIn();
  Future<void> signUp(
    String emailAddress,
    String password,
  );
  Future<Object?> signInWithLoginAndPassword(
    String emailAddress,
    String password,
  );
  Future<void> signOut();
}

@immutable
class GoogleAuthRepository implements AuthRepositoryAbstract {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserCredential?> signIn() async {
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<Object?> signInWithLoginAndPassword(
    String emailAddress,
    String password,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<bool> signUp(
    String emailAddress,
    String password,
  ) {
    throw UnimplementedError();
  }
}

@immutable
class LoginPasswordAuthRepository implements AuthRepositoryAbstract {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential?> signInWithLoginAndPassword(
    String emailAddress,
    String password,
  ) async {
    late UserCredential credential;
    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return credential;
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();

  @override
  Future<void> signUp(String emailAddress, String password) async {
    // signUp
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Object?> signIn() {
    throw UnimplementedError();
  }
}
