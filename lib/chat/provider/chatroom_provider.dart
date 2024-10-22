import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void getChattingRoomList() async {
    final resp = await repo.getChattingRoomList();
    state = resp;
  }
}