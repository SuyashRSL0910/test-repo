class BackendTrainingEnrollmentsData {
  var topicName;
  var classroomLink;

  BackendTrainingEnrollmentsData({this.topicName, this.classroomLink});

  BackendTrainingEnrollmentsData.from(Map<dynamic, dynamic> data) {
    topicName = data['name'];
    classroomLink = data['link'];
  }
}
