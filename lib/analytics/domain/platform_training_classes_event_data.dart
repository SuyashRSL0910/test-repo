import 'dart:convert';
import 'package:home_page/analytics/domain/page_keys.dart';

class PlatformTrainingClassesEventData {

  final String email;
  final String classTitle;

  PlatformTrainingClassesEventData({
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
