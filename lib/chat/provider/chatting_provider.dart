import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final chatInfoProvider = Provider.family<ChatDetails?, int>((ref, id){
  final data = ref.watch(chatProvider);

  final appliData = data.list.firstWhereOrNull((e) => e.roomId == id);
  if(appliData == null){
    return null;
  }

  return appliData;
});

final chatProvider = StateNotifierProvider<ChatNotifier, ChatModel>((ref){
  final repo = ref.watch(chatRepository);

  return ChatNotifier(repo: repo);
  }
);

class ChatNotifier extends StateNotifier<ChatModel> {

  final ChatRepository repo;

  ChatNotifier({
    required this.repo,
  }):super(ChatModel(list: []));

  // 채팅방 진입시
  // 1. 기존에 없는 채팅방이면 불러온 데이터를 추가,
  // 2. 기존에 있는 채팅방이라면 업데이트
  Future<void> enterChat(MakeRoom data) async {
    final resp = await repo.enterChatting(data);
    final roomId = resp.roomId;
    // roomId와 같은 채팅 내역 추출
    final chatData = state.list.firstWhereOrNull((e) => e.roomId == resp.roomId);

    // 만약 기존에 있던 채팅방이 아니라면,
    // 해당 채팅 내역을 모두 추가
    if(chatData == null){
      state = state.copyWith(list: [...state.list, resp]);
      return;
    }
    
    // 만약 기존에 채팅방이 새로 존재한다면
    // 채팅방 입장시 새로운 데이터를 기존 채팅방에 새로 업데이트한다.
    final newChatData = chatData.copyWith(chatLog: resp.chatLog, title: resp.title, currentPrice: resp.currentPrice);

    // 새로운 전체 채팅 데이터
    final newstate = state.list.map((e){
      if(e.roomId == roomId){
        return newChatData;
      }
      return e;
    });

    state = state.copyWith(list: [...newstate]);
  }

  // 채팅 데이터를 provider에 추가하기
  void addMessage({
    required Chatting chat,
    required int roomId,
  }){
    // roomId가 같은 채팅 내역 데이터
    final chatData = state.list.firstWhereOrNull((e) => e.roomId == roomId);
    
    // 챗 로그 데이터
    final pChatLog = chatData!.chatLog;

    // 업데이트된 새로운 챗 로그 데이터
    final newChatLog = chatData.copyWith(chatLog: [...pChatLog, chat]);

    // 새로운 전체 채팅 데이터
    final newstate = state.list.map((e){
      if(e.roomId == roomId){
        print("newChatLog : ${newChatLog.toJson()}");
        return newChatLog;
      }
      return e;
    });

    state = state.copyWith(list: [...newstate]);
  }
}