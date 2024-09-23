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
      

      stream.listen((data) {
        // 처음 데이터 수신 시에 연결 상태를 업데이트
        if (state != SSEConnectionStatus.connected) {
          state = SSEConnectionStatus.connected;
          print("연결 완료");
          print("state : ${state}");
        }
        ref.read(chatRoomProvider.notifier).paginate();
      }, onError: (error) {
        state = SSEConnectionStatus.error;
        print("연결 에러");
        print("state : ${state}");
        _reconnect();
      }, onDone: () {
        state = SSEConnectionStatus.disconnected;
        print("연결 완료돼서 해제");
        print("state : ${state}");
        _reconnect();
      });
      state = SSEConnectionStatus.connected;
      print("연결 완료");
      print("state : ${state}");
    } catch (error) {
      state = SSEConnectionStatus.error;
      print("연결 에러");
      print("state : ${state}");
      _reconnect();
    }
  }

  // 재연결 요청
  void _reconnect() {
    if (state == SSEConnectionStatus.error || state == SSEConnectionStatus.disconnected) {
      print("재연결 시도 중...");
      print("재연결 시도중 현재 state : ${state}");
      final memberId = ref.read(userProvider.notifier).getMemberId();
      // 0.5초 후 재연결 시도
      Timer(Duration(milliseconds: 500), () => connect(memberId));
    }
  }
}