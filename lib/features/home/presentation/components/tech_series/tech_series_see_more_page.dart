import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/tech_series_feedback_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/tech_series_data.dart';
import 'package:home_page/features/home/presentation/components/tech_series/common.dart';

class TechSeriesSeeMorePage extends StatefulWidget {
  const TechSeriesSeeMorePage({super.key});

  @override
  State<TechSeriesSeeMorePage> createState() => _TechSeriesSeeMorePageState();
}

class _TechSeriesSeeMorePageState extends State<TechSeriesSeeMorePage> {
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
    final isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text(techSeriesHeader),
        centerTitle: false,
      ),
      body: CustomLayoutBuilder(
        scrollController: isPortraitMode
            ? _listViewScrollController
            : _gridViewScrollController,
        sliverChildList: [
          CustomFutureBuilder<List<TechSeriesData>>(
            future: HomeService().fetchTechSeriesData(),
            loader: loadingState(),
            errorReload: () {
              setState(() {});
            },
            emptyStateMessage: noTechSeriesText,
            child: (data) {
              if (isPortraitMode) {
                return _buildVertical(data);
              } else {
                return _buildHorizontal(data);
              }
            },
          ),
          verticalSpace(),
        ],
        refresh: () {
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isPortraitMode) {
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

  Widget _buildHorizontal(List<TechSeriesData> data) {
    final argument = TechSeriesFeedbackPageArgument(
      techSeriesTitles: data.map((e) => e.title.toString()).toList(),
    );
    return GridView.builder(
      shrinkWrap: true,
      controller: _gridViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return getTechSeries(
          data[index],
          seeMorePage: false,
          context: context,
          argument: argument,
          index: index,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 340,
      ),
    );
  }

  Widget _buildVertical(List<TechSeriesData> data) {
    final argument = TechSeriesFeedbackPageArgument(
      techSeriesTitles: data.map((e) => e.title.toString()).toList(),
    );
    return ListView.builder(
      shrinkWrap: true,
      controller: _listViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            getTechSeries(
              data[index],
              seeMorePage: true,
              context: context,
              argument: argument,
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
