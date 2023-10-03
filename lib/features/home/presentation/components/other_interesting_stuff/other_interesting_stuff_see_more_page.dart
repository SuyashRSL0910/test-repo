import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/interesting_things_data.dart';
import 'package:home_page/features/home/presentation/components/other_interesting_stuff/common.dart';

class OtherInterestingStuffSeeMorePage extends StatefulWidget {
  const OtherInterestingStuffSeeMorePage({super.key});

  @override
  State<OtherInterestingStuffSeeMorePage> createState() =>
      _OtherInterestingStuffSeeMorePageState();
}

class _OtherInterestingStuffSeeMorePageState
    extends State<OtherInterestingStuffSeeMorePage> {
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
        title: const Text(otherInterestingStuffHeader),
        centerTitle: false,
      ),
      body: CustomLayoutBuilder(
        scrollController: isPortraitMode
            ? _listViewScrollController
            : _gridViewScrollController,
        sliverChildList: [
          CustomFutureBuilder<List<InterestingThingsData>>(
            future: HomeService().fetchInterestingThingsData(),
            loader: loadingState(),
            errorReload: () {
              setState(() {});
            },
            emptyStateMessage: noOtherInterestingStuffText,
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

  Widget _buildHorizontal(List<InterestingThingsData> data) {
    return GridView.builder(
      shrinkWrap: true,
      controller: _gridViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return getInterestingStuff(data[index], context: context, index: index);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 320,
      ),
    );
  }

  Widget _buildVertical(List<InterestingThingsData> data) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _listViewScrollController,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            getInterestingStuff(
              data[index],
              seeMorePage: true,
              context: context,
              index: index,
            ),
            Divider(color: listDividerColor, thickness: listDividerThickness),
          ],
        );
      },
    );
  }
}
