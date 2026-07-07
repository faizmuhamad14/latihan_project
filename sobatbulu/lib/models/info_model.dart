class InfoModel {
  final String? id;
  final String title;
  final String deskripsi;
  final String gambar;
  final String kategori;

  InfoModel({
    this.id,
    required this.title,
    required this.deskripsi,
    required this.gambar,
    required this.kategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'kategori': kategori,
    };
  }

  factory InfoModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return InfoModel(
      id: id,
      title: map['title'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      gambar: map['gambar'] ?? 'assets/images/berita1.jpg',
      kategori: map['kategori'] ?? 'Artikel',
    );
  }
}
