import 'package:flutter/material.dart';

class BeritaPage extends StatelessWidget {
  const BeritaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Selamat datang di ruang informasi eksklusif untuk para pawrents! Memelihara anjing dan kucing tentu bukan sekadar rutinitas memberi makan, tetapi juga tentang memahami keunikan dan cara terbaik untuk membahagiakan mereka.",
            ),
          ],
        ),
      ),
    );
  }
}
