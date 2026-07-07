import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(String mapsUrl) async {
  final Uri url = Uri.parse(mapsUrl);

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak dapat membuka Google Maps';
  }
}
