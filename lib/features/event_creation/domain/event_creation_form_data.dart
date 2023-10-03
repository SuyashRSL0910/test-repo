import 'dart:convert';

class EventCreationFormData {

  late String email;
  late String title;
  late String description;
  late String location;
  late String date;
  late String startTime;
  late String endTime;
  late String remoteLink;

  EventCreationFormData({
    required this.email,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remoteLink,
  });

  EventCreationFormData.from(Map<EventCreationFormInputKeys, String> data) {
    email = data[EventCreationFormInputKeys.email]!;
    title = data[EventCreationFormInputKeys.title]!;
    description = data[EventCreationFormInputKeys.description]!;
    location = data[EventCreationFormInputKeys.location]!;
    date = (data[EventCreationFormInputKeys.date]!);
    startTime = (data[EventCreationFormInputKeys.startTime]!);
    endTime = (data[EventCreationFormInputKeys.endTime]!);
    remoteLink = (data[EventCreationFormInputKeys.remoteLink]!);
  }

  String toJson() {
    Map<String, String> json = {};
    json[EventCreationFormInputKeys.email.name] = email;
    json[EventCreationFormInputKeys.title.name] = title;
    json[EventCreationFormInputKeys.description.name] = description;
    json[EventCreationFormInputKeys.location.name] = location;
    json[EventCreationFormInputKeys.date.name] = date;
    json[EventCreationFormInputKeys.startTime.name] = startTime;
    json[EventCreationFormInputKeys.endTime.name] = endTime;
    json[EventCreationFormInputKeys.remoteLink.name] = remoteLink;

    return jsonEncode(json).toString();
  }

  @override
  String toString() {
    return '{ email: $email, title: $title, description :$description, location: $location, date: $date, startTime: $startTime, endTime: $endTime, remoteLink: $remoteLink }';
  }
}

enum EventCreationFormInputKeys {
  email,
  title,
  description,
  location,
  date,
  startTime,
  endTime,
  remoteLink,
}
