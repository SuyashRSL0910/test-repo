import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/backend_training/presentation/sections/enrollments/enrollments_section.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';

import '../../../domain/backend_training_enrollments_data.dart';

class EnrollmentsSeeMorePage extends StatefulWidget {

  final List<BackendTrainingEnrollmentsData> enrollments;

  const EnrollmentsSeeMorePage({super.key, required this.enrollments});

  @override
  State<EnrollmentsSeeMorePage> createState() => _EnrollmentsSeeMorePageState();
}

class _EnrollmentsSeeMorePageState extends State<EnrollmentsSeeMorePage> {
  late ScrollController _listViewScrollController;
  late ScrollController _gridViewScrollController;

  @override
  void initState() {
    super.initState();
    _listViewScrollController = ScrollController();
    _gridViewScrollController = ScrollController();
  }

  @override
  void dispose() {
    _listViewScrollController.dispose();
    _gridViewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortraitOrientation = isPortraitMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(yourEnrollmentsHeaderText),
        centerTitle: false,
      ),
      body: CustomLayoutBuilder(
        scrollController: isPortraitOrientation
            ? _listViewScrollController
            : _gridViewScrollController,
        sliverChildList: [
          isPortraitOrientation
              ? _buildVertical(widget.enrollments)
              : _buildHorizontal(widget.enrollments),
          verticalSpace(),
        ],
        refresh: () {
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isPortraitOrientation) {
            scrollToTop(_listViewScrollController);
          } else {
            scrollToTop(_gridViewScrollController);
          }
        },
        tooltip: scrollToTopText,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildHorizontal(List data) {
    return GridView.builder(
      shrinkWrap: true,
      controller: _gridViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildEnrollmentCard(
          title: data[index].topicName,
          link: data[index].classroomLink,
          context: context,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: enrollmentsCardHeight,
      ),
    );
  }

  Widget _buildVertical(List data) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _listViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            buildEnrollmentCard(
              title: data[index].topicName,
              link: data[index].classroomLink,
              context: context,
              seeMorePage: true,
            ),
            Divider(
              color: listDividerColor,
              thickness: listDividerThickness,
            ),
          ],
        );
      },
    );
  }
}
