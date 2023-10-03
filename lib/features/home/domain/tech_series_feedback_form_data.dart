import 'dart:convert';

class TechSeriesFeedbackFormData {

  late String email;
  late String techTalkTopic;
  late String understanding;
  late String satisfied;
  late String overall;
  late String logistics;
  late String duration;
  late String takeaway;
  late String followUp;
  late String recommend;
  late String particularFeedback;
  late String otherTopics;
  late String suggestion;

  TechSeriesFeedbackFormData({
    required this.email,
    required this.techTalkTopic,
    required this.understanding,
    required this.satisfied,
    required this.overall,
    required this.logistics,
    required this.duration,
    required this.takeaway,
    required this.followUp,
    required this.recommend,
    required this.particularFeedback,
    required this.otherTopics,
    required this.suggestion,
  });

  TechSeriesFeedbackFormData.from(
      Map<TechSeriesFeedbackFormInputKeys, String> data) {
    email = data[TechSeriesFeedbackFormInputKeys.email]!;
    techTalkTopic = data[TechSeriesFeedbackFormInputKeys.techTalkTopic]!;
    understanding = data[TechSeriesFeedbackFormInputKeys.understanding]!;
    satisfied = data[TechSeriesFeedbackFormInputKeys.satisfied]!;
    overall = data[TechSeriesFeedbackFormInputKeys.overall]!;
    logistics = data[TechSeriesFeedbackFormInputKeys.logistics]!;
    duration = data[TechSeriesFeedbackFormInputKeys.duration]!;
    takeaway = data[TechSeriesFeedbackFormInputKeys.takeaway]!;
    followUp = data[TechSeriesFeedbackFormInputKeys.followUp]!;
    recommend = data[TechSeriesFeedbackFormInputKeys.recommend]!;
    particularFeedback = data[TechSeriesFeedbackFormInputKeys.particularFeedback]!;
    otherTopics = data[TechSeriesFeedbackFormInputKeys.otherTopics]!;
    suggestion = data[TechSeriesFeedbackFormInputKeys.suggestion]!;
  }

  String toJson() {
    Map<String, String> json = {};
    json[TechSeriesFeedbackFormInputKeys.email.name] = email;
    json[TechSeriesFeedbackFormInputKeys.techTalkTopic.name] = techTalkTopic;
    json[TechSeriesFeedbackFormInputKeys.understanding.name] = understanding;
    json[TechSeriesFeedbackFormInputKeys.satisfied.name] = satisfied;
    json[TechSeriesFeedbackFormInputKeys.overall.name] = overall;
    json[TechSeriesFeedbackFormInputKeys.logistics.name] = logistics;
    json[TechSeriesFeedbackFormInputKeys.duration.name] = duration;
    json[TechSeriesFeedbackFormInputKeys.takeaway.name] = takeaway;
    json[TechSeriesFeedbackFormInputKeys.followUp.name] = followUp;
    json[TechSeriesFeedbackFormInputKeys.recommend.name] = recommend;
    json[TechSeriesFeedbackFormInputKeys.particularFeedback.name] = particularFeedback;
    json[TechSeriesFeedbackFormInputKeys.otherTopics.name] = otherTopics;
    json[TechSeriesFeedbackFormInputKeys.suggestion.name] = suggestion;

    return jsonEncode(json).toString();
  }

  @override
  String toString() {
    return '{ email: $email, techTalkTopic: $techTalkTopic, understanding: $understanding, satisfied: $satisfied, overall: $overall, logistics: $logistics, duration: $duration, takeaway: $takeaway, followUp: $followUp, recommend: $recommend, particularFeedback: $particularFeedback, otherTopics: $otherTopics, suggestion: $suggestion }';
  }
}

enum TechSeriesFeedbackFormInputKeys {
  email,
  techTalkTopic,
  understanding,
  satisfied,
  overall,
  logistics,
  duration,
  takeaway,
  followUp,
  recommend,
  particularFeedback,
  otherTopics,
  suggestion,
}
