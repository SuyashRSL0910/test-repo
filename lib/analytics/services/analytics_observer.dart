import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:home_page/analytics/domain/events.dart';
import 'package:home_page/analytics/domain/page_view_event_data.dart';
import 'package:home_page/analytics/domain/page_keys.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';

class AnalyticsObserver extends RouteObserver<ModalRoute<dynamic>> {

  AnalyticsObserver({required this.analyticsService});

  final AnalyticsService analyticsService;

  void _sendScreenView(Route<dynamic> route) {
    final String? pagePath = route.settings.name;
    if (pagePath != null
        && pagePath != signInPagePath
        && FirebaseAuth.instance.currentUser != null) {
      analyticsService.firePageViewTrackingEvent(
        component: getPageName(pagePath),
        data: PageViewEventData(
          pageKey: getPageViewEvent(pagePath),
          email: FirebaseAuth.instance.currentUser!.email!,
        ).toJson(),
      );
    }
  }

  String getPageName(String pagePath) {
    if (pagePath == homePagePath) {
      return Events.homePageEvent;
    } else if (pagePath == t200TrainingPagePath) {
      return Events.t200TrainingPageEvent;
    } else if (pagePath == t200StatisticsPagePath) {
      return Events.t200StatisticsPageEvent;
    } else if (pagePath == backendTrainingPagePath) {
      return Events.backendTrainingPageEvent;
    } else if (pagePath == eventCreationPagePath) {
      return Events.eventCreationPageEvent;
    } else if (pagePath == feedbackPagePath) {
      return Events.feedbackPageEvent;
    } else if (pagePath == techSeriesFeedbackPagePath) {
      return Events.techSeriesFeedbackPageEvent;
    }
    return pagePath;
  }

  String getPageViewEvent(String pagePath) {
    if (pagePath == homePagePath) {
      return PageKeys.homePage.name;
    } else if (pagePath == t200TrainingPagePath) {
      return PageKeys.t200TrainingPage.name;
    } else if (pagePath == t200StatisticsPagePath) {
      return PageKeys.t200StatisticsPage.name;
    } else if (pagePath == backendTrainingPagePath) {
      return PageKeys.backendTrainingPage.name;
    } else if (pagePath == eventCreationPagePath) {
      return PageKeys.eventCreationPage.name;
    } else if (pagePath == feedbackPagePath) {
      return PageKeys.feedbackPage.name;
    } else if (pagePath == techSeriesFeedbackPagePath) {
      return PageKeys.techSeriesFeedbackPage.name;
    }
    return pagePath;
  }

  bool _routeFilter(route) => route is PageRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (_routeFilter(route)) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && _routeFilter(newRoute)) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null &&
        _routeFilter(previousRoute) &&
        _routeFilter(route)) {
      _sendScreenView(previousRoute);
    }
  }
}
