class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}