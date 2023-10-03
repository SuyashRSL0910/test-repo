import 'package:home_page/features/common/apps_script_helper.dart';
import 'package:home_page/features/home/data/home_repository.dart';
import 'package:home_page/features/home/domain/upcoming_trainings_data.dart';
import 'package:home_page/features/t200_training/domain/t200_training_enrollment_data.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';

class T200TrainingService {

  final HomeRepository _homeRepository = HomeRepository();
  final AppsScriptHelper _appsScriptHelper = AppsScriptHelper();

  T200TrainingService();

  Future<List<UpcomingTrainingsData>> fetchUpcomingTrainingsData() {
    return _homeRepository.getUpcomingTrainingsData();
  }

  Future<Map<String, List<T200TrainingEnrollmentData>>> fetchUserEnrollmentsData(String? accessToken,
                                                                                 String? userEmail) {
    return _appsScriptHelper.getUserEnrollmentsData(accessToken, userEmail);
  }

  Future<TrainingProgressData> fetchTrainingProgressData(String? accessToken,
                                                         String? userEmail) {
    return _appsScriptHelper.getTrainingProgressData(accessToken, userEmail);
  }
}
