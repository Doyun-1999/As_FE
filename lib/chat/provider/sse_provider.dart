import 'dart:async';

import 'package:auction_shop/chat/provider/chatroom_provider.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SSEProvider = StateNotifierProvider((ref) {
  final repo = ref.watch(chatRepository);

  return SSENotifier(ref, repo: repo);
});

enum SSEConnectionStatus{
  connected,
  disconnected,
  error,
  connecting,
}

class SSENotifier extends StateNotifier<SSEConnectionStatus>{

  final ChatRepository repo;
  final Ref ref;

  SSENotifier(
    this.ref, {
    required this.repo,
  }):super(SSEConnectionStatus.disconnected);

  // SSE 연결
  // 결과값에 따라서 상태 변화
  void connect(int memberId) async {
    if(state == SSEConnectionStatus.connected){
      print("이미 연결됨");
      return;
    }
    try {
      final stream = repo.connectToSSE(memberId);
      // SSE 연동시 자동으로 채팅방 리스트 재요청
      ref.read(chatRoomProvider.notifier).paginate();

      stream.listen((data) {
        print("data : $data");
        // 데이터 수신 및 처리
        if (data.contains("data:")) {
          if (data.contains("0")) {
            print("연결 성공");
            print("data : ${data}");
            state = SSEConnectionStatus.connected;
          }
        }
      }, onError: (error) {
        print("연결 에러");
        state = SSEConnectionStatus.error;
        _reconnect();
      }, onDone: () {
        print("연결 완료돼서 해제");
        state = SSEConnectionStatus.disconnected;
        _reconnect();
      });
      print("연결 완료");
      state = SSEConnectionStatus.connected;
    } catch (error) {
      print("연결 에러");
      state = SSEConnectionStatus.error;
      _reconnect();
    }
  }

  // 재연결 요청
  void _reconnect() {
    if (state == SSEConnectionStatus.error || state == SSEConnectionStatus.disconnected) {
      print("재연결 시도 중...");
      final memberId = ref.read(userProvider.notifier).getMemberId();
      // 0.5초 후 재연결 시도
      Timer(Duration(milliseconds: 500), () => connect(memberId));
    }
  }
}