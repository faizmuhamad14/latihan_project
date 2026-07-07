import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobatbulu_app/models/model_data.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream products from Firestore
  Stream<List<ProdukPetshop>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProdukPetshop.fromMap(doc.data(), id: doc.id);
      }).toList();
    });
  }

  // Add a new product to Firestore
  Future<void> addProduct(ProdukPetshop product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  // Update a product in Firestore
  Future<void> updateProduct(String id, ProdukPetshop product) async {
    await _firestore.collection('products').doc(id).update(product.toMap());
  }

  // Delete a product from Firestore
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}
