part of "app_settings.dart";

final whiteLarge = _getTextStyle(
  fontSize: 22.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final whiteMedium = _getTextStyle(
  fontSize: 18.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final whiteSmall = _getTextStyle(
  fontSize: 14.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final headlineLarge = _getTextStyleFromThema(
  fontSize: 32.0,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

final headlineMedium = _getTextStyleFromThema(
  fontSize: 16.0,
  color: AppColors.mainWhite,
);

final headlineSmall = _getTextStyleFromThema(
  fontSize: 14.0,
  color: AppColors.mainWhite,
);

final titleLarge = _getTextStyleFromThema(
  fontSize: 18.0,
  color: AppColors.mainGrey,
);

final titleMedium = _getTextStyleFromThema(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

final titleSmall = _getTextStyleFromThema(
  fontSize: 14.0,
  color: AppColors.mainGrey,
);

final errorStyle = _getTextStyleFromThema(
  fontSize: 14.0,
  color: AppColors.mainRed,
);

final bodyLarge = _getTextStyleFromThema(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

final bodyMedium = _getTextStyleFromThema(
  fontSize: 14.0,
  color: Colors.black,
);

final bodySmall = _getTextStyleFromThema(
  fontSize: 12.0,
  color: Colors.black,
);

TextStyle _getTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontFamily: 'Montserrat',
    color: color,
  );
}

TextStyle _getTextStyleFromThema({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color ?? Colors.black,
  );
}
