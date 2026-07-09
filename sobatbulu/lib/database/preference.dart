import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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
    await _secureStorage.deleteAll();
    print("LOGOUT DIPANGGIL");
    print("isLogin = ${_prefs.getBool(_keyIsLogin)}");
  }

  static Future<void> saveNama(String nama) async {
    await _secureStorage.write(key: 'nama', value: nama);
  }

  static Future<String> getNama() async {
    return await _secureStorage.read(key: 'nama') ?? '';
  }

  static Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: 'email', value: email);
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
    await _secureStorage.write(key: 'telepon_$email', value: telepon);
  }

  static Future<String> getTelepon(String email) async {
    return await _secureStorage.read(key: 'telepon_$email') ?? '';
  }

  static Future<String> getEmail() async {
    return await _secureStorage.read(key: 'email') ?? '';
  }
}
