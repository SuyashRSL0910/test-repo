import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/enrollments_card_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/colors.dart';
import 'package:home_page/core/constants/dimen.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/common/access_token_helper.dart';
import 'package:home_page/features/t200_training/application/t200_training_service.dart';
import 'package:home_page/features/t200_training/domain/t200_training_enrollment_data.dart';
import 'package:provider/provider.dart';

const _cardWidth = 350.0;
const _cardHeight = 350.0;

class T200TrainingEnrollmentsSection extends StatefulWidget {
  const T200TrainingEnrollmentsSection({super.key});

  @override
  State<T200TrainingEnrollmentsSection> createState() => _T200TrainingEnrollmentsSectionState();
}

class _T200TrainingEnrollmentsSectionState extends State<T200TrainingEnrollmentsSection>
    with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(height: sectionHeaderSpacingHeight),
        sectionHeader(yourEnrollmentsHeader, context: context, addTextDecoration: true),
        verticalSpace(height: sectionHeaderSpacingHeight),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3.0,
          controller: tabController,
          labelColor: appThemeColor,
          labelStyle: Theme.of(context).textTheme.titleLarge,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: ongoingText),
            Tab(text: completedText),
          ],
        ),
        CustomFutureBuilder<String?>(
          future: AccessTokenHelper(context).getAccessToken(),
          loader: loadingState(height: _cardHeight),
          emptyStateMessage: emptyEnrollmentsText,
          errorReload: () {
            setState(() {});
          },
          child: (accessToken) {
            return _enrollmentsSection(accessToken);
          },
        ),
      ],
    );
  }

  Widget _enrollmentsSection(String? accessToken) {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    return CustomFutureBuilder<Map<String, List<T200TrainingEnrollmentData>>>(
      future: T200TrainingService().fetchUserEnrollmentsData(accessToken, userEmail),
      loader: loadingState(height: _cardHeight),
      emptyStateMessage: emptyEnrollmentsText,
      errorReload: () {
        setState(() {});
      },
      child: (data) {
        return SizedBox(
          height: _cardHeight,
          child: TabBarView(
            controller: tabController,
            children: [
              _buildTabWiseEnrollments(data, ongoingText),
              _buildTabWiseEnrollments(data, completedText),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabWiseEnrollments(
    Map<String, List<T200TrainingEnrollmentData>> data,
    String tab,
  ) {
    if (data[tab]!.isEmpty) {
      return _getEmptyCard();
    } else if (data[tab]!.length == 1) {
      return _getEnrollment(data[tab]![0], 0);
    } else {
      return ListView(
        scrollDirection: Axis.horizontal,
        children: _getEnrollments(data[tab]!),
      );
    }
  }

  List<Widget> _getEnrollments(List<T200TrainingEnrollmentData> enrollments) {
    List<Widget> widgets = [];
    for (int i = 0; i < enrollments.length; i++) {
      widgets.add(_getEnrollment(enrollments[i], i));
    }
    return widgets;
  }

  Widget _getEnrollment(T200TrainingEnrollmentData enrollmentsData, int index) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: _cardWidth,
        child: Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(cardContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionHeader(enrollmentsData.courseName, context: context),
                  verticalSpace(height: sectionHeaderSpacingHeight),
                  const Divider(
                    color: appThemeColor,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    height: 2,
                  ),
                  verticalSpace(height: sectionHeaderSpacingHeight),
                  Column(children: [
                    _getOverallProgress(avgScoreText(enrollmentsData.averageScore)),
                    _getOverallProgress(topicProgressText(
                        enrollmentsData.assignmentsCompleted,
                        enrollmentsData.totalAssignments)),
                    _getOverallProgress(overallProgressText(enrollmentsData.courseProgress))
                  ]),
                  verticalSpace(height: sectionHeaderSpacingHeight),
                  _buildProgressIndicator(enrollmentsData.courseProgress),
                  verticalSpace(height: sectionHeaderSpacingHeight),
                  _buildViewInClassroomButton(
                    enrollmentsData.link,
                    enrollmentsData.courseName,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOverallProgress(String progress) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const VerticalDivider(
            color: Colors.grey,
            thickness: 2,
            indent: 7,
            endIndent: 7,
          ),
          const Icon(Icons.check_rounded),
          Expanded(
            child: Text(
              progress,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String courseProgress) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10),),
              child: LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
                value: int.parse(courseProgress) / 100,
                backgroundColor: Colors.grey.shade400,
              ),
            ),
            Center(
              child: Text(
                progressText(courseProgress),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewInClassroomButton(String link, String courseName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        customLaunchUrl(link);

        // Fire tracking event
        AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
          component: Components.yourEnrollmentsSection,
          data: EnrollmentsCardEventData(
            email: FirebaseAuth.instance.currentUser!.email!,
            itemName: courseName,
            pageKey: PageKeys.t200TrainingPage.name,
          ).toJson(),
        );
      },
      child: Text(
        viewInClassroomText,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  Widget _getEmptyCard() => emptyState(emptyStateMessage: emptyEnrollmentsText);
}
