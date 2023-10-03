import 'package:flutter/material.dart';
import 'package:home_page/features/common/apps_script_helper.dart';
import 'package:home_page/features/event_creation/domain/event_creation_form_data.dart';

class EventCreationFormService {

  static const String params = '&data=';
  final EventCreationFormData _data;
  final AppsScriptHelper _appsScriptHelper = AppsScriptHelper();

  EventCreationFormService(this._data);

  void postEventFormData(BuildContext context, Function(String) callback) {
    _appsScriptHelper.postEventCreationFormData(
      context,
      '$params${_data.toJson()}',
      callback,
    );
  }
}
