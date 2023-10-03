import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/tech_series_feedback_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/tech_series_data.dart';
import 'package:home_page/features/home/presentation/components/tech_series/common.dart';
import 'package:home_page/features/home/presentation/components/tech_series/tech_series_see_more_page.dart';

class TechSeriesSection extends StatefulWidget {
  const TechSeriesSection({super.key});

  @override
  State<TechSeriesSection> createState() => _TechSeriesSectionState();
}

class _TechSeriesSectionState extends State<TechSeriesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          techSeriesHeader,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        SizedBox(
          height: cardHeight,
          child: _getAllTechSeries(),
        ),
      ],
    );
  }

  Widget _getAllTechSeries() {
    return CustomFutureBuilder<List<TechSeriesData>>(
      future: HomeService().fetchTechSeriesData(),
      loader: loadingState(height: cardHeight),
      errorReload: () {
        setState(() {});
      },
      emptyStateMessage: noTechSeriesText,
      child: (data) {
        final argument = TechSeriesFeedbackPageArgument(
          techSeriesTitles: data.map((e) => e.title.toString()).toList(),
        );
        if (data.length > 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: cardPadding),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length > 5 ? 5 : data.length,
              itemBuilder: (context, index) {
                // show 4 tech series cards + 1 see more card on home screen
                if (index == 4) {
                  return _getSeeMoreWidget(context);
                }
                return getTechSeries(
                  data[index],
                  context: context,
                  argument: argument,
                  index: index,
                );
              },
            ),
          );
        } else {
          return getTechSeries(
            data.first,
            context: context,
            argument: argument,
            index: 0,
          );
        }
      },
    );
  }

  Widget _getSeeMoreWidget(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: '$TechSeriesSeeMorePage'),
                  builder: (context) => const TechSeriesSeeMorePage(),
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
        ],
      ),
    );
  }
}
