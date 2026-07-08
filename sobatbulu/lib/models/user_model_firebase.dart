import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelFirebase {
  final String uid;
  final String nama;
  final String email;
  final String kota;
  final DateTime createdAt;
  final String role;
  final String telepon;

  UserModelFirebase({
    required this.uid,
    required this.nama,
    required this.email,
    required this.kota,
    required this.createdAt,
    this.role = 'user',
    this.telepon = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'nama': nama,
      'email': email,
      'kota': kota,
      'createdAt': createdAt,
      'role': role,
      'telepon': telepon,
    };
  }

  factory UserModelFirebase.fromMap(Map<String, dynamic> map) {
    return UserModelFirebase(
      uid: map['uid'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      email: map['email'] as String? ?? '',
      kota: map['kota'] as String? ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now(),
      role: map['role'] as String? ?? 'user',
      telepon: map['telepon'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelFirebase.fromJson(String source) =>
      UserModelFirebase.fromMap(json.decode(source) as Map<String, dynamic>);
}
