import 'dart:convert';
import 'package:home_page/analytics/domain/events.dart';

class EnrollmentsCardEventData {

  final String email;
  final String itemName;
  final String pageKey;

  EnrollmentsCardEventData({
    required this.email,
    required this.itemName,
    required this.pageKey,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['itemName'] = itemName;
    json['type'] = Events.viewInClassroomButton;
    json['pageKey'] = pageKey;

    return jsonEncode(json).toString();
  }
}
