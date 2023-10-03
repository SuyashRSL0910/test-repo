import 'package:home_page/features/backend_training/data/backend_training_repository.dart';

import '../../common/apps_script_helper.dart';
import '../domain/backend_training_data.dart';
import '../domain/backend_training_enrollments_data.dart';

class BackendTrainingService {
  final backendTrainingRepository = BackendTrainingRepository();
  final AppsScriptHelper _appsScriptHelper = AppsScriptHelper();

  BackendTrainingService();

  Future<List<BackendTrainingData>> fetchBackendTrainingData() {
    return backendTrainingRepository.getBackendTrainingData();
  }

  Future<List<BackendTrainingEnrollmentsData>> fetchEnrolledBackendTrainingData(
      String? accessToken, String? userEmail) async {
    return _appsScriptHelper.getEnrolledBackendTrainingTopics(
        accessToken, userEmail);
  }
}
