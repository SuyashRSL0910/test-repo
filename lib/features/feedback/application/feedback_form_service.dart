import 'package:flutter/material.dart';
import 'package:home_page/features/common/apps_script_helper.dart';
import 'package:home_page/features/feedback/domain/feedback_form_data.dart';

class FeedbackFormService {

  static const String params = '&data=';
  final FeedbackFormData _data;
  final AppsScriptHelper _appsScriptHelper = AppsScriptHelper();

  FeedbackFormService(this._data);

  void postFeedbackFormData(BuildContext context, Function(String) callback) {
    _appsScriptHelper.postFeedbackFormData(
      context,
      '$params${Uri.encodeComponent(_data.toJson())}',
      callback,
    );
  }
}
