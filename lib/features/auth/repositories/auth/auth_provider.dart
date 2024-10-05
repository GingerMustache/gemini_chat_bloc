import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_user.dart';

abstract class AuthProvider {
  // Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> loginWithGoogle();
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}
