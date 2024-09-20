part of 'authorization_bloc.dart';

@immutable
sealed class AuthorizationEvent extends Equatable {}

class MakeGoogleAuthEvent extends AuthorizationEvent {
  @override
  List<Object?> get props => [];
}

class MakeLoginAndPasswordSignUpEvent extends AuthorizationEvent {
  final String email;
  final String password;

  MakeLoginAndPasswordSignUpEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class GotSignUpEvent extends AuthorizationEvent {
  @override
  List<Object?> get props => [];
}

class TestStorageRepoEvent extends AuthorizationEvent {
  final String text;

  TestStorageRepoEvent({required this.text});
  @override
  List<Object?> get props => [];
}
