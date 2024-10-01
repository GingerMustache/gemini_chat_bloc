import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_exceptions.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_service.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthService _googleAuthService;
  final AuthService _firebaseAuthService;
  late final StreamSubscription _userSubscription;

  Timer? userRefresh;

  AuthorizationBloc({
    required AuthService googleAuthService,
    required AuthService firebaseAuthService,
  })  : _googleAuthService = googleAuthService,
        _firebaseAuthService = firebaseAuthService,
        super(
          AuthorizationInitial(),
        ) {
    on<EmailVerificationSuccessEvent>(_onEmailVerificationSuccessEvent);
    on<EmailAndPasswordSignUpEvent>(_onEmailAndPasswordSignUpEvent);
    on<MakeGoogleAuthEvent>(_onMakeGoogleAuthEvent);

    _firebaseAuthService.currentUser?.userInstance?.reload();
    _userSubscription = userStream.listen(
      (User? user) {
        if (user != null && user.emailVerified) {
          add(EmailVerificationSuccessEvent());
          userRefresh?.cancel();
        }
      },
    );
  }

  void _onMakeGoogleAuthEvent(
    MakeGoogleAuthEvent event,
    Emitter<AuthorizationState> emit,
  ) async {
    try {
      emit(AuthorizationLoading());
      await _googleAuthService.logIn(email: '', password: 'password');
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
        (timer) => _firebaseAuthService.currentUser?.userInstance?.reload(),
      );
    } on EmailAlreadyInUseAuthExceptions catch (e) {
      //TODO errors need to add to logger or add to analitics
      emit(ErrorState(text: 'email already in use'));
    } on InvalidEmailAuthExceptions catch (e) {
      emit(ErrorState(text: 'invalid email'));
    } on WeakPasswordAuthExceptions catch (e) {
      emit(ErrorState(text: 'weak password'));
    } on GenericAuthExceptions catch (e) {
      emit(ErrorState(
          text: 'something went wrong, try later, or do your job body'));
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
