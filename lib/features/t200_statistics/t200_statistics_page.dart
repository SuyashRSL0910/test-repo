import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

import '../../core/utils/dart_utils.dart';
import '../../drawer/presentation/drawer_menu_page.dart';

class T200StatisticsPage extends StatefulWidget {
  const T200StatisticsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _T200StatisticsPage();
  }
}

class _T200StatisticsPage extends State<T200StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: appBar(),
        drawer: const DrawerMenuPage(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "${resourcePath}coming_soon.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
