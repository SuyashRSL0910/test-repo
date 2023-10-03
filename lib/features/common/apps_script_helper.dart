import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/common/access_token_helper.dart';
import 'package:home_page/features/common/apps_script_keys.dart';
import 'package:home_page/features/common/cache_helper.dart';
import 'package:home_page/features/home/domain/upcoming_events_data.dart';
import 'package:home_page/features/t200_training/domain/t200_training_enrollment_data.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';
import 'package:http/http.dart' as http;

import '../backend_training/domain/backend_training_enrollments_data.dart';

class AppsScriptHelper {

  CacheHelper cacheHelper = CacheHelper();
  final SignInViewModel? _viewModel;

  AppsScriptHelper({SignInViewModel? viewModel}) : _viewModel = viewModel;

  void addGuestToUpcomingEvent(
    EventRequestData eventRequestData,
    Function(String) callback, {
    required BuildContext context,
  }) async {
    _fetchAppScript(
      context: context,
      functionName: 'addGuestToEvent',
      callback: callback,
      params: eventRequestData.toParams(),
    );
  }

  /// To post event creation form data to the server
  ///
  /// params should be of type data=jsonObject
  void postEventCreationFormData(
    BuildContext context,
    String params,
    Function(String) callback,
  ) {
    _fetchAppScript(
      context: context,
      functionName: 'submitEventCreationForm',
      callback: callback,
      params: params,
    );
  }

  /// To post tech series feedback form data to the server
  ///
  /// params should be of type data=jsonObject
  void postTechSeriesFeedbackFormData(
    BuildContext context,
    String params,
    Function(String) callback,
  ) {
    _fetchAppScript(
      context: context,
      functionName: 'submitTechSeriesFeedbackFormData',
      callback: callback,
      params: params,
    );
  }

  /// To post feedback form data to the server
  ///
  /// params should be of type data=jsonObject
  void postFeedbackFormData(
    BuildContext context,
    String params,
    Function(String) callback,
  ) {
    _fetchAppScript(
      context: context,
      functionName: 'submitFeedbackFormData',
      callback: callback,
      params: params,
    );
  }

  /// To fire tracking event to backend
  ///
  /// parameters:
  /// [component] : a component from where event will fire, techSeriesCard,
  /// [eventType] : type of event, click and page_view
  /// [data] : data to get for analyzing user behaviour such as {jsonData}
  /// [callBack] : a callBack which will be called after api request is fired,
  void fireTrackingEvent({
    required String component,
    required String eventType,
    required String data,
    required Function(String) callback,
  }) {
    final params = {
      "component": component,
      "eventType": eventType,
      "trackingData": data,
    };
    _fetchAppScript(
      functionName: 'fireTrackingEvent',
      callback: callback,
      params: '&data=${Uri.encodeComponent(jsonEncode(params).toString())}',
    );
  }

  Future<List<BackendTrainingEnrollmentsData>> getEnrolledBackendTrainingTopics(
      String? accessToken, String? userEmail) async {
    List<BackendTrainingEnrollmentsData> modelList = [];
    final url =
        '$appScriptUrl?function=getBackendClassroomTopics&email=$userEmail';
    final headers = {'Authorization': 'Bearer $accessToken'};

    List<dynamic>? cacheResponse = await cacheHelper.getCachedList('getBackendClassroomTopics');
    if (cacheResponse != null) {
      http.Client().get(Uri.parse(url), headers: headers).then((response) {
        List<dynamic> serverResponse = [];
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          if (response.body.contains("status") &&
              response.body.contains("message")) {
            serverResponse = [];
          } else {
            serverResponse = List<dynamic>.from(jsonDecode(response.body) as List);
          }
          cacheHelper.cacheList(serverResponse, 'getBackendClassroomTopics');
        }
      });

      for (int i = 0; i < cacheResponse.length; i++) {
        modelList.add(BackendTrainingEnrollmentsData.from(cacheResponse[i]));
      }
      return modelList;
    } else {
      final response = await http.Client().get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        if (response.body.contains("status") &&
            response.body.contains("message")) {
          cacheHelper.cacheList([], 'getBackendClassroomTopics');
          return [];
        }
        List<dynamic> enrolledBackendTrainingsList =
            List<dynamic>.from(jsonDecode(response.body) as List);
        cacheHelper.cacheList(enrolledBackendTrainingsList, 'getBackendClassroomTopics');
        for (int i = 0; i < enrolledBackendTrainingsList.length; i++) {
          modelList.add(BackendTrainingEnrollmentsData.from(enrolledBackendTrainingsList[i]));
        }
        return modelList;
      } else {
        debugPrint(response.body);
        return Future.error(errorInReceivingEnrollmentsText);
      }
    }
  }

  Future<Map<String, List<T200TrainingEnrollmentData>>> getUserEnrollmentsData(
      String? accessToken, String? userEmail) async {
    final url = '$appScriptUrl?function=getClassroomCoursesForUser&email=$userEmail';
    final headers = {'Authorization': 'Bearer $accessToken'};

    Map<dynamic, dynamic>? cacheResponse = await cacheHelper.getCachedMap('getClassroomCoursesForUser');
    if (cacheResponse != null) {
      http.get(Uri.parse(url), headers: headers).then(
            (response) => {
              cacheHelper.cacheMap(Map.from(jsonDecode(response.body) as Map),
              'getClassroomCoursesForUser')
            },
          );
      List<T200TrainingEnrollmentData> ongoingEnrollmentData = [];
      List<T200TrainingEnrollmentData> completedEnrollmentData = [];
      List<dynamic> courseStatsModel = cacheResponse['t200CoursesStatistics'] ?? [];
      for (int i = 0; i < courseStatsModel.length; i++) {
        T200TrainingEnrollmentData enrollmentData =
            T200TrainingEnrollmentData.from(courseStatsModel[i]);
        if (enrollmentData.hasCompletedCourse) {
          completedEnrollmentData.add(enrollmentData);
        } else {
          ongoingEnrollmentData.add(enrollmentData);
        }
      }
      return {
        ongoingText: ongoingEnrollmentData,
        completedText: completedEnrollmentData
      };
    } else {
      final response = await http.get(Uri.parse(url), headers: headers);
      Map<dynamic, dynamic> enrollmentsMap = Map.from(jsonDecode(response.body) as Map);
      cacheHelper.cacheMap(enrollmentsMap, 'getClassroomCoursesForUser');
      List<T200TrainingEnrollmentData> ongoingEnrollmentData = [];
      List<T200TrainingEnrollmentData> completedEnrollmentData = [];
      List<dynamic> courseStatsModel =
          enrollmentsMap['t200CoursesStatistics'] ?? [];
      for (int i = 0; i < courseStatsModel.length; i++) {
        T200TrainingEnrollmentData enrollmentData =
            T200TrainingEnrollmentData.from(courseStatsModel[i]);
        if (enrollmentData.hasCompletedCourse) {
          completedEnrollmentData.add(enrollmentData);
        } else {
          ongoingEnrollmentData.add(enrollmentData);
        }
      }
      return {
        ongoingText: ongoingEnrollmentData,
        completedText: completedEnrollmentData
      };
    }
  }

  /// A standard method to fetch app script functions
  void _fetchAppScript({
    BuildContext? context,
    required Function(String) callback,
    required String params,
    String? functionName,
  }) async {
    String? accessToken;
    if (_viewModel != null) {
      accessToken = await AccessTokenHelper(null, viewModel: _viewModel).getAccessToken();
    } else {
      accessToken = await AccessTokenHelper(context).getAccessToken();
    }
    final url = '$appScriptUrl?function=$functionName$params';
    final headers = {'Authorization': 'Bearer $accessToken'};
    http.Client().get(Uri.parse(url), headers: headers).then((res) {
      if (res.statusCode == 200) {
        callback(jsonDecode(res.body)['status']);
      } else {
        debugPrint(res.body);
        callback('ERROR');
      }
    });
  }

  Future<TrainingProgressData> getTrainingProgressData(String? accessToken,
                                                       String? userEmail) async {
    final url = '$appScriptUrl?function=getTrainingData&email=$userEmail';
    final headers = {'Authorization': 'Bearer $accessToken'};

    Map<dynamic, dynamic>? cacheResponse = await cacheHelper.getCachedMap('getTrainingData');
    if (cacheResponse != null) {
      http.get(Uri.parse(url), headers: headers).then((response) =>
          cacheHelper.cacheMap(Map.from(jsonDecode(response.body) as Map),
              'getTrainingData'));
      return TrainingProgressData.from(cacheResponse);
    } else {
      final response = await http.get(Uri.parse(url), headers: headers);
      Map<dynamic, dynamic> serverMap = Map.from(jsonDecode(response.body) as Map);
      cacheHelper.cacheMap(serverMap, 'getTrainingData');
      return TrainingProgressData.from(serverMap);
    }
  }
}
