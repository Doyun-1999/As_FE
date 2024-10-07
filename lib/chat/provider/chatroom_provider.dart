import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, CursorPaginationBase>((ref){
  final repo = ref.watch(chatRepository);

  return ChatRoomNotifier(repo: repo);
}
);

class ChatRoomNotifier extends PaginationProvider<ChattingRoom, ChatRepository> {

  ChatRoomNotifier({
    required super.repo,
  });
}