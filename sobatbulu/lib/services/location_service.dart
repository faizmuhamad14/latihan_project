import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobatbulu_app/models/location.dart';

class LocationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream locations from Firestore
  Stream<List<LocationModel>> getLocations() {
    return firestore.collection('location').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LocationModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  // Add a new location
  Future<void> addLocation(Map<String, dynamic> data) async {
    await firestore.collection('location').add(data);
  }

  // Delete a location
  Future<void> deleteLocation(String id) async {
    await firestore.collection('location').doc(id).delete();
  }
}
