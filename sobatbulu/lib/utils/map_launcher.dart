import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  final Uri url = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak dapat membuka Google';
  }
}
