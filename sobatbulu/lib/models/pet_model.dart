import 'dart:convert';

class PetModel {
  int? id;
  String nama;
  String ras;
  String jenis;
  int isFed;
  int isDrink;
  String umur;
  String ownerEmail;
  String? gambarPet;

  PetModel({
    this.id,
    required this.ras,
    required this.nama,
    required this.jenis,
    required this.ownerEmail,
    this.isFed = 0,
    this.isDrink = 0,
    required this.umur,
    this.gambarPet,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'isFed': isFed,
      'isDrink': isDrink,
      'ras': ras,
      'umur': umur,
      'ownerEmail': ownerEmail,
      'gambarPet': gambarPet,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      nama: map['nama'],
      ras: map['ras'] ?? '',
      jenis: map['jenis'],
      isFed: map['isFed'] ?? 0,
      isDrink: map['isDrink'] ?? 0,
      umur: map['umur'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      gambarPet: map['gambarPet'],
    );
  }
  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
