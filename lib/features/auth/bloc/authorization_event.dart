part of 'authorization_bloc.dart';

@immutable
sealed class AuthorizationEvent extends Equatable {}

class MakeGoogleLoginEvent extends AuthorizationEvent {
  @override
  List<Object?> get props => [];
}

class EmailAndPasswordSignUpEvent extends AuthorizationEvent {
  final String email;
  final String password;

  EmailAndPasswordSignUpEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class EmailVerificationSuccessEvent extends AuthorizationEvent {
  @override
  List<Object?> get props => [];
}

class ResendEmailVerificationEvent extends AuthorizationEvent {
  @override
  List<Object?> get props => [];
}
