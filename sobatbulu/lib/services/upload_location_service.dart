import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UploadLocationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadLocations() async {
    final check = await firestore.collection('location').get();

    if (check.docs.isNotEmpty) {
      print("Data sudah ada");
      return;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/locations.json',
    );

    final List data = json.decode(jsonString);

    for (var item in data) {
      await firestore.collection('location').add(item);
    }

    print("Upload selesai");
  }
}
