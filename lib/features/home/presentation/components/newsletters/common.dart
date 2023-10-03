import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/newsletter_card_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/domain/newsletter_data.dart';
import 'package:provider/provider.dart';

const numOfTabs = 3;

Widget getNewsletters(
  NewsLetterData data, {
  bool seeMorePage = false,
  required BuildContext context,
  required int index,
}) {
  return seeMorePage
      ? SizedBox(
          height: cardHeight,
          child: _getNewslettersCard(
            data,
            seeMorePage: seeMorePage,
            context: context,
            index: index,
          ),
        )
      : SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: _getNewslettersCard(
              data,
              context: context,
              seeMorePage: seeMorePage,
              index: index,
            ),
          ),
        );
}

// Card Start

Widget _getNewslettersCard(
  NewsLetterData data, {
  required BuildContext context,
  bool seeMorePage = false,
  required int index,
}) {
  return Card(
    elevation: seeMorePage ? 0 : cardElevation,
    shape: seeMorePage ? const ContinuousRectangleBorder() : cardBorder(),
    child: Padding(
      padding: const EdgeInsets.all(cardContentPadding),
      child: Column(
        children: [
          sectionHeader(data.title, context: context),
          verticalSpace(height: sectionHeaderSpacingHeight),
          sectionDivider(),
          const Spacer(),
          sectionBody(data.description, maxLines: 5, context: context),
          const Spacer(),
          _cardDate(data.published_date, context),
          verticalSpace(height: sectionSpacingHeight),
          _cardButton(
            data.newsletter_link,
            context,
            index: index,
            itemName: data.title,
            seeMorePage: seeMorePage,
          ),
        ],
      ),
    ),
  );
}

Widget _cardDate(String date, BuildContext context) {
  return Row(
    children: [
      const Icon(Icons.calendar_month),
      horizontalSpace(width: sectionLabelSpacingWidth),
      Expanded(
        child: Text(
          publishedOnText(date),
          style: Theme.of(context).textTheme.labelLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget _cardButton(
  String link,
  BuildContext context, {
  required String itemName,
  required int index,
  required bool seeMorePage,
}) {
  return ElevatedButton(
    onPressed: () {
      customLaunchUrl(link);

      // Fire tracking event
      AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
        component: Components.newslettersSection,
        data: NewsletterCardEventData(
          email: FirebaseAuth.instance.currentUser!.email!,
          itemName: itemName,
          itemId: index.toString(),
          pageKey: seeMorePage
              ? PageKeys.newslettersSeeMorePage.name
              : PageKeys.homePage.name,
        ).toJson(),
      );
    },
    style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 15.0,
          )),
          shape: const MaterialStatePropertyAll(StadiumBorder()),
        ),
    child: Text(
      viewNewsletterButtonText,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Colors.white,
          ),
    ),
  );
}
