import 'package:flutter/material.dart';
import 'package:sobatbulu_app/models/location.dart';
import 'package:sobatbulu_app/services/location_service.dart';
import 'package:sobatbulu_app/utils/map_launcher.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final service = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lokasi Petshop")),
      body: StreamBuilder<List<LocationModel>>(
        stream: service.getLocations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final locations = snapshot.data!;

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final lokasi = locations[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    openMap(lokasi.latitude, lokasi.longitude);
                  },
                  title: Text(lokasi.nama),
                  subtitle: Text(lokasi.alamat),
                  trailing: const Icon(Icons.location_on),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
