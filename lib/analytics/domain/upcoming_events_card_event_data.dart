import 'dart:convert';
import 'package:home_page/analytics/domain/page_keys.dart';

class UpcomingEventsCardEventData {

  final String email;
  final String eventName;
  final String type;

  UpcomingEventsCardEventData({
    required this.email,
    required this.eventName,
    required this.type,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['eventName'] = eventName;
    json['type'] = type;
    json['pageKey'] = PageKeys.homePage.name;

    return jsonEncode(json).toString();
  }
}
