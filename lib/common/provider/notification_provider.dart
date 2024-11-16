import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auction_shop/notification/repository/notification_repository.dart';
import 'package:auction_shop/common/dio/dio.dart';

// notificationRepositoryProvider 정의
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepository(dio: dio);
});