import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
import 'package:gemini_chat_bloc/common/presentation/widgets/app/my_app.dart';
import 'package:gemini_chat_bloc/common/services/di_container/di_container.dart';
import 'package:gemini_chat_bloc/features/auth/bloc/authorization_bloc.dart';
import 'package:gemini_chat_bloc/features/auth/presentation/screens/auth_screen.dart';
import 'package:gemini_chat_bloc/features/first/bloc/init_screen_bloc.dart';
import 'package:gemini_chat_bloc/features/first/presentation/screens/home_screen.dart';
import 'package:gemini_chat_bloc/features/first/presentation/screens/init_screen.dart';
import 'package:go_router/go_router.dart';

enum MainRoutes { home, init, auth }

String mainRoutesName(MainRoutes name) => switch (name) {
      MainRoutes.init => 'InitScreen',
      MainRoutes.auth => 'AuthScreen',
      MainRoutes.home => 'HomeScreen',
    };

String mainRoutesPath(MainRoutes name) => switch (name) {
      MainRoutes.init => '/',
      MainRoutes.auth => '/auth_screen',
      MainRoutes.home => '/home_screen',
    };

class MainNavigation implements MyAppNavigation {
  final ScreenFactory screenFactory;

  MainNavigation({required this.screenFactory});

  @override
  RouterConfig<RouteMatchList> router() => GoRouter(
        initialLocation: mainRoutesPath(MainRoutes.auth),
        navigatorKey: navigatorKey,
        routes: <RouteBase>[
          GoRoute(
            name: mainRoutesName(MainRoutes.init),
            path: mainRoutesPath(MainRoutes.init),
            builder: (BuildContext context, GoRouterState state) {
              return screenFactory.makeInitPage();
            },
          ),
          GoRoute(
            name: mainRoutesName(MainRoutes.auth),
            path: mainRoutesPath(MainRoutes.auth),
            builder: (BuildContext context, GoRouterState state) {
              return screenFactory.makeAuthPage();
            },
          ),
          GoRoute(
            name: mainRoutesName(MainRoutes.home),
            path: mainRoutesPath(MainRoutes.home),
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
          ),
        ],
      );
}

class ScreenFactory {
  final DiContainer diContainer;

  ScreenFactory({required this.diContainer});

  Widget makeAuthPage() {
    return BlocProvider(
      create: (context) => AuthorizationBloc(
        firebaseAuthService: diContainer.makeFirebaseAuthService(),
      ),
      child: const AuthScreen(),
    );
  }

  Widget makeInitPage() {
    return BlocProvider(
      create: (context) => InitScreenBloc(),
      child:
          InitScreen(checkAuthorization: diContainer.makeCheckAuthorization()),
    );
  }

  // Widget makeHomePage() {
  //   return BlocProvider(
  //     create: (context) =>
  //         AuthorizationBloc(apiClient: diContainer.makeApiClient()),
  //     child: const HomeScreen(),
  //   );
  // }
}
