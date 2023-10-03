import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_page/analytics/domain/components.dart';
import 'package:home_page/analytics/domain/events.dart';
import 'package:home_page/analytics/domain/upcoming_events_card_event_data.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/upcoming_events_data.dart';
import 'package:provider/provider.dart';

class EnrollButton extends StatefulWidget {
  const EnrollButton({
    super.key,
    required this.eventId,
    required this.isUserAlreadyEnrolled,
    required this.eventName,
  });

  final String eventId;
  final bool isUserAlreadyEnrolled;
  final String eventName;

  @override
  State<EnrollButton> createState() => _EnrollButtonState();
}

class _EnrollButtonState extends State<EnrollButton> {
  bool _isLoading = false;
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _isEnrolled = widget.isUserAlreadyEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: _isLoading || _isEnrolled ? null : _enrollUserToEvent,
      child: _isLoading
          ? const SpinKitRing(
              color: Colors.white,
              size: 25,
              lineWidth: 3,
            )
          : Text(
              _isEnrolled ? enrolledButtonText : enrollNowButtonText,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                  ),
              maxLines: 1,
            ),
    );
  }

  void _enrollUserToEvent() async {
    setState(() {
      _isLoading = true;
    });

    HomeService().addGuestToUpcomingEvent(
      context: context,
      EventRequestData(
        widget.eventId,
        FirebaseAuth.instance.currentUser!.email,
      ),
      (String response) {
        if (response == 'SUCCESS') {
          setState(() {
            _isLoading = false;
            _isEnrolled = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            snackBar(
              content: const Text(enrollmentSuccessText),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
            _isEnrolled = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            snackBar(
              content: const Text(errorFetching),
            ),
          );
        }
      },
    );

    // Fire tracking event
    AnalyticsService(Provider.of<SignInViewModel>(context, listen: false)).fireClickTrackingEvent(
      component: Components.upcomingEventsSection,
      data: UpcomingEventsCardEventData(
        email: FirebaseAuth.instance.currentUser!.email!,
        eventName: widget.eventName,
        type: Events.enrollNowButton,
      ).toJson(),
    );
  }
}
