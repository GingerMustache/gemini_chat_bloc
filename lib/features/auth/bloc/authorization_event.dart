part of 'authorization_bloc.dart';

@immutable
sealed class AuthorizationEvent {}

class MakeAuthEvent extends AuthorizationEvent {}
