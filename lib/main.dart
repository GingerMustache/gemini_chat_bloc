import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_chat_bloc/common/application/bloc_observer.dart';
import 'package:gemini_chat_bloc/common/constants/constants.dart';
// need to run dart run build_runner build
import 'package:gemini_chat_bloc/common/localization/i18n/strings.g.dart';
import 'package:gemini_chat_bloc/common/services/di_container/di_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initApp();

    final DiContainerProvider diContainer = DiContainer();
    final app = diContainer.makeApp();

    runApp(TranslationProvider(child: app));
  }, (Object error, StackTrace stack) {
    talker.handle(error, stack, 'Uncaught app exception');
  });
}

Future<void> initApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );

  Bloc.observer = const AppBlocObserver();
}
