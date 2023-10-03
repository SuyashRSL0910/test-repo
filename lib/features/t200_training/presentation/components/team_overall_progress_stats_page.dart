import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/training_progress_section_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/colors.dart';
import 'package:home_page/core/constants/dimen.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';
import 'package:home_page/features/t200_training/presentation/components/training_progress_section.dart';
import 'package:provider/provider.dart';
import 'overall_progress_details_components/trainee_progress_details_page.dart';

class TeamOverallProgressStatsPage extends StatefulWidget {

  final List<TraineeProgressData> teamProgressDataModels;

  const TeamOverallProgressStatsPage({super.key, required this.teamProgressDataModels});

  @override
  State<StatefulWidget> createState() => _TeamOverallProgressStatsPageState();
}

class _TeamOverallProgressStatsPageState extends State<TeamOverallProgressStatsPage> {

  ScrollController? controller;
  List<TraineeProgressData> teamProgressData = [];

  @override
  void initState() {
    super.initState();

    controller = ScrollController();
    teamProgressData = widget.teamProgressDataModels;
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          sectionHeader(yourTeamProgressText, context: context, addTextDecoration: true),
          verticalSpace(height: sectionHeaderSpacingHeight),
          _getTeamUnderCurrentUser(),
          _getTeamAvgScoreSection(),
          _getTopPerformerSection()
        ],
      ),
    );
  }

  Widget _getTeamUnderCurrentUser() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: SizedBox(height: teamProgressData.length > 4 ? 4 * 65 : teamProgressData.length * 65,
        child: Card(
          shape: cardBorder(),
          elevation: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cardRadius),
            child: Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              controller: controller,
              interactive: true,
              child: ListView.builder(
                controller: controller,
                itemCount: teamProgressData.length,
                itemBuilder: (context, index) {
                  if (teamProgressData.isNotEmpty) {
                    final teamMember = teamProgressData[index];
                    Icon icon = getIconFromPlatformName(teamMember.platform);
                    return Padding(
                      padding: EdgeInsets.only(
                          top: (index == 0 ? 10 : 5),
                          bottom: (index == teamProgressData.length - 1 ? 10 : 5),
                          left: 10,
                          right: 10),
                      child: Container(
                        height: 50,
                        width: 300,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                        ),
                        child: ListTile(
                          title: Text(teamMember.traineeName,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1),
                          trailing: icon,
                          leading: const VerticalDivider(
                            color: appThemeColor,
                            thickness: 2,
                            endIndent: 5,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(name: '$TraineeProgressDetails'),
                                builder: (context) => TraineeProgressDetails(
                                  trainee: teamMember,
                                ),
                              ),
                            );

                            // Fire tracking event
                            AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                              component: Components.leadsTeamsProgressSection,
                              data: TrainingProgressSectionEventData(
                                email: FirebaseAuth.instance.currentUser!.email!,
                                enquiryForTrainee: teamMember.traineeName,
                              ).toJson(),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTeamAvgScoreSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 2)
            ],
            color: Colors.white,
            border: const Border(
              left: BorderSide(
                color: Colors.orangeAccent,
                width: 20,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _getTeamOverallProgressText("${_getTeamAverageScore().toStringAsFixed(2)}%",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _getTeamOverallProgressText(teamAvgScoreHeader),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2, right: 10),
                  child: Icon(Icons.star_half, size: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTopPerformerSection() {
    TraineeProgressData topPerformer = _getTopPerformer();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 2),
            ],
            color: Colors.white,
            border: const Border(
              left: BorderSide(
                color: appThemeColor,
                width: 20,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _getTeamOverallProgressText(topPerformer.traineeName),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _getTeamOverallProgressText(teamTopPerformerText),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _getTeamOverallProgressText(
                          "$overallAvgScoreText: ${topPerformer.avgScore.toStringAsFixed(2)}%"),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2, right: 10),
                  child: Icon(Icons.person, size: 40),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTeamOverallProgressText(String teamOverallProgressText) {
    return Text(teamOverallProgressText,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1);
  }

  double _getTeamAverageScore() {
    double totalAvgScore = 0;
    for (int i = 0; i < teamProgressData.length; i++) {
      totalAvgScore = teamProgressData[i].avgScore + totalAvgScore;
    }
    return totalAvgScore == 0 ? totalAvgScore : totalAvgScore / teamProgressData.length;
  }

  TraineeProgressData _getTopPerformer() {
    TraineeProgressData topPerformer = teamProgressData[0];
    for (int i = 1; i < teamProgressData.length; i++) {
      if (topPerformer.avgScore < teamProgressData[i].avgScore) {
        topPerformer = teamProgressData[i];
      }
    }

    return topPerformer;
  }
}
