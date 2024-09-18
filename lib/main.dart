import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// need to run dart run build_runner build
import 'package:gemini_chat_bloc/common/localization/i18n/strings.g.dart';
import 'package:gemini_chat_bloc/common/services/di_container/di_container.dart';

import 'firebase_options.dart';

class BlocObservers extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print(bloc);
  }
}

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initApp();

      final DiContainerProvider diContainer = DiContainer();
      final app = diContainer.makeApp();

      runApp(TranslationProvider(child: app));
    },
    (error, stack) {},
  );
}

Future<void> initApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  Bloc.observer = BlocObservers();
}
