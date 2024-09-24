import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:gemini_chat_bloc/common/application/app_settings.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
// need to run 
// dart run build_runner build
// dart run slang
import 'package:gemini_chat_bloc/common/localization/i18n/strings.g.dart';

abstract class MyAppNavigation {
  RouterConfig<RouteMatchList> router();
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;

  const MyApp({
    super.key,
    required this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        useMaterial3: true,
        indicatorColor: AppColors.mainBlack,
        iconTheme: const IconThemeData(
          color: AppColors.mainBlack,
        ),
      ),
      routerConfig: navigation.router(),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
