import 'package:firebase_database/firebase_database.dart';
import 'package:home_page/features/home/data/database_keys.dart';
import 'package:home_page/features/home/domain/interesting_things_data.dart';
import 'package:home_page/features/home/domain/newsletter_data.dart';
import 'package:home_page/features/home/domain/platform_trainings_data.dart';
import 'package:home_page/features/home/domain/t200_overall_classes_data.dart';
import 'package:home_page/features/home/domain/tech_series_data.dart';
import 'package:home_page/features/home/domain/upcoming_events_data.dart';
import 'package:home_page/features/home/domain/upcoming_trainings_data.dart';

class HomeRepository {

  late DatabaseReference _trainingPortalDatabaseReference;
  late DatabaseReference _t200PortalDatabaseReference;
  late DatabaseReference _calendarDatabaseReference;
  late DatabaseReference _classroomDatabaseReference;

  HomeRepository() {
    _trainingPortalDatabaseReference = FirebaseDatabase.instance.ref(
      trainingPortalDatabaseKey,
    );

    _t200PortalDatabaseReference = FirebaseDatabase.instance.ref(
      t200PortalDatabaseKey,
    );

    _calendarDatabaseReference = FirebaseDatabase.instance.ref(
      calendarDatabaseKey,
    );

    _classroomDatabaseReference = FirebaseDatabase.instance.ref(
      classroomDatabaseKey,
    );
  }

  Future<List<TechSeriesData>> getTechSeriesData() async {
    List<TechSeriesData> modelList = [];
    final DatabaseReference techSeriesDatabase =
        _trainingPortalDatabaseReference.child(techSeriesKey);
    final snapshot = await techSeriesDatabase.get();
    if (snapshot.exists) {
      List<dynamic> techSeriesList = List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < techSeriesList.length; i++) {
        modelList.add(TechSeriesData.from(techSeriesList[i]));
      }
    }

    return modelList;
  }

  Future<List<InterestingThingsData>> getInterestingThingsData() async {
    List<InterestingThingsData> modelList = [];
    final DatabaseReference techSeriesDatabase =
        _trainingPortalDatabaseReference.child(interestingThingsKey);
    final snapshot = await techSeriesDatabase.get();
    if (snapshot.exists) {
      List<dynamic> interestingThingsList = List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < interestingThingsList.length; i++) {
        modelList.add(InterestingThingsData.from(interestingThingsList[i]));
      }
    }

    return modelList;
  }

  Future<List<T200AvailableClassesData>> getT200AvailableClassesData() async {
    List<T200AvailableClassesData> modelList = [];
    final DatabaseReference t200OverallClassesDatabase =
        _trainingPortalDatabaseReference.child(t200OverallClassesKey);
    final snapshot = await t200OverallClassesDatabase.get();
    if (snapshot.exists) {
      List<dynamic> t200OverallClassesList =
          List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < t200OverallClassesList.length; i++) {
        modelList.add(T200AvailableClassesData.from(t200OverallClassesList[i]));
      }
    }

    return modelList;
  }

  Future<Map<String, List<NewsLetterData>>> getNewslettersData() async {
    Map<String, List<NewsLetterData>> modelMap = {};
    final DatabaseReference newslettersDatabase =
        _trainingPortalDatabaseReference.child(newslettersKey);
    final snapshot = await newslettersDatabase.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> newslettersMap = Map.from(snapshot.value as Map);
      newslettersMap.forEach((key, value) {
        List<dynamic> newslettersList = List<dynamic>.from(value as List);
        List<NewsLetterData> modelList = [];
        for (int i = 0; i < newslettersList.length; i++) {
          modelList.add(NewsLetterData.from(newslettersList[i]));
        }
        modelMap[key] = modelList;
      });
    }

    return modelMap;
  }

  Future<List<UpcomingTrainingsData>> getUpcomingTrainingsData() async {
    List<UpcomingTrainingsData> modelList = [];
    final DatabaseReference upcomingTrainingsDatabase =
    _t200PortalDatabaseReference.child(upcomingTrainingsKey);
    final snapshot = await upcomingTrainingsDatabase.get();
    if (snapshot.exists) {
      List<dynamic> upcomingTrainingsList =
      List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < upcomingTrainingsList.length; i++) {
        modelList.add(UpcomingTrainingsData.from(upcomingTrainingsList[i]));
      }
    }

    return modelList;
  }

  Future<List<UpcomingEventsData>> getUpcomingEventsData() async {
    List<UpcomingEventsData> modelList = [];
    final DatabaseReference upcomingEventsDatabase =
    _calendarDatabaseReference.child(upcomingEventsKey);
    final snapshot = await upcomingEventsDatabase.get();
    if (snapshot.exists) {
      List<dynamic> upcomingEventsList =
      List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < upcomingEventsList.length; i++) {
        modelList.add(UpcomingEventsData.from(upcomingEventsList[i]));
      }
    }

    return modelList;
  }

  Future<List<PlatformTrainingsData>> getPlatformTrainingsData() async {
    List<PlatformTrainingsData> modelList = [];
    final DatabaseReference platformTrainingsDatabase =
        _classroomDatabaseReference.child(platformTrainingKey);
    final snapshot = await platformTrainingsDatabase.get();
    if (snapshot.exists) {
      List<dynamic> platformTrainingsList = List.from(snapshot.value as List);
      for (int i = 0; i < platformTrainingsList.length; i++) {
        modelList.add(PlatformTrainingsData.from(platformTrainingsList[i]));
      }
    }

    return modelList;
  }
}
