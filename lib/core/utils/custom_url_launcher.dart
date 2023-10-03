import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

void customLaunchUrl(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Error while opening the resource link!');
  }
}
