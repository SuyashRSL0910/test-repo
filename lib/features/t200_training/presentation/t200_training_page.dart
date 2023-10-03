import 'package:flutter/material.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/t200_training/presentation/components/t200_training_enrollments_section.dart';
import 'package:home_page/features/t200_training/presentation/components/training_progress_section.dart';
import 'package:home_page/features/t200_training/presentation/components/t200_schedule_section.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';

class T200TrainingPage extends StatefulWidget {
  const T200TrainingPage({super.key});

  @override
  State<StatefulWidget> createState() => _T200TrainingPageState();
}

class _T200TrainingPageState extends State<T200TrainingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: appBar(),
        drawer: const DrawerMenuPage(),
        body: CustomLayoutBuilder(
          sliverChildList: [
            const T200ScheduleSection(),
            verticalSpace(),
            const TrainingProgressSection(),
            verticalSpace(),
            const T200TrainingEnrollmentsSection(),
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
