import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_bloc/features/auth/bloc/authorization_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context
                .read<AuthorizationBloc>()
                .add(TestStorageRepoEvent(text: "Test Storage")),
            child: const Text('tab'),
          ),
          TextButton(
            onPressed: () =>
                context.read<AuthorizationBloc>().add(MakeGoogleAuthEvent()),
            child: const Text('auth'),
          )
        ],
      ),
      body: Scaffold(
        body: Center(
          child: BlocBuilder<AuthorizationBloc, AuthorizationState>(
              builder: (context, state) => switch (state) {
                    AuthorizationLoading() => const CircularProgressIndicator(),
                    AuthorizationLoaded() => Text(state.text),
                    AuthorizationInitial() => const Text('Home Screen'),
                  }),
        ),
      ),
    );
  }
}
