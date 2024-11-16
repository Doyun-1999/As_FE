class NotificationModel {
  final String id;
  final String memberId;
  final String type;
  final String content;
  //final String targetId; // 이동할 대상 페이지의 고유 ID

  NotificationModel({
    required this.id,
    required this.memberId,
    required this.type,
    required this.content,
    //required this.targetId,
  });

  // JSON 데이터로부터 NotificationModel 인스턴스를 생성하는 팩토리 메서드
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      memberId: json['memberId'],
      type: json['type'],
      content: json['content'],
      //targetId: json['targetId'], // 서버 응답의 targetId 필드 매핑
    );
  }

  // 객체를 JSON 형식으로 변환하는 메서드 (필요할 경우)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'type': type,
      'content': content,
      //'targetId': targetId,
    };
  }
}
