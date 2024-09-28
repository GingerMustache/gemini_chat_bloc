import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_exceptions.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_provider.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepositoryAbstract googleAuthRepository;
  final AuthRepositoryAbstract loginPasswordAuthRepository;
  final AuthProvider authProvider;
  late final StreamSubscription _userSubscription;
  late final Timer userRefresh;

  AuthorizationBloc({
    required this.googleAuthRepository,
    required this.loginPasswordAuthRepository,
    required this.authProvider,
  }) : super(AuthorizationInitial()) {
    on<EmailVerificationSuccessEvent>(_onEmailVerificationSuccessEvent);
    on<EmailAndPasswordSignUpEvent>(_onEmailAndPasswordSignUpEvent);

    _userSubscription = userStream.listen(
      (User? user) {
        if (user != null && user.emailVerified) {
          add(EmailVerificationSuccessEvent());
          userRefresh.cancel();
        }
      },
    );
  }

  void _onEmailVerificationSuccessEvent(
      EmailVerificationSuccessEvent event, Emitter<AuthorizationState> emit) {
    emit(GotSignUpState(text: 'got auth'));
  }

  void _onEmailAndPasswordSignUpEvent(EmailAndPasswordSignUpEvent event,
      Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());

    try {
      await authProvider.createUser(
        email: event.email,
        password: event.password,
      );
      await authProvider.sendEmailVerification();
      emit(AuthorizationLoaded(
          text: "We've sent a verification code to your email."));

      userRefresh = Timer.periodic(
        const Duration(seconds: 7),
        (timer) => authProvider.currentUser?.userInstance?.reload(),
      );
    } on EmailAlreadyInUseAuthExceptions catch (e) {
      print(e.toString());
    } on InvalidEmailAuthExceptions catch (e) {
      print(e.toString());
    } on GenericAuthExceptions catch (e) {
      print(e.toString());
    }
  }

  Stream<User?> get userStream => FirebaseAuth.instance.userChanges();

  @override
  Future<void> close() async {
    _userSubscription.cancel();
    super.close();
  }
}
