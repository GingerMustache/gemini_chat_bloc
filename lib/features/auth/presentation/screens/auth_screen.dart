import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
import 'package:gemini_chat_bloc/features/auth/bloc/authorization_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              TextField(
                  controller: _password,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password")),
              Space.h40,
              TextButton(
                onPressed: () {
                  context
                      .read<AuthorizationBloc>()
                      .add(MakeLoginAndPasswordSignUpEvent(
                        email: _email.text,
                        password: _password.text,
                      ));
                },
                child: BlocBuilder<AuthorizationBloc, AuthorizationState>(
                  builder: (context, state) {
                    if (state is AuthorizationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AuthorizationLoaded) {
                      return Text(state.text);
                    }
                    if (state is GotSignUpEvent) {
                      return const Text('got it');
                    }
                    return const Text(
                      'sign up',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Space.h40,
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () => context.read<AuthorizationBloc>().add(
                        ResendEmailVerificationEvent(),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/googlelogo.png',
                        fit: BoxFit.contain,
                        height: 20,
                      ),
                      Space.w10,
                      const Text(
                        'Login with Google',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
