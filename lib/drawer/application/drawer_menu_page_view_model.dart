import 'package:flutter/material.dart';

class DrawerMenuPageViewModel extends ChangeNotifier {

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  DrawerMenuPageViewModel();

  void setSelectedIndex(int index) {
    _selectedIndex = index;

    notifyListeners();
  }
}
