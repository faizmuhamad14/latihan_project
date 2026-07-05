import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModelSQL {
  final String nama;
  final String email;
  final String password;
  final String kota;
  final String noTelp;

  UserModelSQL({
    required this.nama,
    required this.email,
    required this.password,
    required this.kota,
    this.noTelp = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'email': email,
      'password': password,
      'kota': kota,
      'noTelp': noTelp,
    };
  }

  factory UserModelSQL.fromMap(Map<String, dynamic> map) {
    return UserModelSQL(
      nama: map['nama'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      kota: map['kota'] ?? '',
      noTelp: map['noTelp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelSQL.fromJson(String source) =>
      UserModelSQL.fromMap(json.decode(source) as Map<String, dynamic>);
}
