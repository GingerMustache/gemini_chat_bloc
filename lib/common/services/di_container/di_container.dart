import 'package:flutter/material.dart';
import 'package:gemini_chat_bloc/common/presentation/widgets/app/my_app.dart';
import 'package:gemini_chat_bloc/common/routing/routes.dart';
import 'package:gemini_chat_bloc/common/services/di_container/api_client/api_client.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/auth/auth_service.dart';
import 'package:gemini_chat_bloc/features/first/presentation/screens/init_screen.dart';

abstract class DiContainerProvider {
  Widget makeApp();
}

class DiContainer implements DiContainerProvider {
  ScreenFactory _makeScreenFactory() => ScreenFactory(diContainer: this);
  MyAppNavigation _makeRouter() =>
      MainNavigation(screenFactory: _makeScreenFactory());

  ApiClient makeApiClient() => ApiClient();
  // AuthService makeGoogleAuthService() => AuthService.google();
  // AuthService makeSupabaseAuthService() => AuthService.supabase();
  AuthService makeFirebaseAuthService() => AuthService.firebase();

  @override
  Widget makeApp() => MyApp(navigation: _makeRouter());
  CheckAuthorization makeCheckAuthorization() => CheckAuthorizationDefault();

  DiContainer();
}
