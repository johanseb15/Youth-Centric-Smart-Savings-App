import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  static const _tokenKey = 'auth_token';
  static SharedPreferences? _prefs;
  static String? _token;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _token = _prefs!.getString(_tokenKey);
  }

  static bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  static String? get token => _token;

  static Future<void> setToken(String? token) async {
    _token = token;
    _prefs ??= await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await _prefs!.remove(_tokenKey);
    } else {
      await _prefs!.setString(_tokenKey, token);
    }
  }
}
