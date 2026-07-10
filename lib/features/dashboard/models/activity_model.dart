class ActivityModel {
  final String title;
  final String time;

  ActivityModel({required this.title, required this.time});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      title: json['title'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
    };
  }
}
