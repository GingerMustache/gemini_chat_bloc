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
  late final Timer userRefresh;

  AuthorizationBloc({
    required this.googleAuthRepository,
    required this.loginPasswordAuthRepository,
    required this.authProvider,
  }) : super(AuthorizationInitial()) {
    on<MakeGoogleAuthEvent>(_onMakeAuthEvent);
    on<MakeLoginAndPasswordSignUpEvent>(_onMakeLoginAndPasswordSignUpEvent);
    on<ResendEmailVerificationEvent>(_onResendEmailVerificationEvent);
    on<GotSignUpEvent>(_onGotSignUpEvent);

    _userSubscription = userStream.listen(
      (User? user) {
        if (user != null && user.emailVerified) {
          add(GotSignUpEvent());
          userRefresh.cancel();
        }
      },
    );
  }

  void _onGotSignUpEvent(
      GotSignUpEvent event, Emitter<AuthorizationState> emit) {
    emit(GotSignUpState(text: 'got auth'));
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
    await authProvider.createUser(
      email: event.email,
      password: event.password,
    );

    await authProvider.sendEmailVerification();
    emit(AuthorizationLoaded(text: 'need to email verification '));
    userRefresh = Timer.periodic(
      const Duration(seconds: 7),
      (timer) => authProvider.currentUser?.userInstance?.reload(),
    );
  }

  Stream<User?> get userStream => _firebaseAuth.userChanges();

  @override
  Future<void> close() async {
    _userSubscription.cancel();
    super.close();
  }
}
