import 'package:intl/intl.dart';

class FormatDate {
  static String formatTime(DateTime time) {
    DateTime now = DateTime.now();

    // 오늘 날짜와 비교
    if (isSameDay(now, time)) {
      // 한국어 locale 설정, 시간과 분까지 표시
      return DateFormat('a h시 mm분', 'ko').format(time); // '오후 4시 36분' 형식으로 출력
    } else if (isYesterday(now, time)) {
      // 어제일 경우
      return '어제';
    } else {
      // 그 외 (다른 날짜)
      return DateFormat('yyyy년 MM월 dd일', 'ko').format(time); // 예: 2024년 10월 10일
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static bool isYesterday(DateTime now, DateTime time) {
    DateTime yesterday = now.subtract(Duration(days: 1));
    return isSameDay(yesterday, time);
  }
}