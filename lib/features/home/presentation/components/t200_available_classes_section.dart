import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/t200_available_classes_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/t200_overall_classes_data.dart';
import 'package:provider/provider.dart';

const _cardHeight = 380.0;
const _cardContentHeight =
    _cardHeight - cardPadding * 2 - cardContentPadding * 2;

class T200AvailableClassesSection extends StatefulWidget {
  const T200AvailableClassesSection({super.key});

  @override
  State<T200AvailableClassesSection> createState() =>
      _T200AvailableClassesSectionState();
}

class _T200AvailableClassesSectionState
    extends State<T200AvailableClassesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(height: sectionHeaderSpacingHeight),
        sectionHeader(
          t200AvailableClassesHeader,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder<List<T200AvailableClassesData>>(
          future: HomeService().fetchT200AvailableClassesData(),
          loader: loadingState(height: _cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noT200AvailableClassesText,
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
                        children: _getAllAvailableClasses(
                          t200AvailableClasses: data,
                        ),
                      ),
                    )
                  : _getAvailableClass(data: data.first),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _getAllAvailableClasses({
    required List<T200AvailableClassesData> t200AvailableClasses,
  }) {
    var listOfAllAvailableClasses = <Widget>[];
    for (int i = 0; i < t200AvailableClasses.length; i++) {
      listOfAllAvailableClasses.add(
        _getAvailableClass(data: t200AvailableClasses[i]),
      );
    }
    return listOfAllAvailableClasses;
  }

  Widget _getAvailableClass({required T200AvailableClassesData data}) {
    return SizedBox(
      height: _cardContentHeight,
      width: cardWidth,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(cardContentPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionHeader(
                  data.className,
                  context: context,
                  textAlign: TextAlign.start,
                ),
                verticalSpace(height: sectionHeaderSpacingHeight),
                sectionDivider(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                sectionHeader(
                  whatYouWillLearnText,
                  context: context,
                  textAlign: TextAlign.start,
                ),
                verticalSpace(height: sectionHeaderSpacingHeight),
                Column(
                  children: _getAllListOfTopic(
                    topics: data.topics,
                    platform: data.platform,
                  ),
                ),
                const Spacer(),
                sectionDivider(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                ElevatedButton(
                  onPressed: () {
                    customLaunchUrl(data.link);

                    // Fire tracking event
                    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                      component: Components.t200AvailableClassesSection,
                      data: T200AvailableClassesEventData(
                        email: FirebaseAuth.instance.currentUser!.email!,
                        classTitle: data.className,
                      ).toJson(),
                    );
                  },
                  child: Text(
                    viewJoinClassroomText,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getAllListOfTopic({
    required List<Object?> topics,
    required String? platform,
  }) {
    var listOfAllTopic = <Widget>[];
    final length = topics.length > 4 ? 4 : topics.length;
    for (int i = 0; i < length; i++) {
      final topic = topics[i];
      if (topic != null) {
        listOfAllTopic.add(_getTopic(topic: topic.toString()));
      }
    }
    if (topics.length > 4) {
      listOfAllTopic.add(_getMoreTopic());
    }
    return listOfAllTopic;
  }

  Widget _getTopic({required String topic}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: sectionHeaderSpacingHeight),
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            const VerticalDivider(
              color: Colors.grey,
              thickness: 3,
            ),
            const Icon(Icons.check_rounded),
            Expanded(
              child: Text(
                topic,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMoreTopic() {
    return Padding(
      padding: const EdgeInsets.only(bottom: sectionHeaderSpacingHeight),
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            const VerticalDivider(
              color: Colors.grey,
              thickness: 3,
            ),
            Text(
              manyMoreTopicsText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
