import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemini_chat_bloc/common/services/di_container/api_client/api_client.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final ApiClient apiClient;

  AuthorizationBloc({required this.apiClient}) : super(AuthorizationInitial()) {
    on<MakeAuthEvent>(_onMakeAuthEvent);
  }

  void _onMakeAuthEvent(
      MakeAuthEvent event, Emitter<AuthorizationState> emit) async {
    emit(AuthorizationLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthorizationLoaded(text: apiClient.text));
  }
}
