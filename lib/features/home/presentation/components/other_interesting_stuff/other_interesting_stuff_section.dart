import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/interesting_things_data.dart';
import 'package:home_page/features/home/presentation/components/other_interesting_stuff/common.dart';
import 'package:home_page/features/home/presentation/components/other_interesting_stuff/other_interesting_stuff_see_more_page.dart';

const _cardWidth = 320.0;

class OtherInterestingStuffSection extends StatefulWidget {
  const OtherInterestingStuffSection({super.key});

  @override
  State<OtherInterestingStuffSection> createState() =>
      _OtherInterestingStuffSectionState();
}

class _OtherInterestingStuffSectionState
    extends State<OtherInterestingStuffSection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      sectionHeader(
        otherInterestingStuffHeader,
        context: context,
        addTextDecoration: true,
      ),
      verticalSpace(height: sectionHeaderSpacingHeight),
      SizedBox(height: _cardWidth, child: _getAllInterestingStuff())
    ]);
  }

  Widget _getAllInterestingStuff() {
    return CustomFutureBuilder<List<InterestingThingsData>>(
      future: HomeService().fetchInterestingThingsData(),
      loader: loadingState(),
      errorReload: () {
        setState(() {});
      },
      emptyStateMessage: noOtherInterestingStuffText,
      child: (data) {
        return Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length > 5 ? 5 : data.length,
            itemBuilder: (context, index) {
              // show 4 interesting stuff cards + 1 see more card on home screen
              if (index == 4) {
                return _getSeeMoreWidget(context);
              }
              return getInterestingStuff(data[index], context: context, index: index);
            },
          ),
        );
      },
    );
  }

  Widget _getSeeMoreWidget(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 310,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: RouteSettings(name: '$OtherInterestingStuffSeeMorePage'),
                builder: (context) => const OtherInterestingStuffSeeMorePage(),
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
                color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
