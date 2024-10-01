part of 'authorization_bloc.dart';

@immutable
sealed class AuthorizationState extends Equatable {}

final class AuthorizationInitial extends AuthorizationState {
  @override
  List<Object?> get props => [];
}

final class AuthorizationLoading extends AuthorizationState {
  @override
  List<Object?> get props => [];
}

final class SendEmailVerificationState extends AuthorizationState {
  final String text;

  SendEmailVerificationState({required this.text});

  @override
  List<Object?> get props => [text];
}

final class GotSignUpState extends AuthorizationState {
  final String text;

  GotSignUpState({required this.text});

  @override
  List<Object?> get props => [text];
}
