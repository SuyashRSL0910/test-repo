import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:home_page/analytics/domain/events.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/common/apps_script_helper.dart';
import 'package:home_page/features/network/application/network_service.dart';

class AnalyticsService {

  late AppsScriptHelper _appsScriptHelper;
  late NetworkService _networkService;

  AnalyticsService(SignInViewModel viewModel) {
    _appsScriptHelper = AppsScriptHelper(viewModel: viewModel);
    _networkService = NetworkService();
  }

  /// To fire page view tracking event to backend
  ///
  /// parameters:
  /// [component] : a component from where event will fire, techSeriesCard,
  /// [data] : data to get for analyzing user behaviour such as {jsonData}
  void firePageViewTrackingEvent({
    required String component,
    required String data,
  }) {
    _fireTrackingEvent(
      component: component,
      eventType: Events.pageViewTrackingEventType,
      data: data,
    );
  }

  /// To fire click tracking event to backend
  ///
  /// parameters:
  /// [component] : a component from where event will fire, techSeriesCard,
  /// [data] : data to get for analyzing user behaviour such as {jsonData}
  void fireClickTrackingEvent({
    required String component,
    required String data,
  }) {
    _fireTrackingEvent(
      component: component,
      eventType: Events.clickTrackingEventType,
      data: data,
    );
  }

  /// To fire tracking event to backend
  ///
  /// parameters:
  /// [component] : a component from where event will fire, techSeriesCard,
  /// [eventType] : type of event, click and page_view
  /// [data] : data to get for analyzing user behaviour such as {jsonData}
  void _fireTrackingEvent({
    required String component,
    required String eventType,
    required String data,
  }) async {
    final connectivityResult = await _networkService.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _appsScriptHelper.fireTrackingEvent(
        component: component,
        eventType: eventType,
        data: data,
        callback: (status) {
          if (status == 'SUCCESS') {
            debugPrint('$eventType tracking event fired');
          } else {
            debugPrint('Some issue occurred while tracking');
          }
        },
      );
    }
  }
}
