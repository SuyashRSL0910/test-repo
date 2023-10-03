import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/backend_training/presentation/sections/offered_courses/offered_courses_section.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';

import '../../../domain/backend_training_data.dart';

const _cardHeight = 270.0;

class OfferedCoursesSeeMorePage extends StatefulWidget {

  final List<BackendTrainingData> backendTrainingData;

  const OfferedCoursesSeeMorePage({super.key, required this.backendTrainingData});

  @override
  State<OfferedCoursesSeeMorePage> createState() =>
      _OfferedCoursesSeeMorePageState();
}

class _OfferedCoursesSeeMorePageState extends State<OfferedCoursesSeeMorePage> {
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
        title: const Text(offeredCoursesHeaderText),
        centerTitle: false,
      ),
      body: CustomLayoutBuilder(
        scrollController: isPortraitOrientation
            ? _listViewScrollController
            : _gridViewScrollController,
        sliverChildList: [
          isPortraitOrientation
              ? _buildVertical(widget.backendTrainingData)
              : _buildHorizontal(widget.backendTrainingData),
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
        return buildOfferedCoursesCard(
          title: data[index].title,
          description: data[index].description,
          classroomState: data[index].classroomState,
          context: context,
          link: data[index].classroomLink,
          index: index,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: _cardHeight,
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
            buildOfferedCoursesCard(
              title: data[index].title,
              description: data[index].description,
              classroomState: data[index].classroomState,
              context: context,
              link: data[index].classroomLink,
              seeMorePage: true,
              index: index,
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
