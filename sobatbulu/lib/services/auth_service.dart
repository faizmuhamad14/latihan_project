import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sobatbulu_app/models/user_model_firebase.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Mendapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau perubahan status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============================================================
  // REGISTER
  // ============================================================
  Future<UserModelFirebase?> register({
    required String nama,
    required String email,
    required String password,
    required String kota,
  }) async {
    try {
      // Buat akun di Firebase Auth
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) return null;

      // Simpan data user ke Firestore
      final UserModelFirebase userModel = UserModelFirebase(
        uid: user.uid,
        nama: nama,
        email: email,
        kota: kota,
        createdAt: DateTime.now(),
        role: 'user',
      );

      await _usersCollection.doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================
  Future<UserModelFirebase?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) return null;

      // Ambil data user dari Firestore
      final userModel = await getUserByUid(user.uid);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // GET USER DATA
  // ============================================================
  Future<UserModelFirebase?> getUserByUid(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();

      if (doc.exists) {
        return UserModelFirebase.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getUserByUid: $e');
      return null;
    }
  }

  Future<UserModelFirebase?> getUserByEmail(String email) async {
    try {
      final query = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return UserModelFirebase.fromMap(
          query.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print('Error getUserByEmail: $e');
      return null;
    }
  }

  // ============================================================
  // UPDATE PROFILE (Nama, Kota)
  // ============================================================
  Future<bool> updateProfile({
    required String uid,
    String? nama,
    String? kota,
    String? telepon,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (nama != null) updates['nama'] = nama;
      if (kota != null) updates['kota'] = kota;
      if (telepon != null) updates['telepon'] = telepon;

      if (updates.isEmpty) return false;

      await _usersCollection.doc(uid).update(updates);
      return true;
    } catch (e) {
      print('Error updateProfile: $e');
      return false;
    }
  }

  // ============================================================
  // UPDATE EMAIL
  // ============================================================
  Future<bool> updateEmail({
    required String newEmail,
    required String uid,
  }) async {
    try {
      // Update di Firebase Auth
      await currentUser?.verifyBeforeUpdateEmail(newEmail);

      // Update di Firestore
      await _usersCollection.doc(uid).update({'email': newEmail});

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('Error updateEmail: $e');
      return false;
    }
  }

  // ============================================================
  // UPDATE PASSWORD
  // ============================================================
  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) return false;

      // Re-authenticate sebelum update password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('Error updatePassword: $e');
      return false;
    }
  }

  // ============================================================
  // RESET PASSWORD (via email)
  // ============================================================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============================================================
  // DELETE ACCOUNT
  // ============================================================
  Future<bool> deleteAccount(String password) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) return false;

      // Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Hapus data dari Firestore
      await _usersCollection.doc(user.uid).delete();

      // Hapus akun dari Firebase Auth
      await user.delete();

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('Error deleteAccount: $e');
      return false;
    }
  }

  // ============================================================
  // ERROR HANDLING
  // ============================================================
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter)';
      case 'user-not-found':
        return 'Akun tidak ditemukan';
      case 'wrong-password':
        return 'Kata sandi salah';
      case 'invalid-credential':
        return 'Email atau kata sandi salah';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'requires-recent-login':
        return 'Silakan login ulang untuk melakukan perubahan ini';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
