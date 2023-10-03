import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/other_interesting_stuff_card_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/domain/interesting_things_data.dart';
import 'package:provider/provider.dart';

Widget getInterestingStuff(
  InterestingThingsData interestingThingsData, {
  bool seeMorePage = false,
  required BuildContext context,
  required int index,
}) {
  return seeMorePage
      ? SizedBox(
          height: cardHeight,
          child: getInterestingStuffCard(
            interestingThingsData,
            seeMorePage,
            context: context,
            index: index,
          ),
        )
      : Container(
          width: cardWidth,
          padding: const EdgeInsets.all(cardPadding),
          child: getInterestingStuffCard(
            interestingThingsData,
            seeMorePage,
            context: context,
            index: index,
          ),
        );
}

Widget getInterestingStuffCard(
  InterestingThingsData interestingThingsData,
  bool seeMorePage, {
  required BuildContext context,
  required int index,
}) {
  final docLinks = interestingThingsData.docLinks;
  final videoLinks = interestingThingsData.videoLinks;
  final driveFolder = interestingThingsData.otherLinks;
  return Card(
    elevation: seeMorePage ? 0 : cardElevation,
    shape: seeMorePage ? const ContinuousRectangleBorder() : cardBorder(),
    child: Padding(
      padding: const EdgeInsets.all(cardContentPadding),
      child: Column(
        children: [
          _getCardHeader(
            title: interestingThingsData.title,
            imageUrl: interestingThingsData.imageUrl,
            context: context,
          ),
          const Spacer(),
          sectionBody(
            interestingThingsData.description,
            maxLines: 5,
            context: context,
          ),
          const Spacer(),
          const Divider(
            color: Colors.grey,
            thickness: sectionDividerThickness,
            indent: 20,
            endIndent: 20,
            height: 1.5,
          ),
          verticalSpace(height: sectionHeaderSpacingHeight),
          _getResources(
            docLinks: docLinks,
            videoLinks: videoLinks,
            driveFolder: driveFolder,
            context: context,
            index: index,
            itemName: interestingThingsData.title,
            seeMorePage: seeMorePage,
          ),
        ],
      ),
    ),
  );
}

Widget _getCardHeader({
  required String title,
  required String imageUrl,
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
      horizontalSpace(width: sectionLabelSpacingWidth),
      Expanded(
        child: Column(
          children: [
            sectionHeader(title, context: context),
            verticalSpace(height: sectionHeaderSpacingHeight),
            sectionDivider(thickness: 1.5),
          ],
        ),
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
  return Row(
    children: [
      Text(
        '$resourcesText :',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      isListNotNull(docLinks)
          ? _getResourceIcon(
              Icons.present_to_all_outlined,
              docLinks!.first,
              index: index,
              itemName: itemName,
              seeMorePage: seeMorePage,
            )
          : Container(),
      isListNotNull(videoLinks)
          ? _getResourceIcon(
              Icons.video_camera_back_outlined,
              videoLinks!.first,
              index: index,
              itemName: itemName,
              seeMorePage: seeMorePage,
            )
          : Container(),
      isListNotNull(driveFolder)
          ? _getResourceIcon(
              Icons.add_to_drive_outlined,
              driveFolder!.first,
              index: index,
              itemName: itemName,
              seeMorePage: seeMorePage,
            )
          : Container(),
    ],
  );
}

Widget _getResourceIcon(
  IconData iconData,
  String url, {
  required int index,
  required String itemName,
  required bool seeMorePage,
}) {
  return Builder(
    builder: (context) {
      return IconButton(
        onPressed: () async {
          customLaunchUrl(url);

          // Fire tracking event
          AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
            component: Components.otherInterestingStuffSection,
            data: OtherInterestingStuffCardEventData(
              email: FirebaseAuth.instance.currentUser!.email!,
              itemName: itemName,
              itemId: index.toString(),
              pageKey: seeMorePage
                  ? PageKeys.otherInterestingStuffSeeMorePage.name
                  : PageKeys.homePage.name,
            ).toJson(),
          );
        },
        icon: Icon(iconData),
      );
    }
  );
}
