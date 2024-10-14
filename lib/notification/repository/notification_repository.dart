import 'package:dio/dio.dart';
import '../model/notification_model.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository({required this.dio});

  // 알림 목록 기능
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await dio.get('/alerts');
    final data = response.data as List;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // 알림 삭제 기능
  Future<void> deleteNotification(String id) async {
    await dio.delete('/alert', queryParameters: {'id': id});
  }
}