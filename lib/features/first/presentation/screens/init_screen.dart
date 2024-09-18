import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gemini_chat_bloc/common/application/app_settings.dart';
import 'package:gemini_chat_bloc/common/routing/routes.dart';

abstract interface class CheckAuthorization {
  Future<bool> isAuth();
}

class CheckAuthorizationDefault implements CheckAuthorization {
  @override
  Future<bool> isAuth() async => true;
}

class InitScreen extends StatefulWidget {
  const InitScreen({super.key, required this.checkAuthorization});
  final CheckAuthorization checkAuthorization;

  @override
  InitScreenState createState() => InitScreenState();
}

class InitScreenState extends State<InitScreen> {
  late Future<bool> _data;

  InitScreenState();

  @override
  void initState() {
    super.initState();
    _data = widget.checkAuthorization.isAuth();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: _data.then((value) {
          value
              ? context.goNamed(mainRoutesName(MainRoutes.home))
              : print('need to implement SignInScreen');
          return true;
        }),
        builder: (context, AsyncSnapshot<bool> snapshot) => Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
              color: AppColors.mainBlack,
            )),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
}
