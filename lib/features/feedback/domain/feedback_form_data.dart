import 'dart:convert';

class FeedbackFormData {

  late String email;
  late String featuresWithGoodInsights;
  late String trainingOrCourses;
  late String upcomingFeatures;
  late String difficulties;
  late String otherSuggestions;

  FeedbackFormData({
    required this.email,
    required this.featuresWithGoodInsights,
    required this.trainingOrCourses,
    required this.upcomingFeatures,
    required this.difficulties,
    required this.otherSuggestions,
  });

  FeedbackFormData.from(Map<FeedbackFormInputKeys, String> data) {
    email = data[FeedbackFormInputKeys.email]!;
    featuresWithGoodInsights = data[FeedbackFormInputKeys.featuresWithGoodInsights]!;
    trainingOrCourses = data[FeedbackFormInputKeys.trainingOrCourses]!;
    upcomingFeatures = data[FeedbackFormInputKeys.upcomingFeatures]!;
    difficulties = (data[FeedbackFormInputKeys.difficulties]!);
    otherSuggestions = (data[FeedbackFormInputKeys.otherSuggestions]!);
  }

  String toJson() {
    Map<String, String> json = {};
    json[FeedbackFormInputKeys.email.name] = email;
    json[FeedbackFormInputKeys.featuresWithGoodInsights.name] = featuresWithGoodInsights;
    json[FeedbackFormInputKeys.trainingOrCourses.name] = trainingOrCourses;
    json[FeedbackFormInputKeys.upcomingFeatures.name] = upcomingFeatures;
    json[FeedbackFormInputKeys.difficulties.name] = difficulties;
    json[FeedbackFormInputKeys.otherSuggestions.name] = otherSuggestions;

    return jsonEncode(json).toString();
  }

  @override
  String toString() {
    return '{ email: $email, featuresWithGoodInsights: $featuresWithGoodInsights, trainingOrCourses: $trainingOrCourses, upcomingFeatures: $upcomingFeatures, difficulties: $difficulties, otherSuggestions: $otherSuggestions }';
  }
}

enum FeedbackFormInputKeys {
  email,
  featuresWithGoodInsights,
  trainingOrCourses,
  upcomingFeatures,
  difficulties,
  otherSuggestions,
}
