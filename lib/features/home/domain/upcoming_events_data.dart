import 'package:html/parser.dart';

class UpcomingEventsData {

  var title;
  var description;
  var eventId;
  var guestEmailList;
  var meeting_link;
  var date;
  var timeRange;
  var shouldShowEnrollButton;

  UpcomingEventsData(
      this.title,
      this.description,
      this.eventId,
      this.guestEmailList,
      this.meeting_link,
      this.date,
      this.timeRange,
      this.shouldShowEnrollButton);

  UpcomingEventsData.from(Map<dynamic, dynamic> data) {
    title = data['title'];
    eventId = data['eventId'];
    guestEmailList = data['guestEmailList'];
    date = data['date'];
    timeRange = data['timeRange'];
    shouldShowEnrollButton = data['shouldShowEnrollButton'];

    // transform description and meeting link
    List<String> parsedDescription = parseEventDescription(data['description']);
    if (parsedDescription.length > 1) {
      description = parsedDescription[0];
      meeting_link = parsedDescription[1];
    } else {
      description = parsedDescription[0];
    }
  }

  List<String> parseEventDescription(String descriptionWithLink) {
    String descriptionAndLinkText = parse(descriptionWithLink).body!.text;
    return descriptionAndLinkText.split(RegExp('Meeting link: '));
  }

  bool isUserAlreadyEnrolled(String? userEmail) {
    if (guestEmailList != null) {
      return guestEmailList.contains(userEmail);
    } else {
      return false;
    }
  }
}

class EventRequestData {

  var eventId;
  var userEmail;

  EventRequestData(this.eventId, this.userEmail);

  String toParams() => "&eventId=$eventId&email=$userEmail";
}
