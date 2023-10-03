import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/platform_training_classes_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/core/utils/custom_url_launcher.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/platform_trainings_data.dart';
import 'package:provider/provider.dart';

const _cardHeight = 380.0;
const _cardContentHeight =
    _cardHeight - cardPadding * 2 - cardContentPadding * 2;

class PlatformTrainingSection extends StatefulWidget {
  const PlatformTrainingSection({super.key});

  @override
  State<PlatformTrainingSection> createState() => _PlatformTrainingSectionState();
}

class _PlatformTrainingSectionState extends State<PlatformTrainingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(
          platformTrainingClassesSectionHeader,
          context: context,
          addTextDecoration: true,
        ),
        verticalSpace(height: sectionHeaderSpacingHeight),
        CustomFutureBuilder<List<PlatformTrainingsData>>(
          future: HomeService().fetchPlatformTrainingsData(),
          loader: loadingState(height: _cardHeight),
          errorReload: () {
            setState(() {});
          },
          emptyStateMessage: noPlatformTrainingClassesText,
          child: (data) {
            return SizedBox(
              height: _cardHeight,
              child: data.length > 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: cardPadding),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return _sectionCard(data[index], index : index);
                        },
                      ),
                    )
                  : _sectionCard(data.first, index : 0),
            );
          },
        ),
      ],
    );
  }

  Widget _sectionCard(PlatformTrainingsData data, {required int index}) {
    return SizedBox(
      width: cardWidth,
      height: _cardContentHeight,
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
                Column(children: _getAllListOfTopic(topics: data.topics)),
                const Spacer(),
                sectionDivider(),
                verticalSpace(height: sectionHeaderSpacingHeight),
                ElevatedButton(
                  onPressed: () {
                    customLaunchUrl(data.invitationLink);

                    // Fire tracking event
                    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
                      component: Components.platformTrainingClassesSection,
                      data: PlatformTrainingClassesEventData(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getAllListOfTopic({
    required List<String?> topics,
  }) {
    var listOfAllTopic = <Widget>[];
    final length = topics.length > 4 ? 4 : topics.length;
    for (int i = 0; i < length; i++) {
      final topic = topics[i];
      if (topic != null) {
        listOfAllTopic.add(_getTopic(topic: topic));
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
