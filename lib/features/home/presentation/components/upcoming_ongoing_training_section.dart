import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/upcoming_trainings_data.dart';

const _cardHeight = 350.0;
const _cardDateSectionHeight = 40.0;
const _cardContentHeight = _cardHeight -
    _cardDateSectionHeight -
    cardContentPadding * 2 -
    cardPadding * 2;
const dividers = 1;
const _cardTopicsContentHeight = 200.0;

class UpcomingOngoingTrainingSection extends StatefulWidget {
  const UpcomingOngoingTrainingSection({super.key});

  @override
  State<UpcomingOngoingTrainingSection> createState() =>
      _UpcomingOngoingTrainingSectionState();
}

class _UpcomingOngoingTrainingSectionState
    extends State<UpcomingOngoingTrainingSection> {

  ScrollController? topicController;

  @override
  void initState() {
    super.initState();
    topicController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          upcomingOngoingTrainingHeaderText,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder<List<UpcomingTrainingsData>>(
          future: HomeService().fetchUpcomingTrainingsData(),
          loader: loadingState(height: _cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noUpcomingOngoingTrainingText,
          child: (data) {
            if (data.length > 1) {
              return SizedBox(
                height: _cardHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: cardPadding),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _getAllUpcomingEvents(data),
                  ),
                ),
              );
            } else {
              return _getUpcomingOngoingTraining(data.first);
            }
          },
        ),
      ],
    );
  }

  List<Widget> _getAllUpcomingEvents(List<UpcomingTrainingsData> data) {
    List<Widget> upcomingEventsList = [];
    for (int i = 0; i < data.length; i++) {
      upcomingEventsList.add(_getUpcomingOngoingTraining(data[i]));
    }
    return upcomingEventsList;
  }

  Widget _getUpcomingOngoingTraining(UpcomingTrainingsData data) {
    return SizedBox(
      width: cardWidth,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: _cardDateSectionHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardRadius),
                  color: appThemeColor,
                ),
                child: Text(
                  data.date.replaceFirst('Week ', ''),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(cardContentPadding),
                child: SizedBox(
                  height: _cardContentHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      sectionHeader(data.platformName, context: context),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      sectionDivider(),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(topicsText, context: context),
                          _getAllTopics(data.topics),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAllTopics(List<TrainingTopicData> data) {
    List<Widget> topicList = [];
    for (int i = 0; i < data.length; i++) {
      topicList.add(_getTopic(data[i].topic));
    }

    return SizedBox(
      height: _cardTopicsContentHeight,
      child: Scrollbar(controller: topicController,
          child: ListView(controller: topicController, children: topicList)),
    );
  }

  Widget _getTopic(String topic) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('-', style: Theme.of(context).textTheme.bodyMedium),
        horizontalSpace(width: 5),
        Expanded(
          child: Text(
            topic,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
