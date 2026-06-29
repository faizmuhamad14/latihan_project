class LocationModel {
  final String id;
  final String nama;
  final String alamat;
  final String telepon;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> layanan;

  LocationModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.layanan,
  });

  factory LocationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return LocationModel(
      id: id,
      nama: data['nama'],
      alamat: data['alamat'],
      telepon: data['telepon'],
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      rating: (data['rating'] as num).toDouble(),
      layanan: List<String>.from(data['layanan']),
    );
  }
}
