class UpcomingTrainingsData {

  var platformName;
  var topics;
  var date;

  UpcomingTrainingsData(this.platformName, this.topics, this.date);

  UpcomingTrainingsData.from(Map<dynamic, dynamic> data) {
    platformName = data['platformName'];
    date = data['date'];

    List<dynamic> topicsModel = data["topics"];
    List<TrainingTopicData> trainingTopics = [];
    for (int i = 0; i < topicsModel.length; i++) {
      trainingTopics.add(TrainingTopicData.from(topicsModel[i]));
    }

    topics = trainingTopics;
  }
}

class TrainingTopicData {

  var topic;
  var duration;

  TrainingTopicData(this.topic, this.duration);

  TrainingTopicData.from(Map<dynamic, dynamic> data) {
    topic = data["topic"];
    duration = data["duration"];
  }
}
