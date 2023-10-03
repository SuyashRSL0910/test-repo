import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/custom_future_builder.dart';
import 'package:home_page/features/common/access_token_helper.dart';
import 'package:home_page/features/t200_training/application/t200_training_service.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';
import 'package:home_page/features/t200_training/presentation/components/overall_training_progress_section.dart';
import 'package:home_page/features/t200_training/presentation/components/team_overall_progress_stats_page.dart';

class TrainingProgressSection extends StatefulWidget {
  const TrainingProgressSection({super.key});

  @override
  State<StatefulWidget> createState() => _TrainingProgressSectionState();
}

class _TrainingProgressSectionState extends State<TrainingProgressSection> {

  final double _defaultContainerHeight = 275.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<String?>(
      future: AccessTokenHelper(context).getAccessToken(),
      loader: loadingState(height: _defaultContainerHeight),
      emptyStateMessage: emptyEnrollmentsText,
      errorReload: () {
        setState(() {});
      },
      child: (accessToken) {
        return _getTrainingProgressData(accessToken);
      },
    );
  }

  Widget _getTrainingProgressData(String? accessToken) {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    return CustomFutureBuilder<TrainingProgressData>(
      future: T200TrainingService().fetchTrainingProgressData(accessToken, userEmail),
      loader: loadingState(height: _defaultContainerHeight),
      emptyStateMessage: emptyEnrollmentsText,
      errorReload: () {
        setState(() {});
      },
      child: (data) {
        if (data.isSuperUser) {
          return Visibility(
            visible: data.traineeProgress.isNotEmpty,
            child: OverallTrainingProgressSection(
                traineeProgressDataModels: data.traineeProgress),
          );
        } else {
          return Visibility(
            visible: data.traineeProgress.isNotEmpty,
            child: TeamOverallProgressStatsPage(teamProgressDataModels: data.traineeProgress),
          );
        }
      },
    );
  }
}

Icon getIconFromPlatformName(String platformName) {
  switch (platformName) {
    case androidPlatformText:
      return const Icon(Icons.android);
    case iOSPlatformText:
      return const Icon(Icons.apple);
    case webPlatformText:
      return const Icon(Icons.vpn_lock_sharp);
    default:
      return const Icon(Icons.admin_panel_settings_outlined);
  }
}
