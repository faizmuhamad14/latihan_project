import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _keyIsLogin = 'isLogin';

  static Future<void> setLogin(bool value) async {
    await _prefs.setBool(_keyIsLogin, value);
  }

  static bool get isLogin {
    return _prefs.getBool(_keyIsLogin) ?? false;
  }

  static Future<void> logout() async {
    await _prefs.remove(_keyIsLogin);
    await _prefs.remove('nama');
    print("LOGOUT DIPANGGIL");
    print("isLogin = ${_prefs.getBool(_keyIsLogin)}");
    print("nama = ${_prefs.getString('nama')}");
  }

  static Future<void> saveNama(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', nama);
  }

  static Future<String> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama') ?? '';
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static Future<void> saveProfileImage(String email, String path) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_image_$email', path);
  }

  static Future<String?> getProfileImage(String email) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('profile_image_$email');
  }

  static Future<void> saveTelepon(String email, String telepon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('telepon_$email', telepon);
  }

  static Future<String> getTelepon(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('telepon_$email') ?? '';
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
}
