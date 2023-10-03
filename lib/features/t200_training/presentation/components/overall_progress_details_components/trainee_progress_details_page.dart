import 'package:flutter/material.dart';
import 'package:home_page/core/constants/colors.dart';
import 'package:home_page/core/constants/dimen.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';

class TraineeProgressDetails extends StatefulWidget {
  final TraineeProgressData trainee;

  const TraineeProgressDetails({super.key, required this.trainee});

  @override
  State<TraineeProgressDetails> createState() => _TraineeProgressDetailsState();
}

class _TraineeProgressDetailsState extends State<TraineeProgressDetails> {
  ScrollController? traineeMarksGradeController;
  late TraineeProgressData trainee;
  late double traineeTopicsContainerHeightRatio;

  @override
  void initState() {
    super.initState();

    trainee = widget.trainee;
    traineeMarksGradeController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(traineeProgressDetailsHeaderText),
        centerTitle: false,
      ),
      body: CustomLayoutBuilder(
        sliverChildList: [
          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                _getSectionHeader(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                _getTopicProgressSection(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                _getLeadSection(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                _getAvgScoreSection(),
                verticalSpace(),
              ],
            ),
          ),
        ],
        refresh: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _getSectionHeader() {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: showingDataForLabelText,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextSpan(text: trainee.traineeName)
      ]),
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 2,
    );
  }

  Widget _getTopicProgressSection() {
    return Container(
      decoration: _cardDecoration(Colors.deepPurpleAccent),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${trainee.topics.length}",
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    verticalSpace(height: 5),
                    Text(
                      trainee.topics.length == 1
                          ? topicCompletedText
                          : topicsCompletedText,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ),
                  ],
                ),
                const Icon(Icons.list, size: 40),
              ],
            ),
          ),
          Visibility(
            visible: trainee.topics.isNotEmpty,
            child: const Divider(color: appThemeColor, thickness: 1.2, height: 1.2),
          ),
          SizedBox(
            height: _calculateTopicProgressSectionHeight(),
            child: Scrollbar(
              thickness: 5,
              radius: const Radius.circular(10),
              thumbVisibility: true,
              interactive: true,
              controller: traineeMarksGradeController,
              child: ListView.builder(
                controller: traineeMarksGradeController,
                shrinkWrap: true,
                itemCount: trainee.topics.length,
                itemBuilder: (context, index) {
                  var topic = trainee.topics[index];
                  final topicName = topic.topicName;
                  final marks = topic.topicMarks;
                  final grade = topic.grade;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "-  $topicName - $marks ($grade)",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLeadSection() {
    return Container(
      decoration: _cardDecoration(appThemeColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainee.leadName!,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                ),
                verticalSpace(height: 5),
                Text(
                  leadNameText,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                ),
              ],
            ),
            const Icon(Icons.person, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _getAvgScoreSection() {
    return Container(
      decoration: _cardDecoration(Colors.orangeAccent),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${trainee.avgScore.toStringAsFixed(2)}%",
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                ),
                verticalSpace(height: 5),
                Text(
                  overallAvgScoreText,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                ),
              ],
            ),
            const Icon(Icons.star_half, size: 40),
          ],
        ),
      ),
    );
  }

  Decoration _cardDecoration(Color borderColor) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade600,
          offset: const Offset(5.0, 5.0),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
      color: Colors.white,
      border: Border(left: BorderSide(color: borderColor, width: 20)),
    );
  }

  double _calculateTopicProgressSectionHeight() {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * _getTraineeTopicsContainerHeight()
        : MediaQuery.of(context).size.width * _getTraineeTopicsContainerHeight();
  }

  double _getTraineeTopicsContainerHeight() {
    return trainee.topics.length > 5 ? 0.2 : trainee.topics.length * 0.07;
  }
}
