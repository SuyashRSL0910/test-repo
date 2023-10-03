import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_page/features/home/data/home_repository.dart';
import 'package:home_page/features/home/domain/interesting_things_data.dart';
import 'package:home_page/features/home/domain/newsletter_data.dart';
import 'package:home_page/features/home/domain/platform_trainings_data.dart';
import 'package:home_page/features/home/domain/t200_overall_classes_data.dart';
import 'package:home_page/features/home/domain/tech_series_data.dart';
import 'package:home_page/features/home/domain/tech_series_feedback_form_data.dart';
import 'package:home_page/features/home/domain/upcoming_events_data.dart';
import 'package:home_page/features/home/domain/upcoming_trainings_data.dart';
import 'package:home_page/features/common/apps_script_helper.dart';

class HomeService {

  static const String params = '&data=';

  final HomeRepository _homeRepository = HomeRepository();
  final AppsScriptHelper _appsScriptHelper = AppsScriptHelper();

  HomeService();

  Future<List<TechSeriesData>> fetchTechSeriesData() {
    return _homeRepository.getTechSeriesData();
  }

  Future<List<InterestingThingsData>> fetchInterestingThingsData() {
    return _homeRepository.getInterestingThingsData();
  }

  Future<List<T200AvailableClassesData>> fetchT200AvailableClassesData() {
    return _homeRepository.getT200AvailableClassesData();
  }

  Future<Map<String, List<NewsLetterData>>> fetchNewslettersData() {
    return _homeRepository.getNewslettersData();
  }

  Future<List<PlatformTrainingsData>> fetchPlatformTrainingsData() {
    return _homeRepository.getPlatformTrainingsData();
  }

  Future<List<UpcomingTrainingsData>> fetchUpcomingTrainingsData() {
    return _homeRepository.getUpcomingTrainingsData();
  }

  Future<List<UpcomingEventsData>> fetchUpcomingEventsData() {
    return _homeRepository.getUpcomingEventsData();
  }

  void postTechSeriesFeedbackFormData(
    TechSeriesFeedbackFormData data,
    Function(String) callback, {
    required BuildContext context,
  }) async {
    _appsScriptHelper.postTechSeriesFeedbackFormData(
      context,
      '$params${Uri.encodeComponent(data.toJson())}',
      callback,
    );
  }

  void addGuestToUpcomingEvent(
    EventRequestData eventRequestData,
    Function(String) callback, {
    required BuildContext context,
  }) {
    _appsScriptHelper.addGuestToUpcomingEvent(
      eventRequestData,
      callback,
      context: context,
    );
  }
}
