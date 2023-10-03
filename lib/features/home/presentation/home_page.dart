import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/home/presentation/components/components.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: appBar(),
        drawer: const DrawerMenuPage(),
        body: CustomLayoutBuilder(
          sliverChildList: [
            const WelcomeSection(),
            verticalSpace(),
            const UpcomingEventsSection(),
            verticalSpace(),
            const UpcomingOngoingTrainingSection(),
            verticalSpace(),
            const TechSeriesSection(),
            verticalSpace(),
            const T200AvailableClassesSection(),
            verticalSpace(),
            const NewslettersSection(),
            verticalSpace(),
            const PlatformTrainingSection(),
            verticalSpace(),
            const OtherInterestingStuffSection(),
            verticalSpace(),
            const AchievementsSection(),
            verticalSpace(),
          ],
          refresh: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(exitAppAlertTitleText),
            content: const Text(exitAppAlertContentText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(exitAppAlertNoText),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(exitAppAlertYesText),
              ),
            ],
          )
      ) ?? false
    );
  }
}
