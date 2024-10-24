import 'package:auction_shop/common/dio/dio.dart';
import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

class NoticeRepository {
  final Dio dio = Dio();

  // 공지사항 수정 요청 (PUT 요청)
  Future<void> updateNotice(int id, Map<String, dynamic> updatedData) async {
    try {
      Response response = await dio.put(
        'https://yourapi.com/notices/$id',
        data: updatedData,
      );
      if (response.statusCode == 200) {
        print('공지사항 수정 완료');
      } else {
        print('공지사항 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 공지사항 등록 요청 (POST 요청)
  Future<void> createNotice(Map<String, dynamic> newNotice) async {
    try {
      Response response = await dio.post(
        'https://yourapi.com/notices',
        data: newNotice,
      );
      if (response.statusCode == 201) {
        print('공지사항 등록 완료');
      } else {
        print('공지사항 등록 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 공지사항 삭제 요청 (DELETE 요청)
  Future<void> deleteNotice(int id) async {
    try {
      Response response = await dio.delete(
        'https://yourapi.com/notices/$id',
      );
      if (response.statusCode == 200) {
        print('공지사항 삭제 완료');
      } else {
        print('공지사항 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }
}
