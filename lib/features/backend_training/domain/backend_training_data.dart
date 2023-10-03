class BackendTrainingData {
  var title;
  var description;
  var classroomLink;
  var classroomState;

  BackendTrainingData(
      this.title, this.description, this.classroomLink, this.classroomState);

  BackendTrainingData.from(Map<dynamic, dynamic> data) {
    title = data['topic'];
    description = data['content'];
    classroomLink = data['link'];
    classroomState = data['state'];
  }
}
