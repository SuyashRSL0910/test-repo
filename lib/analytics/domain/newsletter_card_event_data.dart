import 'dart:convert';
import 'package:home_page/analytics/domain/events.dart';

class NewsletterCardEventData {

  final String email;
  final String itemId;
  final String itemName;
  final String pageKey;

  NewsletterCardEventData({
    required this.email,
    required this.itemId,
    required this.itemName,
    required this.pageKey,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['itemId'] = itemId;
    json['itemName'] = itemName;
    json['type'] = Events.viewNewsletterButton;
    json['pageKey'] = pageKey;

    return jsonEncode(json).toString();
  }
}
