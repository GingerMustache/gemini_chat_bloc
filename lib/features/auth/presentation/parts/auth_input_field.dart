part of '../screens/auth_screen.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        enableSuggestions: isPassword ? false : true,
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          hintText: isPassword ? "Password" : 'Email',
        ),
        validator: (value) => isPassword ? null : _validateEmail(value),
        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        onChanged: (value) => value.replaceAll(' ', '').toLowerCase());
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || value.contains(' ')) {
      return 'field must not be empty';
    } else if (!EmailValidator.validate(value)) {
      return 'wrong email format';
    }
    return null;
  }
}
