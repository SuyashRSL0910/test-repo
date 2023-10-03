class T200AvailableClassesData {

  late String className;
  late String link;
  late String platform;
  late List<String> topics;

  T200AvailableClassesData({
    required this.className,
    required this.link,
    required this.platform,
    required this.topics,
  });

  T200AvailableClassesData.from(Map<dynamic, dynamic> data) {
    className = data['className'];
    link = data['link'];
    platform = data['platform'];
    topics = getStringList(data['topics']);
  }

  List<String> getStringList(List<Object?> topics) {
    return topics.map((e) {
      return e as String;
    }).toList();
  }
}
