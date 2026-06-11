import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sobatbulu_app/constant/text_style.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(backgroundColor: Color(0xffffffff)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/work.json"),
          Text("Fitur ini sedang dalam pengerjaan", style: AppTextStyle.title),
        ],
      ),
    );
  }
}
