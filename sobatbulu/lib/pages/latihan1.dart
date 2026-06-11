import 'package:flutter/material.dart';

class LatihanProject extends StatelessWidget {
  const LatihanProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(backgroundColor: Colors.brown, title: Text("PetCare")),
        body: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Row(
            children: [Container(height: 50, color: Colors.yellow, width: 50)],
          ),
        ),
      ),
    );
  }
}
