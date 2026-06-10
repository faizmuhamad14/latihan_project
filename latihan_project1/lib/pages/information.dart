import 'package:flutter/material.dart';
import 'package:latihan_project1/data/list_model_berita.dart';
import 'package:latihan_project1/views/berita.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Informasi & Fakta Seru!"),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: infoBerita.length,
                itemBuilder: (context, index) {
                  final info = infoBerita[index];
                  return ListTile(
                    title: Text(info.title),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeritaPage(infoBerita: info),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
