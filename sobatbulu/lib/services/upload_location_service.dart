import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UploadLocationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<int> uploadLocations() async {
    final check = await firestore.collection('location').get();

    if (check.docs.isNotEmpty) {
      return 0;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/location.json',
    );

    final List data = json.decode(jsonString);

    final WriteBatch batch = firestore.batch();

    for (var item in data) {
      final docRef = firestore.collection('location').doc();
      batch.set(docRef, Map<String, dynamic>.from(item));
    }

    await batch.commit();

    return data.length;
  }
}
