class Notice {
  final int id;
  final String title;
  final String date;
  final String content;

  Notice({required this.id, required this.title, required this.date, required this.content});

  // 공지사항을 JSON 형태로 변환하거나 서버에서 가져올 때 사용할 수 있는 팩토리 메서드 예시
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      content: json['content'],
    );
  }

  // 공지사항을 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'content': content,
    };
  }
}
