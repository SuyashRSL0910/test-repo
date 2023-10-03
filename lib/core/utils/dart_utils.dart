import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/drawer/application/drawer_menu_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const _duration = 500;

bool isListNotNull(List? list) {
  return list != null && list.isNotEmpty && list.first != '';
}

bool isMapNotNull(Map? map) {
  return map != null &&
      map.isNotEmpty &&
      map.entries.isNotEmpty &&
      map.values.isNotEmpty;
}

void scrollToTop(ScrollController scrollController) {
  scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: _duration),
    curve: Curves.linear,
  );
}

Future<void> scrollToAWidget(GlobalKey key) async {
  final context = key.currentContext;
  if (context != null) {
    return Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: _duration),
      curve: Curves.linear,
    );
  }
}

String dateFormat(DateTime dateTime) {
  return DateFormat('MM/dd/yyyy').format(dateTime);
}

String? validateTextField(String? value) {
  if (value != null
      && value.isEmpty
      || value == eventDateInitialText
      || value == eventTimeInitialText) {
    return requiredErrorText;
  }
  return null;
}

bool isPortraitMode(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}

Future<bool> onWillPop(BuildContext context) async {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Provider.of<DrawerMenuPageViewModel>(context, listen: false).setSelectedIndex(0);
  return true;
}
