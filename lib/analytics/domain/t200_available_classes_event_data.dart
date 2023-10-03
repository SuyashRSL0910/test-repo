import 'dart:convert';
import 'package:home_page/analytics/domain/page_keys.dart';

class T200AvailableClassesEventData {

  final String email;
  final String classTitle;

  T200AvailableClassesEventData({
    required this.email,
    required this.classTitle,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['classTitle'] = classTitle;
    json['pageKey'] = PageKeys.homePage.name;

    return jsonEncode(json).toString();
  }
}
