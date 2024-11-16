import 'package:dio/dio.dart';
import 'package:auction_shop/common/dio/dio.dart';
import '../model/admin_notice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeRepository {
  final Dio dio;

  NoticeRepository({required this.dio});

  // 공지사항 게시 요청 (POST 요청)
  Future<Notice?> createNotice(Notice notice) async {
    try {
      Response response = await dio.post(
        '$BASE_URL/admin/notice', // BASE_URL을 포함하여 전체 경로 사용
        data: notice.toJsonForCreate(),
      );
      if (response.statusCode == 201) {
        print('공지사항 등록 완료');
        return Notice.fromJson(response.data); // 응답을 Notice 객체로 변환
      } else {
        print('공지사항 등록 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
    return null;
  }

  // 공지사항 수정 요청 (PUT 요청)
  Future<void> updateNotice(int id, Notice notice) async {
    try {
      Response response = await dio.put(
        '$BASE_URL/admin/notice/$id', // BASE_URL을 포함하여 전체 경로 사용
        data: notice.toJsonForUpdate(),
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

  // 공지사항 삭제 요청 (DELETE 요청)
  Future<void> deleteNotice(int id) async {
    try {
      Response response = await dio.delete(
        '$BASE_URL/admin/notice/$id', // BASE_URL을 포함하여 전체 경로 사용
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
