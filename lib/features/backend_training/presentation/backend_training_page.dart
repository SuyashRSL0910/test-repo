import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';
import 'package:home_page/features/backend_training/presentation/sections/enrollments/enrollments_section.dart';
import 'package:home_page/features/backend_training/presentation/sections/offered_courses/offered_courses_section.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';

class BackendTrainingPage extends StatefulWidget {
  const BackendTrainingPage({super.key});

  @override
  State<StatefulWidget> createState() => _BackendTrainingPageState();
}

class _BackendTrainingPageState extends State<BackendTrainingPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: appBar(),
        drawer: const DrawerMenuPage(),
        body: CustomLayoutBuilder(
          sliverChildList: [
            _buildLayout(),
            verticalSpace(),
          ],
          refresh: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}

Widget _buildLayout() {
  return Padding(
    padding: const EdgeInsets.all(cardPadding),
    child: Column(
      children: [
        const EnrollmentsSection(),
        verticalSpace(),
        const OfferedCoursesSection(),
      ],
    ),
  );
}
