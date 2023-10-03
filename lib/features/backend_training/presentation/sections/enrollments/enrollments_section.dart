import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/enrollments_card_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/backend_training/presentation/sections/common.dart';
import 'package:home_page/features/backend_training/presentation/sections/enrollments/enrollments_see_more_page.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/custom_future_builder.dart';
import '../../../../common/access_token_helper.dart';
import '../../../application/backend_training_service.dart';

const _cardWidth = 200.0;
const enrollmentsCardHeight = 170.0;

class EnrollmentsSection extends StatefulWidget {
  const EnrollmentsSection({super.key});

  @override
  State<StatefulWidget> createState() => _EnrollmentsSectionState();
}

class _EnrollmentsSectionState extends State<EnrollmentsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        verticalSpace(height: sectionHeaderSpacingHeight),
        sectionHeader(
          yourEnrollmentsHeaderText,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder<String?>(
          future: AccessTokenHelper(context).getAccessToken(),
          loader: loadingState(height: enrollmentsCardHeight),
          emptyStateMessage: noEnrolledCoursesText,
          errorReload: () {
            setState(() {});
          },
          child: (accessToken) {
            return _buildEnrollments(accessToken);
          },
        ),
      ],
    );
  }

  Widget _buildEnrollments(String? accessToken) {
    return CustomFutureBuilder(
      future: BackendTrainingService().fetchEnrolledBackendTrainingData(
          accessToken, FirebaseAuth.instance.currentUser!.email),
      loader: loadingState(height: enrollmentsCardHeight),
      errorReload: () {
        setState(() {});
      },
      emptyStateMessage: noEnrolledCoursesText,
      child: (enrollments) {
        return SizedBox(
          height: enrollmentsCardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: enrollments.length > 5 ? 5 : enrollments.length,
            itemBuilder: (context, index) {
              if (index == 4) {
                return buildSeeMoreButton(
                  width: _cardWidth,
                  context: context,
                  seeMorePage: EnrollmentsSeeMorePage(enrollments: enrollments),
                  component: yourEnrollmentsHeaderText,
                );
              }
              return buildEnrollmentCard(
                title: enrollments[index].topicName,
                link: enrollments[index].classroomLink,
                context: context,
              );
            },
          ),
        );
      },
    );
  }
}

Widget buildEnrollmentCard({
  required String title,
  required String link,
  required BuildContext context,
  bool seeMorePage = false,
}) {
  return Padding(
    padding: EdgeInsets.all(seeMorePage ? 0 : cardPadding),
    child: SizedBox(
      width: _cardWidth,
      height: enrollmentsCardHeight,
      child: Card(
        shape: seeMorePage ? const ContinuousRectangleBorder() : cardBorder(),
        elevation: seeMorePage ? 0 : cardElevation,
        child: Padding(
          padding: const EdgeInsets.all(cardContentPadding),
          child: Column(
            children: [
              sectionHeader(
                title,
                context: context,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Divider(color: listDividerColor, thickness: 2),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  customLaunchUrl('$classroomLink$link');

                  // Fire tracking event
                  AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                    component: Components.yourEnrollmentsSection,
                    data: EnrollmentsCardEventData(
                      email: FirebaseAuth.instance.currentUser!.email!,
                      itemName: title,
                      pageKey: seeMorePage
                          ? PageKeys.backendTrainingEnrollmentsSeeMorePage.name
                          : PageKeys.backendTrainingPage.name,
                    ).toJson(),
                  );
                },
                child: Text(
                  viewInClassroom,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
