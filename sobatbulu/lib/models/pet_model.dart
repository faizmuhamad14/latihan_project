import 'dart:convert';

class PetModel {
  int? id;
  String nama;
  String ras;
  String jenis;
  String umur;
  String? gender;
  int? berat;
  String? tanggalLahir;
  String? tanggalAdop;
  String? catatan;
  String ownerEmail;
  String? gambarPet;

  PetModel({
    this.id,
    required this.ras,
    required this.nama,
    required this.jenis,
    required this.umur,
    this.gender,
    this.berat,
    this.tanggalLahir,
    this.tanggalAdop,
    this.catatan,
    required this.ownerEmail,

    this.gambarPet,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'ras': ras,
      'umur': umur,
      'ownerEmail': ownerEmail,
      'gambarPet': gambarPet,
      'gender': gender,
      'berat': berat,
      'tanggalLahir': tanggalLahir,
      'tanggalAdop': tanggalAdop,
      'catatan': catatan,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      nama: map['nama'],
      ras: map['ras'] ?? '',
      jenis: map['jenis'],
      umur: map['umur'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      gambarPet: map['gambarPet'],
      gender: map['gender'],
      berat: map['berat'],
      tanggalLahir: map['tanggalLahir'],
      tanggalAdop: map['tanggalAdop'],
      catatan: map['catatan'],
    );
  }
  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
