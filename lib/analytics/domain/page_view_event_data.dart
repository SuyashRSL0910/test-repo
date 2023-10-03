import 'dart:convert';

class PageViewEventData {

  final String email;
  final String pageKey;

  PageViewEventData({required this.pageKey, required this.email});

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['pageKey'] = pageKey;

    return jsonEncode(json).toString();
  }
}
