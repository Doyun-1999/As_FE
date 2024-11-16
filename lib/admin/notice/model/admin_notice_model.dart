class Notice {
  final int id;
  final String title;
  final String content;
  final String date;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // 서버에서 받은 JSON 데이터를 Notice 객체로 변환하는 메서드
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['date'] ?? '', // date가 없을 때 대비
    );
  }

  // 공지사항 수정 요청에 필요한 title과 content만 포함하는 JSON 변환 메서드
  Map<String, dynamic> toJsonForUpdate() {
    return {
      'title': title,
      'content': content,
    };
  }

  // 공지사항 생성 요청 시 필요한 JSON 변환 메서드
  Map<String, dynamic> toJsonForCreate() {
    return {
      'title': title,
      'content': content,
    };
  }
}
