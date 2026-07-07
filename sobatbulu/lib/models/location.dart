class LocationModel {
  final String id;
  final String nama;
  final String alamat;
  final String telepon;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> layanan;
  final String? mapsUrl;

  LocationModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.layanan,
    this.mapsUrl,
  });

  factory LocationModel.fromFirestore(String id, Map<String, dynamic> data) {
    String? foundMapsUrl;
    for (var entry in data.entries) {
      final keyLower = entry.key.toLowerCase();
      if (keyLower == 'googlemapsurl' ||
          keyLower == 'google_maps_url' ||
          keyLower == 'googlemaps_url' ||
          keyLower == 'mapsurl' ||
          keyLower == 'maps_url' ||
          keyLower == 'mapurl' ||
          keyLower == 'map_url' ||
          keyLower == 'link' ||
          keyLower == 'url' ||
          (keyLower.contains('map') && keyLower.contains('url')) ||
          keyLower.contains('gmaps')) {
        if (entry.value != null && entry.value.toString().isNotEmpty) {
          foundMapsUrl = entry.value.toString();
          break;
        }
      }
    }

    return LocationModel(
      id: id,
      nama: data['nama'] ?? '',
      alamat: data['alamat'] ?? '',
      telepon: data['telepon'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 
                (data['lat'] as num?)?.toDouble() ?? 
                0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 
                 (data['longtitude'] as num?)?.toDouble() ?? 
                 (data['langitude'] as num?)?.toDouble() ?? 
                 (data['lng'] as num?)?.toDouble() ?? 
                 (data['long'] as num?)?.toDouble() ?? 
                 (data['lon'] as num?)?.toDouble() ?? 
                 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      layanan: List<String>.from(data['layanan'] ?? []),
      mapsUrl: foundMapsUrl,
    );
  }
}
