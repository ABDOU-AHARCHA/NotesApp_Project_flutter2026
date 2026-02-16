import 'package:shared_preferences/shared_preferences.dart';

class GuestService {
  static const String _guestKey = 'is_guest';

  // Call this when user taps "Continue as Guest"
  static Future<void> setGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
  }

  // Returns true if user previously chose guest
  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestKey) ?? false;
  }

  // Call this when user signs out
  static Future<void> clearGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestKey);
  }
}