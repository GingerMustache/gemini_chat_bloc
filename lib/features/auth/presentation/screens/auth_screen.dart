import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_bloc/common/application/app_settings.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
import 'package:gemini_chat_bloc/common/routing/routes.dart';
import 'package:gemini_chat_bloc/features/auth/bloc/authorization_bloc.dart';
import 'package:go_router/go_router.dart';

part '../parts/auth_input_field.dart';

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
                  formKey: formKey,
                  email: _email,
                  password: _password,
                  padding: 70,
                ),
              final maxWidth when maxWidth < 1200 => Body(
                  formKey: formKey,
                  email: _email,
                  password: _password,
                  padding: 250,
                ),
              _ => Body(
                  formKey: formKey,
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
  const Body({
    super.key,
    required TextEditingController email,
    required GlobalKey<FormState> formKey,
    required TextEditingController password,
    required this.padding,
  })  : _email = email,
        _password = password,
        _formKey = formKey;

  final TextEditingController _email;
  final TextEditingController _password;
  final GlobalKey<FormState> _formKey;
  final double padding;

  void signUp(BuildContext context) => _formKey.currentState!.validate()
      ? context.read<AuthorizationBloc>().add(
            EmailAndPasswordSignUpEvent(
              email: _email.text,
              password: _password.text,
            ),
          )
      : {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthInputField(controller: _email, isPassword: false),
          AuthInputField(controller: _password, isPassword: true),
          Space.h40,
          TextButton(
            onPressed: () => signUp(context),
            child: BlocConsumer<AuthorizationBloc, AuthorizationState>(
              listenWhen: (previous, current) => current is GotSignUpState,
              listener: (context, state) {
                context.goNamed(mainRoutesName(MainRoutes.home));
              },
              builder: (context, state) {
                if (state is AuthorizationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SendEmailVerificationState) {
                  return Text(state.text);
                }
                if (state is GotSignUpState) {
                  return Text(state.text);
                }
                if (state is ErrorState) {
                  return Column(
                    children: [
                      Text(
                        state.text,
                        style: errorStyle,
                      ),
                      Space.h10,
                      Text(
                        'sign up',
                        style: titleSmall,
                      ),
                    ],
                  );
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
        onPressed: () =>
            context.read<AuthorizationBloc>().add(MakeGoogleAuthEvent()),
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
}
