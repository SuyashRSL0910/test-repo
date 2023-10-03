import 'package:flutter/material.dart';
import 'package:home_page/core/constants/colors.dart';
import 'package:home_page/core/constants/dimen.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/home/domain/upcoming_trainings_data.dart';
import 'package:home_page/features/t200_training/application/t200_training_service.dart';

const _cardHeight = 240.0;
const _cardWidth = 260.0;

class T200ScheduleSection extends StatefulWidget {
  const T200ScheduleSection({super.key});

  @override
  State<T200ScheduleSection> createState() => _T200ScheduleSectionState();
}

class _T200ScheduleSectionState extends State<T200ScheduleSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(height: sectionHeaderSpacingHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule_outlined, size: 26, weight: 10),
              const SizedBox(width: 5),
              sectionHeader(t200ScheduleHeader, context: context, addTextDecoration: true),
            ],
          ),
          verticalSpace(height: sectionHeaderSpacingHeight),
          CustomFutureBuilder<List<UpcomingTrainingsData>>(
            future: T200TrainingService().fetchUpcomingTrainingsData(),
            loader: loadingState(height: _cardHeight),
            errorReload: () {
              setState(() {});
            },
            emptyStateMessage: noUpcomingOngoingTrainingText,
            child: (data) {
              return SizedBox(
                height: _cardHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _getAllT200Schedule(data),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _getAllT200Schedule(List<UpcomingTrainingsData> data) {
    var listOfAllWidgets = <Widget>[];
    for (int i = 0; i < data.length; i++) {
      listOfAllWidgets.add(_getSchedule(data[i]));
    }
    return listOfAllWidgets;
  }

  Widget _getSchedule(UpcomingTrainingsData data) {
    return SizedBox(
      width: _cardWidth,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: _cardWidth,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: appThemeColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 20,
                            weight: 18,
                            color: Colors.white,
                            fill: 0.5),
                        const SizedBox(width: 10),
                        Text(
                          data.date.replaceFirst('Week ', ''),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: sectionHeader(
                  data.platformName,
                  context: context,
                  textAlign: TextAlign.start,
                ),
              ),
              const Divider(color: appThemeColor, indent: 10, endIndent: 10),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: sectionHeader(
                    whatYouWillLearnT200ScheduleText,
                    context: context,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _getAllScheduledTopics(data.topics),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getAllScheduledTopics(List<TrainingTopicData> topics) {
    var listOfAllWidgets = <Widget>[];
    for (int i = 0; i < topics.length; i++) {
      listOfAllWidgets.add(_getTopic(topics[i]));
    }
    return listOfAllWidgets;
  }

  Widget _getTopic(TrainingTopicData data) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          width: 200,
          height: 60,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.fromBorderSide(BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.check_rounded,
                  size: 25, color: appThemeColor, weight: 800),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.topic,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),);
  }
}
