import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sobatbulu_app/models/info_model.dart';

class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream articles from Firestore
  Stream<List<InfoModel>> getArticles() {
    return _firestore.collection('articles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return InfoModel.fromMap(doc.data(), id: doc.id);
      }).toList();
    });
  }

  // Add a new article to Firestore
  Future<void> addArticle(InfoModel article) async {
    await _firestore.collection('articles').add(article.toMap());
  }

  // Update an article in Firestore
  Future<void> updateArticle(String id, InfoModel article) async {
    await _firestore.collection('articles').doc(id).update(article.toMap());
  }

  // Delete an article from Firestore
  Future<void> deleteArticle(String id) async {
    await _firestore.collection('articles').doc(id).delete();
  }
}
