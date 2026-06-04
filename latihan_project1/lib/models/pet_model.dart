import 'dart:convert';

class PetModel {
  int? id;
  String nama;
  String jenis;

  PetModel({this.id, required this.nama, required this.jenis});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'jenis': jenis};
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(id: map['id'], nama: map['nama'], jenis: map['jenis']);
  }
  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
