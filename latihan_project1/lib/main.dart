import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:latihan_project1/database/preference.dart';
import 'package:latihan_project1/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(nama: ''),
    );
  }
}
