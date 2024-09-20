import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepositoryAbstract googleAuthRepository;
  final AuthRepositoryAbstract loginPasswordAuthRepository;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthorizationBloc({
    required this.googleAuthRepository,
    required this.loginPasswordAuthRepository,
  }) : super(AuthorizationInitial()) {
    on<MakeGoogleAuthEvent>(_onMakeAuthEvent);
    on<MakeLoginAndPasswordSignUpEvent>(_onMakeLoginAndPasswordSignUpEvent);
    on<GotSignUpEvent>(_onGotSigUp);
  }

  void _onMakeAuthEvent(
      MakeGoogleAuthEvent event, Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await Future.delayed(const Duration(seconds: 2));
  }

  void _onMakeLoginAndPasswordSignUpEvent(MakeLoginAndPasswordSignUpEvent event,
      Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await loginPasswordAuthRepository.signUp(event.email, event.password);
  }

  void _onGotSigUp(
      GotSignUpEvent event, Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoaded(text: "The user is SignUp"));
  }

  Stream<User?> get userStream => _firebaseAuth.authStateChanges();
}
