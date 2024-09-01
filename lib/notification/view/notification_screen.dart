import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import 'package:auction_shop/notification/repository/notification_repository.dart';
import 'package:auction_shop/common/provider/notification_provider.dart';

final notificationProvider = FutureProvider<List<NotificationModel>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.fetchNotifications();
});

class NotificationScreen extends ConsumerStatefulWidget {
  static String get routeName => 'notification';
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  // 전체 알림 삭제 기능
  Future<void> _deleteAllNotifications() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('전체 삭제 확인'),
        content: Text('모든 알림을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final repository = ref.read(notificationRepositoryProvider);
      final notifications = await ref.read(notificationProvider.future);

      for (var notification in notifications) {
        await repository.deleteNotification(notification.id);
      }

      ref.refresh(notificationProvider);
    }
  }

  String changeText({
    required String text,
  }) {
    if (text == '채팅') {
      return 'chatting';
    } else if (text == '새로운 입찰') {
      return 'new_bid';
    } else if (text == '경매 제한 시간') {
      return 'limit_clock';
    } else {
      return 'limit_hammer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationAsyncValue = ref.watch(notificationProvider);

    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().noLeadingAppBar(
        vertFunc: (String? val) {
          print('object');
        },
        popupList: [
          PopupMenuItem(
            value: 'delete_all',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('전체 삭제'),
            ),
          ),
        ],
        onPopupItemSelected: (value) {
          if (value == 'delete_all') {
            _deleteAllNotifications();
          }
        },
        title: '알림',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: notificationAsyncValue.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return Center(child: Text('알림이 없습니다.'));
              }
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 11,
                  );
                },
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Dismissible(
                    key: Key(notification.id), // Dismissible 위젯에 고유 키 제공
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      // 개별 알림 삭제 요청
                      final repository = ref.read(notificationRepositoryProvider);
                      await repository.deleteNotification(notification.id);

                      // 알림 목록을 다시 불러옵니다.
                      ref.refresh(notificationProvider);
                    },
                    child: notificationBox(
                      type: notification.type,
                      title: notification.title,
                      content: notification.content,
                    ),
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('알림을 불러오는데 실패했습니다.')),
          ),
        ),
      ),
    );
  }

  Container notificationBox({
    required String type,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/img/${changeText(text: type)}.png'),
              SizedBox(
                width: 6.5,
              ),
              Text(
                type,
                style: tsNotoSansKR(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: auctionColor.subGreyColorB6,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 4,
            ),
            child: Text(
              title,
              style: tsNotoSansKR(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            content,
            style: tsNotoSansKR(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: auctionColor.subGreyColorB6,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

