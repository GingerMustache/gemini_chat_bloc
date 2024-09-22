import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_provider.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepositoryAbstract googleAuthRepository;
  final AuthRepositoryAbstract loginPasswordAuthRepository;
  final AuthProvider authProvider;
  final _firebaseAuth = FirebaseAuth.instance;
  late final StreamSubscription _userSubscription;

  AuthorizationBloc({
    required this.googleAuthRepository,
    required this.loginPasswordAuthRepository,
    required this.authProvider,
  }) : super(AuthorizationInitial()) {
    on<MakeGoogleAuthEvent>(_onMakeAuthEvent);
    on<MakeLoginAndPasswordSignUpEvent>(_onMakeLoginAndPasswordSignUpEvent);
    on<ResendEmailVerificationEvent>(_onResendEmailVerificationEvent);

    // not work correct, need to test
    // make refresh button to user, when he sign up, push refresh, user signIn event go with email and password
    // and make sign in case in screen,
    _userSubscription = userStream.listen(
      (User? user) {
        user!.reload();
        if (user.emailVerified) {
          add(GotSignUpEvent());
        }
      },
    );
  }

  void _onMakeAuthEvent(
      MakeGoogleAuthEvent event, Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await Future.delayed(const Duration(seconds: 2));
  }

  void _onResendEmailVerificationEvent(ResendEmailVerificationEvent event,
      Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await authProvider.sendEmailVerification();
    emit(AuthorizationLoaded(text: 'resend verification'));
  }

  void _onMakeLoginAndPasswordSignUpEvent(MakeLoginAndPasswordSignUpEvent event,
      Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await authProvider.createUser(email: event.email, password: event.password);
    authProvider.currentUser;

    await authProvider.sendEmailVerification();

    emit(AuthorizationLoaded(text: "The user is SignUp"));
  }

  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  @override
  Future<void> close() async {
    _userSubscription.cancel();
    super.close();
  }
}
