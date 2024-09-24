part of "app_settings.dart";

class AppColors {
  static const Color mainWhite = Colors.white;
  static const Color mainBlack = Colors.black;
  static const Color mainGreen = Colors.green;
  static const Color mainBlue = Colors.blue;
  static const Color mainGrey = Colors.grey;
  static Color withAlpha = Colors.grey.withAlpha(30);

  AppColors._();
  static final AppColors _instance = AppColors._();
  factory AppColors() => _instance;
}
