import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_bloc/common/application/app_settings.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
import 'package:gemini_chat_bloc/features/auth/bloc/authorization_bloc.dart';

enum _Field { email, password }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return switch (constraints.maxWidth) {
              final maxWidth when maxWidth < 600 => Body(
                  email: _email,
                  password: _password,
                  padding: 70,
                ),
              final maxWidth when maxWidth < 1200 => Body(
                  email: _email,
                  password: _password,
                  padding: 250,
                ),
              _ => Body(
                  email: _email,
                  password: _password,
                  padding: 400,
                ),
            };
          },
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body(
      {super.key,
      required TextEditingController email,
      required TextEditingController password,
      required this.padding})
      : _email = email,
        _password = password;

  final TextEditingController _email;
  final TextEditingController _password;
  final double padding;

  void signUp(BuildContext context) => context.read<AuthorizationBloc>().add(
        MakeLoginAndPasswordSignUpEvent(
          email: _email.text,
          password: _password.text,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textField(field: _Field.email, controller: _email),
          _textField(field: _Field.password, controller: _password),
          Space.h40,
          TextButton(
            onPressed: () => signUp(context),
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
                if (state is GotSignUpState) {
                  return Text(state.text);
                }
                return Text(
                  'sign up',
                  style: titleSmall,
                );
              },
            ),
          ),
          Space.h40,
          _loginWithGoogle(context),
        ],
      ),
    );
  }

  SizedBox _loginWithGoogle(BuildContext context) {
    return SizedBox(
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
            Text(
              'Login with Google',
              style: titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  TextField _textField({
    required _Field field,
    required TextEditingController controller,
  }) {
    return TextField(
        controller: controller,
        keyboardType: switch (field) {
          _Field.email => TextInputType.emailAddress,
          _Field.password => null,
        },
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: switch (field) {
            _Field.email => 'Email',
            _Field.password => "Password",
          },
        ));
  }
}
