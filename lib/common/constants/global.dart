part of 'constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    useHistory: true,
    maxHistoryItems: 100,
  ),
);
