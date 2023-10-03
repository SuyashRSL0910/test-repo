import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/newsletter_data.dart';
import 'package:home_page/features/home/presentation/components/newsletters/common.dart';

class NewslettersSeeMorePage extends StatefulWidget {
  const NewslettersSeeMorePage({super.key, required this.selectedTab});

  final int selectedTab;

  @override
  State<NewslettersSeeMorePage> createState() => _NewslettersSeeMorePageState();
}

class _NewslettersSeeMorePageState extends State<NewslettersSeeMorePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortraitOrientation = isPortraitMode(context);
    return DefaultTabController(
      initialIndex: widget.selectedTab,
      length: numOfTabs,
      child: Scaffold(
        body: _buildNewsletters(isPortraitMode: isPortraitOrientation),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scrollToTop(_scrollController);
          },
          tooltip: scrollToTopText,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }

  Widget _buildNewsletters({bool isPortraitMode = true}) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: const Text(newsletterSectionHeader),
              pinned: true,
              floating: true,
              centerTitle: false,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                labelColor: appThemeColor,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: androidPlatformText),
                  Tab(text: iOSPlatformText),
                  Tab(text: webPlatformText),
                ],
              ),
            ),
          ),
        ];
      },
      body: CustomFutureBuilder<Map<String, List<NewsLetterData>>>(
        future: HomeService().fetchNewslettersData(),
        loader: loadingState(height: cardHeight),
        errorReload: () {
          setState(() {});
        },
        emptyStateMessage: noNewslettersText,
        child: (data) {
          return TabBarView(
            children: _setupTabBarViewContents(
              data,
              context,
              isPortraitMode: isPortraitMode,
            ),
          );
        },
      ),
    );
  }
}

List<Widget> _setupTabBarViewContents(
  Map<String, List<NewsLetterData>> data,
  BuildContext context,{
  required bool isPortraitMode,
}) {
  List<Widget> widgets = List<Widget>.generate(
    numOfTabs,
    (index) => Container(),
  );
  data.forEach((key, value) {
    switch (key) {
      case 'android':
        widgets[0] = isPortraitMode
            ? _getListViewForNewsLetter(
                key,
                value,
                context,
              )
            : _getGridViewForNewsLetter(
                key,
                value,
                context,
              );
      case 'ios':
        widgets[1] = isPortraitMode
            ? _getListViewForNewsLetter(
                key,
                value,
                context,
              )
            : _getGridViewForNewsLetter(
                key,
                value,
                context,
              );
      case 'web':
        widgets[2] = isPortraitMode
            ? _getListViewForNewsLetter(
                key,
                value,
                context,
              )
            : _getGridViewForNewsLetter(
                key,
                value,
                context,
              );
    }
  });
  return widgets;
}

Widget _getListViewForNewsLetter(
  String key,
  List<NewsLetterData> data,
  BuildContext context,
) {
  return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(key),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: data.length,
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          color: listDividerColor,
                          height: listDividerThickness,
                        ),
                        getNewsletters(
                          data[index],
                          seeMorePage: true,
                          context: context,
                          index: index,
                        ),
                        if (index == data.length - 1)
                          Container(
                            color: listDividerColor,
                            height: listDividerThickness,
                          ),
                      ],
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: verticalSpace()),
              SliverFillRemaining(hasScrollBody: false, child: footer),
            ],
          );
        },
      ));
}

Widget _getGridViewForNewsLetter(
  String key,
  List<NewsLetterData> data,
  BuildContext context,
) {
  return SafeArea(
    top: false,
    bottom: false,
    child: Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>(key),
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: cardHeight,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return getNewsletters(
                  data[index],
                  context: context,
                  index: index,
                );
              },
            ),
            SliverToBoxAdapter(child: verticalSpace()),
            SliverFillRemaining(hasScrollBody: false, child: footer),
          ],
        );
      },
    ),
  );
}
