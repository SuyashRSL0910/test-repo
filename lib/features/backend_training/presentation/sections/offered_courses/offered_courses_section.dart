import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/offered_courses_card_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/backend_training/application/backend_training_service.dart';
import 'package:home_page/features/backend_training/presentation/sections/common.dart';
import 'package:home_page/features/backend_training/presentation/sections/offered_courses/offered_courses_see_more_page.dart';
import 'package:provider/provider.dart';

import '../../../domain/backend_training_data.dart';

const _cardWidth = 260.0;
const _cardHeight = 270.0;

class OfferedCoursesSection extends StatefulWidget {
  const OfferedCoursesSection({super.key});

  @override
  State<StatefulWidget> createState() => _OfferedCoursesSectionState();
}

class _OfferedCoursesSectionState extends State<OfferedCoursesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sectionHeader(
          offeredCoursesHeaderText,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder(
          future: BackendTrainingService().fetchBackendTrainingData(),
          loader: loadingState(height: _cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noOfferedCoursesText,
          child: (data) {
            return _buildOfferedCourses(data);
          },
        ),
      ],
    );
  }

  Widget _buildOfferedCourses(List<BackendTrainingData> offeredCourses) {
    return SizedBox(
      height: _cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offeredCourses.length > 5 ? 5 : offeredCourses.length,
        itemBuilder: (context, index) {
          if (index == 4) {
            return buildSeeMoreButton(
              width: _cardWidth,
              context: context,
              seeMorePage: OfferedCoursesSeeMorePage(
                backendTrainingData: offeredCourses,
              ),
              component: offeredCoursesHeaderText,
            );
          }
          return SizedBox(
            width: _cardWidth,
            child: buildOfferedCoursesCard(
              title: offeredCourses[index].title,
              description: offeredCourses[index].description,
              classroomState: offeredCourses[index].classroomState,
              context: context,
              link: offeredCourses[index].classroomLink,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

Widget buildOfferedCoursesCard({
  required String title,
  required String description,
  required bool classroomState,
  required BuildContext context,
  required int index,
  String? link,
  bool seeMorePage = false,
}) {
  return Padding(
    padding: EdgeInsets.all(seeMorePage ? 0 : cardPadding),
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
            seeMorePage ? const SizedBox(height: 15) : const Spacer(),
            Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            seeMorePage ? const SizedBox(height: 15) : const Spacer(),
            Divider(color: listDividerColor, thickness: 2),
            ElevatedButton(
              onPressed: classroomState
                  ? () {
                      customLaunchUrl('$classroomLink$link');

                      // Fire tracking event
                      AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                        component: Components.offeredCoursesSection,
                        data: OfferedCoursesCardEventData(
                          email: FirebaseAuth.instance.currentUser!.email!,
                          itemId: index.toString(),
                          itemName: title,
                          pageKey: seeMorePage
                              ? PageKeys.backendTrainingCoursesSeeMorePage.name
                              : PageKeys.backendTrainingPage.name,
                        ).toJson(),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: disabledAppThemeColor,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                classroomState ? viewInClassroom : comingSoon,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
