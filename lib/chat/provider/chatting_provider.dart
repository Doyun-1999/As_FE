import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatDetails>((ref){
  final repo = ref.watch(chatRepository);

  return ChatNotifier(repo: repo);
}
);

class ChatNotifier extends StateNotifier<ChatDetails> {

  final ChatRepository repo;

  ChatNotifier({
    required this.repo,
  }):super(ChatDetails(data: []));

  void enterChat(MakeRoom data) async {
    final resp = await repo.enterChatting(data);
  }

  void addMessage(Chatting chat){
    state.data.add(chat);
    print("state.data : ${state.data}");
  }
}