import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static Future<bool> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username.trim());
    await prefs.setBool(_keyIsLoggedIn, true);
    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'User';
  }
}
