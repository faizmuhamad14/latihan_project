class ProdukPetshop {
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
}
