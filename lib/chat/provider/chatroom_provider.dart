import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, List<ChattingRoom>>((ref){
  final repo = ref.watch(chatRepository);

  return ChatRoomNotifier(repo: repo);
}
);

class ChatRoomNotifier extends StateNotifier<List<ChattingRoom>> {

  final ChatRepository repo;

  ChatRoomNotifier({
    required this.repo,
  }):super([]);

  // 채팅방 데이터 얻기
  void getChattingRoomList() async {
    final resp = await repo.getChattingRoomList();
    state = resp;
  }

  // 채팅방이 존재하는지 판단하여
  // 1. 존재한다면 true를,
  // 2. 존재하지 않는다면 false를 반환한다.
  ChattingRoom? existChatRoom({
    required int productId,
    required int userId,
    required int yourId,
  }){
    final exist = state.firstWhereOrNull((e) => (e.userId == userId && e.yourId == yourId && e.postId == productId));
    return exist;
  }
}