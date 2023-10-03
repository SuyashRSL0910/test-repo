class PlatformTrainingsData {

  late String className;
  late String invitationLink;
  late List<String> topics;

  PlatformTrainingsData({
    required this.className,
    required this.invitationLink,
    required this.topics,
  });

  PlatformTrainingsData.from(Map<dynamic, dynamic> data) {
    className = data['classroomTitle'];
    invitationLink = data['invitationLink'];
    topics = getStringList(data['topics']);
  }

  List<String> getStringList(List<Object?> topics) {
    return topics.map((e) {
      return e as String;
    }).toList();
  }
}
