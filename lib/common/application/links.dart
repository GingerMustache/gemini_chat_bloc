part of "app_settings.dart";

String _base = '${dotenv.env['URL']}';

class BasePaths {
  static final base = _base;
  
  BasePaths._();
  static final BasePaths _instance = BasePaths._();
  factory BasePaths() => _instance;
}
