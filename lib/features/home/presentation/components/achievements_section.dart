import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

const _cardWidth = 130.0;
const _cardHeight = 100.0;
const _achievementsData = [
  {'title': 'Completed Training', 'count': '50+'},
  {'title': 'Assignments Submitted', 'count': '200+'},
  {'title': 'Sessions Conducted', 'count': '60+'},
];

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          achievementsHeaderText,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        SizedBox(
          height: _cardWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: cardPadding),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _getAllAchievements(context: context),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getAllAchievements({required BuildContext context}) {
    var listOfAllAchievements = <Widget>[];
    for (int i = 0; i < _achievementsData.length; i++) {
      listOfAllAchievements.add(_getAchievement(
        _achievementsData[i],
        context: context,
      ));
    }
    return listOfAllAchievements;
  }

  Widget _getAchievement(
    Map<String, String> achievement, {
    required BuildContext context,
  }) {
    final isLandscapeMode = MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
      width: isLandscapeMode ? (MediaQuery.of(context).size.width - 20) / 3 : null,
      height: _cardHeight,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(cardContentPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement['title']!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: appThemeColor,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                Text(
                  achievement['count']!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: appThemeColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
