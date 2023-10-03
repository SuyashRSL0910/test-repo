class TechSeriesFeedbackPageArgument {

  TechSeriesFeedbackPageArgument({
    this.initialValue,
    required this.techSeriesTitles,
  });

  late String? initialValue;
  final List<String> techSeriesTitles;

  void setInitialValue(String initialValue) {
    this.initialValue = initialValue;
  }
}
