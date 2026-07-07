class ProdukPetshop {
  final String? id;
  final String nama;
  final String kategori;
  final int harga;
  final String gambar;
  final double rate;
  final String deskripsi;

  final List<String> jenisHewan;
  final List<String> umur;
  final List<String> ras;

  ProdukPetshop({
    this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.gambar,
    required this.rate,
    required this.jenisHewan,
    required this.umur,
    required this.ras,
    required this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'kategori': kategori,
      'harga': harga,
      'gambar': gambar,
      'rate': rate,
      'deskripsi': deskripsi,
      'jenisHewan': jenisHewan,
      'umur': umur,
      'ras': ras,
    };
  }

  factory ProdukPetshop.fromMap(Map<String, dynamic> map, {String? id}) {
    return ProdukPetshop(
      id: id,
      nama: map['nama'] ?? '',
      kategori: map['kategori'] ?? '',
      harga: (map['harga'] as num?)?.toInt() ?? 0,
      gambar: map['gambar'] ?? 'assets/images/boxicon.jpg',
      rate: (map['rate'] as num?)?.toDouble() ?? 4.5,
      jenisHewan: List<String>.from(map['jenisHewan'] ?? []),
      umur: List<String>.from(map['umur'] ?? []),
      ras: List<String>.from(map['ras'] ?? []),
      deskripsi: map['deskripsi'] ?? '',
    );
  }
}
