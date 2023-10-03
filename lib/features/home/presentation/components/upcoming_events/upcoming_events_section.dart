import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/events.dart';
import 'package:home_page/analytics/domain/upcoming_events_card_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/upcoming_events_data.dart';
import 'package:home_page/features/home/presentation/components/upcoming_events/enroll_button.dart';
import 'package:provider/provider.dart';

const _cardHeight = 360.0;
const _cardDateSectionHeight = 40.0;
const _cardContentHeight = _cardHeight -
    _cardDateSectionHeight -
    cardContentPadding * 2 -
    cardPadding * 2;

class UpcomingEventsSection extends StatefulWidget {
  const UpcomingEventsSection({super.key});

  @override
  State<UpcomingEventsSection> createState() => _UpcomingEventsSectionState();
}

class _UpcomingEventsSectionState extends State<UpcomingEventsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          upcomingEventsHeaderText,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder<List<UpcomingEventsData>>(
          future: HomeService().fetchUpcomingEventsData(),
          loader: loadingState(height: _cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noUpcomingEventsText,
          child: (data) {
            return SizedBox(
              height: _cardHeight,
              child: data.length > 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: cardPadding,
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _getAllUpcomingEvents(data, context),
                      ),
                    )
                  : _getUpcomingEvent(data.first, context),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _getAllUpcomingEvents(
    List<UpcomingEventsData> data,
    BuildContext context,
  ) {
    var listOfAllWidgets = <Widget>[];
    for (int i = 0; i < data.length; i++) {
      listOfAllWidgets.add(_getUpcomingEvent(data[i], context));
    }
    return listOfAllWidgets;
  }

  Widget _getUpcomingEvent(UpcomingEventsData data, BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Column(
            children: [
              _upcomingEventDateHeader(data.date),
              Padding(
                padding: const EdgeInsets.all(cardContentPadding),
                child: SizedBox(
                  height: _cardContentHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      sectionHeader(data.title, context: context),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      sectionDivider(),
                      const Spacer(),
                      sectionBody(
                        data.description,
                        context: context,
                        maxLines: 5,
                      ),
                      const Spacer(),
                      sectionDivider(),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      _upcomingEventTimeAndPlaceSection(data.timeRange),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      sectionDivider(),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      _upcomingEventButtons(
                        eventId: data.eventId,
                        meetingLink: data.meeting_link,
                        isUserAlreadyEnrolled: data.isUserAlreadyEnrolled(
                          FirebaseAuth.instance.currentUser!.email,
                        ),
                        eventName: data.title,
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

  Widget _upcomingEventDateHeader(String date) {
    return Container(
      width: double.infinity,
      height: _cardDateSectionHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        color: appThemeColor,
      ),
      child: Text(
        date,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
        maxLines: 1,
      ),
    );
  }

  Widget _upcomingEventTimeAndPlaceSection(String timeRange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.location_history),
                horizontalSpace(width: 5),
                Expanded(
                  child: Text(
                    remoteText,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.timer),
                horizontalSpace(width: 5),
                Expanded(
                  child: Text(
                    timeRange,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _upcomingEventButtons({
    required String eventId,
    required bool isUserAlreadyEnrolled,
    required String meetingLink,
    required String eventName,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: EnrollButton(
              eventId: eventId,
              isUserAlreadyEnrolled: isUserAlreadyEnrolled,
              eventName: eventName,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                customLaunchUrl(meetingLink);

                // Fire tracking event
                AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                  component: Components.upcomingEventsSection,
                  data: UpcomingEventsCardEventData(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    eventName: eventName,
                    type: Events.joinHereButton,
                  ).toJson(),
                );
              },
              child: Text(
                joinHereButtonText,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: appThemeColor,
                      decoration: TextDecoration.underline,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
