import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Keys
  static const String USER_EMAIL_KEY = 'user_email';
  static const String IS_LOGGED_IN_KEY = 'is_logged_in';

  // Save user session
  static Future<bool> saveUserSession(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(IS_LOGGED_IN_KEY, true);
    await prefs.setString(USER_EMAIL_KEY, email);
    print('Session saved for user: $email');
    return true;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOGGED_IN_KEY) ?? false;
  }

  // Get logged in user email
  static Future<String?> getLoggedInUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL_KEY);
  }

  // Clear user session (logout)
  static Future<bool> clearUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(IS_LOGGED_IN_KEY, false);
    print('User session cleared');
    return true;
  }
}
