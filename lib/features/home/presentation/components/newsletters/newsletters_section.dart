import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/newsletter_data.dart';
import 'package:home_page/features/home/presentation/components/newsletters/common.dart';
import 'package:home_page/features/home/presentation/components/newsletters/newsletters_see_more_page.dart';

class NewslettersSection extends StatefulWidget {
  const NewslettersSection({super.key});

  @override
  State<NewslettersSection> createState() => _NewslettersSectionState();
}

class _NewslettersSectionState extends State<NewslettersSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: numOfTabs);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          newsletterSectionHeader,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3.0,
          controller: _tabController,
          labelColor: appThemeColor,
          labelStyle: Theme.of(context).textTheme.titleLarge,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: androidPlatformText),
            Tab(text: iOSPlatformText),
            Tab(text: webPlatformText),
          ],
        ),
        CustomFutureBuilder<Map<String, List<NewsLetterData>>>(
          future: HomeService().fetchNewslettersData(),
          loader: loadingState(height: cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noNewslettersText,
          child: (data) {
            return SizedBox(
              height: cardHeight,
              child: TabBarView(
                controller: _tabController,
                children: _setupTabBarView(
                  data,
                  context,
                  _tabController.index,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

List<Widget> _setupTabBarView(
  Map<String, List<NewsLetterData>> data,
  BuildContext context,
  int selectedTab,
) {
  List<Widget> widgets = List<Widget>.generate(
    numOfTabs,
    (index) => Container(),
  );
  data.forEach((key, value) {
    switch (key) {
      case 'android':
        widgets[0] = _getListViewForNewsLetter(
          key,
          value,
          context,
          selectedTab,
        );
      case 'ios':
        widgets[1] = _getListViewForNewsLetter(
          key,
          value,
          context,
          selectedTab,
        );
      case 'web':
        widgets[2] = _getListViewForNewsLetter(
          key,
          value,
          context,
          selectedTab,
        );
    }
  });
  return widgets;
}

Widget _getListViewForNewsLetter(
  String key,
  List<NewsLetterData> data,
  BuildContext context,
  int selectedTab,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: cardPadding),
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (index < 4) {
          return getNewsletters(data[index], context: context, index: index);
        } else {
          return _getSeeMoreWidget(context, selectedTab);
        }
      },
    ),
  );
}

Widget _getSeeMoreWidget(BuildContext context, int selectedTab) {
  return SizedBox(
    width: 240,
    height: 310,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: RouteSettings(name: '$NewslettersSeeMorePage'),
                builder: (context) => NewslettersSeeMorePage(
                  selectedTab: selectedTab,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            shape: const StadiumBorder(),
          ),
          child: Text(
            seeMoreButtonText,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ),
  );
}
