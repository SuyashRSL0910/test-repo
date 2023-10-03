import 'dart:convert';
import 'package:home_page/analytics/domain/page_keys.dart';

class TrainingProgressSectionEventData {

  final String email;
  final String enquiryForTrainee;

  TrainingProgressSectionEventData({
    required this.email,
    required this.enquiryForTrainee,
  });

  String toJson() {
    Map<String, String> json = {};
    json['email'] = email;
    json['enquiryForTrainee'] = enquiryForTrainee;
    json['actionType'] = 'leads_data_check';
    json['pageKey'] = PageKeys.t200TrainingPage.name;

    return jsonEncode(json).toString();
  }
}
