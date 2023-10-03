class TrainingProgressData {

  var isSuperUser;
  List<TraineeProgressData> traineeProgress = [];

  TrainingProgressData(this.isSuperUser, this.traineeProgress);

  TrainingProgressData.from(Map<dynamic, dynamic> data) {
    isSuperUser = data['isSU'];

    // transform trainee progress data
    List<dynamic> traineeProgressModels = data['data'];
    List<TraineeProgressData> traineeProgressData = [];
    for (int i = 0; i < traineeProgressModels.length; i++) {
      traineeProgressData.add(TraineeProgressData.from(traineeProgressModels[i]));
    }
    traineeProgress = traineeProgressData;
  }
}

class TraineeProgressData {

  var traineeName;
  var platform;
  var leadName;
  var leadEmail;
  List<TopicData> topics = [];
  double avgScore = 0.0;

  TraineeProgressData(this.traineeName,
                      this.platform,
                      this.leadName,
                      this.leadEmail,
                      this.topics);

  TraineeProgressData.from(Map<dynamic, dynamic> data) {
    traineeName = data['trainee'];
    platform = data['platform'];
    leadName = data['leadName'];
    leadEmail = data['leadEmail'];

    // transform topics data
    List<dynamic> topicModels = data['topicMarks'];
    List<TopicData> topicData = [];
    for (int i = 0; i < topicModels.length; i++) {
      topicData.add(TopicData.from(topicModels[i]));
    }
    topics = topicData;

    // transform average score
    double totalScore = 0;
    double totalInProgressTopics = 0;
    for (int i = 0; i < topicData.length; i++) {
      if (topicData[i].topicMarks is String) {
        totalInProgressTopics++;
      } else {
        totalScore = topicData[i].topicMarks + totalScore;
      }
    }
    avgScore = totalScore == 0
        ? totalScore
        : totalScore / (topicData.length - totalInProgressTopics);
  }
}

class TopicData {

  var topicName;
  var topicMarks;
  var grade;
  var status;

  TopicData(this.topicName, this.topicMarks, this.grade, this.status);

  TopicData.from(Map<dynamic, dynamic> data) {
    topicName = data['topicName'];
    topicMarks = data['marks'];
    grade = data['grade'];
    status = data['status'];
  }
}
