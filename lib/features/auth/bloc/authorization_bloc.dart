import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:gemini_chat_bloc/common/constants/constants.dart';
import 'package:gemini_chat_bloc/common/exceptions/firebase_exceptions.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_service.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthService _firebaseAuthService;
  late final StreamSubscription _userSubscription;
  Timer? userRefresh;

  AuthorizationBloc({
    required AuthService firebaseAuthService,
  })  : _firebaseAuthService = firebaseAuthService,
        super(
          AuthorizationInitial(),
        ) {
    on<EmailVerificationSuccessEvent>(_onEmailVerificationSuccessEvent);
    on<EmailAndPasswordSignUpEvent>(_onEmailAndPasswordSignUpEvent);
    on<MakeGoogleLoginEvent>(_onMakeGoogleLoginEvent);

    _firebaseAuthService.currentUser?.fbUserInstance?.reload();
    _userSubscription = userStream.listen(
      (User? user) {
        if (user != null && user.emailVerified) {
          add(EmailVerificationSuccessEvent());
          userRefresh?.cancel();
        }
      },
    );
  }

  void _onMakeGoogleLoginEvent(
    MakeGoogleLoginEvent event,
    Emitter<AuthorizationState> emit,
  ) async {
    try {
      emit(AuthorizationLoading());
      await _firebaseAuthService.loginWithGoogle();
      emit(GotSignUpState(text: 'google auth is done'));
    } catch (e) {
      print(e.toString());
    }
  }

  void _onEmailVerificationSuccessEvent(
      EmailVerificationSuccessEvent event, Emitter<AuthorizationState> emit) {
    emit(GotSignUpState(text: 'got auth'));
  }

  void _onEmailAndPasswordSignUpEvent(EmailAndPasswordSignUpEvent event,
      Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());

    try {
      await _firebaseAuthService.createUser(
        email: event.email,
        password: event.password,
      );
      await _firebaseAuthService.sendEmailVerification();
      emit(SendEmailVerificationState(
          text: "We've sent a verification code to your email."));

      userRefresh = Timer.periodic(
        const Duration(seconds: 7),
        (timer) => _firebaseAuthService.currentUser?.fbUserInstance?.reload(),
      );
    } on FirebaseException catch (error) {
      emit(ErrorState(text: exceptionTextReturner[error] ?? ''));
      talker.error(error.toString());
      //   //TODO need to add analitics
    }
  }

  Stream<User?> get userStream => FirebaseAuth.instance.userChanges();

  @override
  Future<void> close() async {
    _userSubscription.cancel();
    userRefresh?.cancel();
    super.close();
  }
}
