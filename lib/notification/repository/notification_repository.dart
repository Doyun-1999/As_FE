import 'package:auction_shop/common/dio/dio.dart';
import 'package:dio/dio.dart';
import '../model/notification_model.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository({required this.dio});

  // 공통 에러 처리 함수
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      print('요청 시간이 초과되었습니다.');
    } else if (e.type == DioExceptionType.badResponse) {
      print('서버 응답 오류: ${e.response?.statusCode}');
      print('응답 메시지: ${e.response?.data}');
    } else {
      print('네트워크 오류: ${e.message}');
    }
  }

  // 알림 목록 기능 (개선된 에러 처리 및 null과 Map 처리)
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await dio.get(BASE_URL + '/alerts');

      // 서버 응답이 null인 경우 처리
      if (response.data == null) {
        print('서버에서 null 데이터를 반환하였습니다.');
        return [];
      }

      // 서버 응답이 Map 형식인 경우 처리 (list 필드에 데이터를 포함)
      if (response.data is Map) {
        print('서버에서 Map 데이터를 반환하였습니다.');

        // 전체 Map 데이터를 확인하여 list 필드에서 데이터 추출
        final data = response.data['list'];
        if (data != null && data is List) {
          return data.map((json) => NotificationModel.fromJson(json)).toList();
        } else {
          print('Map 내에 list 필드가 없거나, 데이터가 List 형식이 아닙니다.');
          return [];
        }
      }

      // 예상치 못한 형식의 데이터 처리
      print('서버에서 예상하지 못한 형식의 데이터를 반환하였습니다: ${response.data.runtimeType}');
      return [];
    } on DioException catch (e) {
      // 공통 에러 처리 메서드 사용
      _handleDioError(e);
      return [];
    } catch (e) {
      // 기타 오류 발생 시
      print('알림 목록을 불러오는 중 알 수 없는 오류가 발생했습니다: $e');
      return [];
    }
  }

  //삭제
  Future<void> deleteNotification(String id) async {
    try {
      // String을 int로 변환
      final int notificationId = int.parse(id);

      print('요청 URL: $BASE_URL/alert');
      print('전송하는 long id 값: $notificationId');

      final response = await dio.delete(
        '$BASE_URL/alert',
        data: {'id': notificationId},  // request body로 전송
      );

      print('알림 삭제 완료');
    } on DioError catch (e) {
      // 에러 메시지 출력
      print('Error deleting notification: ${e.response?.data}');
      print('HTTP 상태 코드: ${e.response?.statusCode}');
      throw Exception('알림 삭제 중 오류가 발생했습니다.');
    }
  }

}



