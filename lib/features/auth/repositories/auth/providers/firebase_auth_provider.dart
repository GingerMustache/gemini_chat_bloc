import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;
import 'package:flutter/material.dart' show immutable;
import 'package:gemini_chat_bloc/common/exceptions/firebase_exceptions.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_provider.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_user.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;

@immutable
class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String userNotLoggedIn = 'user-not-logged-in';

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw firebaseExceptionReturner(userNotLoggedIn);
      }
    } on FirebaseAuthException catch (error) {
      throw firebaseExceptionReturner(error.code);
    } catch (_) {
      throw firebaseExceptionReturner(null);
    }
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
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw firebaseExceptionReturner(userNotLoggedIn);
      }
    } on FirebaseAuthException catch (error) {
      throw firebaseExceptionReturner(error.code);
    } catch (_) {
      throw firebaseExceptionReturner(null);
    }
  }

  @override
  Future<void> logOut() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } else {
      throw firebaseExceptionReturner(userNotLoggedIn);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw firebaseExceptionReturner(userNotLoggedIn);
    }
  }

  @override
  Future<AuthUser> loginWithGoogle() async {
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
}
