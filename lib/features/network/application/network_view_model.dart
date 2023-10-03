import 'package:flutter/cupertino.dart';

class NetworkViewModel extends ChangeNotifier {

  late bool _hasNetwork = false;
  bool get hasNetwork => _hasNetwork;

  void setNetwork(bool hasNetwork) {
    _hasNetwork = hasNetwork;

    notifyListeners();
  }
}
