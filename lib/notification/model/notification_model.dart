class NotificationModel {
  final String id;
  final String memberId;
  final String type;
  final String content;

  NotificationModel({
    required this.id,
    required this.memberId,
    required this.type,
    required this.content
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      memberId: json['memberId'],
      type: json['type'],
      content: json['content'],
    );
  }
}