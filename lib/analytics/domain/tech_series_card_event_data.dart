import 'dart:convert';

class TechSeriesCardEventData {

  final String email;
  final String itemId;
  final String itemName;
  final String type;
  final String pageKey;

  TechSeriesCardEventData({
    required this.email,
    required this.itemId,
    required this.itemName,
    required this.type,
    required this.pageKey,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['itemId'] = itemId;
    json['itemName'] = itemName;
    json['type'] = type;
    json['pageKey'] = pageKey;

    return jsonEncode(json).toString();
  }
}
