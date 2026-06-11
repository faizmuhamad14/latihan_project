// import 'package:shared_preferences/shared_preferences.dart';

// class PreferenceHandler {
//   static late SharedPreferences _prefs;

//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   static const String _keyIsLogin = 'isLogin';

//   static Future<void> setLogin(bool value) async {
//     await _prefs.setBool(_keyIsLogin, value);
//   }

//   static bool get isLogin {
//     return _prefs.getBool(_keyIsLogin) ?? false;
//   }

//   static Future<void> logout() async {
//     await _prefs.remove(_keyIsLogin);
//     await _prefs.remove('nama');
//     print("LOGOUT DIPANGGIL");
//     print("isLogin = ${_prefs.getBool(_keyIsLogin)}");
//     print("nama = ${_prefs.getString('nama')}");
//   }
// }
