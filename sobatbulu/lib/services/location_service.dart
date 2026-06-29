import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobatbulu_app/models/location.dart';

class LocationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<LocationModel>> getLocations() {
    return firestore.collection('location').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LocationModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}
