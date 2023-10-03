import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/events.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/domain/tech_series_card_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/arguments/tech_series_feedback_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/domain/tech_series_data.dart';
import 'package:provider/provider.dart';

const _cardContentHeight = cardHeight - cardPadding * 2 - cardContentPadding * 2;

Widget getTechSeries(
  TechSeriesData techSeriesData, {
  bool seeMorePage = false,
  required BuildContext context,
  required TechSeriesFeedbackPageArgument argument,
  required int index,
}) {
  return seeMorePage
      ? getTechSeriesCard(
          techSeriesData,
          seeMorePage,
          context: context,
          argument: argument,
          index: index,
        )
      : Container(
          width: cardWidth,
          padding: const EdgeInsets.all(cardPadding),
          child: getTechSeriesCard(
            techSeriesData,
            seeMorePage,
            context: context,
            argument: argument,
            index: index,
          ),
        );
}

Widget getTechSeriesCard(
  TechSeriesData techSeriesData,
  bool seeMorePage, {
  required BuildContext context,
  required TechSeriesFeedbackPageArgument argument,
  required int index,
}) {
  final docLinks = techSeriesData.docLinks;
  final videoLinks = techSeriesData.videoLinks;
  final driveFolder = techSeriesData.otherLinks;
  return Card(
    elevation: seeMorePage ? 0 : cardElevation,
    shape: seeMorePage ? const ContinuousRectangleBorder() : cardBorder(),
    child: Padding(
      padding: const EdgeInsets.all(cardContentPadding),
      child: SizedBox(
        height: _cardContentHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getCardHeader(
              title: techSeriesData.title,
              imageUrl: techSeriesData.imageUrl,
              context: context,
            ),
            const Spacer(),
            sectionBody(
              techSeriesData.description,
              maxLines: 5,
              context: context,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _getResources(
                    docLinks: docLinks,
                    videoLinks: videoLinks,
                    driveFolder: driveFolder,
                    context: context,
                    index: index,
                    itemName: techSeriesData.title,
                    seeMorePage: seeMorePage,
                  ),
                ),
                Expanded(
                  child: _getFeedBack(
                    techSeriesData.title,
                    argument,
                    context,
                    index: index,
                    itemName: techSeriesData.title,
                    seeMorePage: seeMorePage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getCardHeader({
  required String imageUrl,
  required String title,
  required BuildContext context,
}) {
  return Row(
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageUrl),
          ),
          border: Border.all(color: cardBorderColor!, width: cardBorderWidth),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          children: [
            sectionHeader(title, context: context),
            verticalSpace(height: 2.5),
            sectionDivider(thickness: 2.5),
          ],
        ),
      )
    ],
  );
}

Widget _getFeedBack(
  String title,
  TechSeriesFeedbackPageArgument argument,
  BuildContext context, {
  required int index,
  required String itemName,
  required bool seeMorePage,
}) {
  return Column(
    children: [
      Text(
        addFeedbackText,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      verticalSpace(height: sectionHeaderSpacingHeight),
      _getResourceIcon(
        Icons.feedback_outlined,
        () {
          argument.setInitialValue(title);
          Navigator.pushNamed(
            context,
            techSeriesFeedbackPagePath,
            arguments: argument,
          );

          // Fire tracking event
          AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
            component: Components.techSeriesSection,
            data: TechSeriesCardEventData(
              email: FirebaseAuth.instance.currentUser!.email!,
              itemId: index.toString(),
              itemName: itemName,
              type: Events.feedbackFormButton,
              pageKey: seeMorePage
                  ? PageKeys.techSeriesSeeMorePage.name
                  : PageKeys.homePage.name,
            ).toJson(),
          );
        },
      ),
    ],
  );
}

Widget _getResources({
  required List? docLinks,
  required List? videoLinks,
  required List? driveFolder,
  required BuildContext context,
  required int index,
  required String itemName,
  required bool seeMorePage,
}) {
  return Column(
    children: [
      Text(
        resourcesText,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      verticalSpace(height: sectionHeaderSpacingHeight),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isListNotNull(docLinks)
              ? _getResourceIcon(
                  Icons.present_to_all_outlined,
                  () {
                    customLaunchUrl(docLinks!.first);

                    // Fire tracking event
                    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                      component: Components.techSeriesSection,
                      data: TechSeriesCardEventData(
                        email: FirebaseAuth.instance.currentUser!.email!,
                        itemId: index.toString(),
                        itemName: itemName,
                        type: Events.resourceButton,
                        pageKey: seeMorePage
                            ? PageKeys.techSeriesSeeMorePage.name
                            : PageKeys.homePage.name,
                      ).toJson(),
                    );
                  },
                )
              : Container(),
          isListNotNull(videoLinks)
              ? _getResourceIcon(
                  Icons.video_camera_back_outlined,
                  () {
                    customLaunchUrl(videoLinks!.first);

                    // Fire tracking event
                    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                      component: Components.techSeriesSection,
                      data: TechSeriesCardEventData(
                        email: FirebaseAuth.instance.currentUser!.email!,
                        itemId: index.toString(),
                        itemName: itemName,
                        type: Events.resourceButton,
                        pageKey: seeMorePage
                            ? PageKeys.techSeriesSeeMorePage.name
                            : PageKeys.homePage.name,
                      ).toJson(),
                    );
                  },
                )
              : Container(),
          isListNotNull(driveFolder)
              ? _getResourceIcon(
                  Icons.add_to_drive_outlined,
                  () {
                    customLaunchUrl(driveFolder!.first);

                    // Fire tracking event
                    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                      component: Components.techSeriesSection,
                      data: TechSeriesCardEventData(
                        email: FirebaseAuth.instance.currentUser!.email!,
                        itemId: index.toString(),
                        itemName: itemName,
                        type: Events.resourceButton,
                        pageKey: seeMorePage
                            ? PageKeys.techSeriesSeeMorePage.name
                            : PageKeys.homePage.name,
                      ).toJson(),
                    );
                  },
                )
              : Container(),
        ],
      ),
    ],
  );
}

Widget _getResourceIcon(IconData iconData, Function() onPressed) {
  return IconButton(
    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
    padding: const EdgeInsets.symmetric(horizontal: 5),
    onPressed: onPressed,
    icon: Icon(iconData),
  );
}
