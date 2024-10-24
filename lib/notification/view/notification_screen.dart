import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
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
  // 선택 삭제 모드를 관리하는 상태 변수
  bool isSelectMode = false;

  // 더미 데이터를 리스트로 추가
  List<NotificationModel> notifications = [];
  List<String> selectedNotifications = []; // 선택된 알림 ID 목록


// 선택된 알림 삭제 기능
  Future<void> _deleteSelectedNotifications() async {
    if (selectedNotifications.isEmpty) return;

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('선택한 알림을 삭제하시겠습니까?'),
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

      // 서버에서 선택된 알림 삭제
      for (var id in selectedNotifications) {
        await repository.deleteNotification(id);
      }

      // 로컬 상태에서 선택된 알림 즉시 제거
      setState(() {
        notifications.removeWhere((notification) => selectedNotifications.contains(notification.id));
        selectedNotifications.clear();
        isSelectMode = false; // 선택 삭제 모드를 비활성화
      });

      // 서버 데이터와 동기화
      ref.refresh(notificationProvider);
    }
  }


// 전체 알림 삭제 기능
  Future<void> _deleteAllNotifications() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('삭제 확인'),
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

      // 서버에서 모든 알림 삭제
      final notificationsToDelete = await repository.fetchNotifications();
      for (var notification in notificationsToDelete) {
        await repository.deleteNotification(notification.id);
      }
      // 서버 데이터와 동기화
      ref.refresh(notificationProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncNotifications = ref.watch(notificationProvider); // 서버에서 가져온 알림 데이터

    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().noLeadingAppBar(
        vertFunc: (String? val) {
          // Optional: handle any specific logic for vertFunc if needed
        },
        popupList: [
          PopupMenuItem(
            value: 'select_delete',
            child: Text('선택 삭제'),
          ),
          PopupMenuItem(
            value: 'delete_all',
            child: Text('전체 삭제'),
          ),
        ],
        onPopupItemSelected: (value) {
          if (value == 'select_delete') {
            setState(() {
              isSelectMode = true; // 선택 삭제 모드를 활성화
            });
          } else if (value == 'delete_all') {
            _deleteAllNotifications();
          }
        },
        title: '알림',
      ),
      child: SafeArea(
        child: asyncNotifications.when(
          data: (notifications) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 6); // 각 알림 간 간격을 6으로 설정
                      },
                      shrinkWrap: true, // 알림 목록이 늘어날 때 ListView 크기를 자동으로 조정
                      itemCount: notifications.length, // 서버에서 가져온 알림의 개수만큼 리스트 항목 생성
                      itemBuilder: (context, index) {
                        final notification = notifications[index]; // 서버에서 가져온 알림
                        final isSelected = selectedNotifications.contains(notification.id); // 알림이 선택되었는지 확인

                        // 각 알림 항목을 notificationBox로 표시
                        return notificationBox(
                          type: notification.type,
                          content: notification.content,
                          selected: isSelected,
                          isSelectMode: isSelectMode,
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedNotifications.add(notification.id); // 선택된 항목 추가
                              } else {
                                selectedNotifications.remove(notification.id); // 선택 해제 시 삭제
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (isSelectMode && selectedNotifications.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _deleteSelectedNotifications, // 선택된 항목 삭제 호출
                      child: Text('삭제'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: auctionColor.mainColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(50), // 버튼 높이
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()), // 로딩 중일 때 로딩 아이콘 표시
          error: (error, stackTrace) => Center(child: Text('오류 발생: $error')), // 오류가 발생할 경우 오류 메시지 표시
        ),
      ),
    );
  }


// 알림 유형을 받아서 이미지 파일명으로 변환하는 changeText 함수
  String changeText({required String text}) {
    if (text == '채팅') {
      return 'chatting'; // 채팅에 맞는 이미지 파일명 반환
    } else if (text == '새로운 입찰') {
      return 'new_bid'; // 새로운 입찰에 맞는 이미지 파일명 반환
    } else if (text == '경매 제한 시간') {
      return 'limit_clock'; // 경매 제한 시간에 맞는 이미지 파일명 반환
    } else {
      return 'limit_hammer'; // 기타 경우에 대한 이미지 파일명 반환
    }
  }

  Container notificationBox({
    required String type,
    required String content,
    required bool selected,
    required bool isSelectMode, // 선택 삭제 모드인지 여부
    required Function(bool) onChanged, // 체크박스 상태 변경 함수
  }) {
    return Container(
      width: double.infinity,
      // 가로 길이를 최대한으로 설정
      margin: const EdgeInsets.symmetric(vertical: 8),
      // 상하 마진 추가
      padding: const EdgeInsets.all(16),
      // 내부 패딩 설정
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? auctionColor.mainColor : Colors.transparent,
          // 선택된 항목은 보라색 테두리
          width: 2,
        ),
        color: selected ? auctionColor.mainColor.withOpacity(0.1) : Colors
            .white, // 선택된 항목은 보라색 배경
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // 그림자 설정
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/img/${changeText(text: type)}.png', // 알림 타입에 따른 아이콘
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error); // 이미지 로딩 실패 시 대체 아이콘
                    },
                  ),
                  SizedBox(width: 12), // 아이콘과 텍스트 간의 간격
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type, // 알림 타입 텍스트
                          style: tsNotoSansKR(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: auctionColor.subGreyColorB6,
                          ),
                        ),
                        SizedBox(height: 4), // 타입과 콘텐츠 간 간격
                        Text(
                          content, // 알림 콘텐츠 텍스트
                          style: tsNotoSansKR(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black, // 콘텐츠 텍스트를 검정색으로 변경
                          ),
                          maxLines: 2, // 두 줄까지만 표시
                          overflow: TextOverflow.ellipsis, // 내용이 길 경우 말줄임표 처리
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 선택 삭제 모드일 때만 체크박스 표시
          if (isSelectMode)
          Positioned(
            top: 0, // 컨테이너의 상단에 위치
            right: 0, // 컨테이너의 오른쪽 끝에 위치
            child: GestureDetector(
              onTap: () {
                onChanged(!selected); // 이미지 클릭 시 상태 변경
              },
              child: Image.asset(
                selected
                    ? 'assets/icon/checkedbox.png'
                    : 'assets/icon/checkbox.png', // 선택 상태에 따른 이미지 변경
                width: 24, // 아이콘 너비 설정
                height: 24, // 아이콘 높이 설정
              ),
            ),
          ),
        ],
      ),
    );
  }
}



