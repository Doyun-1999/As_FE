import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  final List<ChatDetails> list;

  ChatModel({
    required this.list,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  // copyWith 함수
  ChatModel copyWith({
    List<ChatDetails>? list,
  }) {
    return ChatModel(
      list: list ?? this.list,
    );
  }
}


@JsonSerializable()
class ChatDetails {
  final int roomId;
  final List<Chatting> chatLog;
  final int currentPrice;
  final String title;

  ChatDetails({
    required this.chatLog,
    required this.roomId,
    required this.title,
    required this.currentPrice,
  });
  
  // copyWith 함수
  ChatDetails copyWith({
    int? roomId,
    List<Chatting>? chatLog,
    int? currentPrice,
    String? title,
  }) {
    return ChatDetails(
      roomId: roomId ?? this.roomId,
      chatLog: chatLog ?? this.chatLog,
      currentPrice: currentPrice ?? this.currentPrice,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() => _$ChatDetailsToJson(this);

  factory ChatDetails.fromJson(Map<String, dynamic> json) => _$ChatDetailsFromJson(json);

}

// 하나의 채팅 모델
@JsonSerializable()
class Chatting {
  final int userId;
  final String message;
  final DateTime createdAt;

  Chatting({
    required this.userId,
    required this.message,
    required this.createdAt,
  });
  
  // copyWith 함수
  Chatting copyWith({
    int? userId,
    String? message,
    DateTime? createdAt,
  }) {
    return Chatting(
      userId: userId ?? this.userId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Chatting.fromJson(Map<String, dynamic> json) => _$ChattingFromJson(json);
}


// 메시지
@JsonSerializable()
class Message{
  final int roomId;
  final int userId;
  final String message;

  Message({
    required this.roomId,
    required this.userId,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

// 방 생성할 때 서버 전송 모델
@JsonSerializable()
class MakeRoom{
  final int userId;
  final int postId;
  final int yourId;

  MakeRoom({
    required this.userId,
    required this.postId,
    required this.yourId,
  });

  factory MakeRoom.fromJson(Map<String, dynamic> json) => _$MakeRoomFromJson(json);

  Map<String, dynamic> toJson() => _$MakeRoomToJson(this);
}

// 채팅 룸 데이터 모델
@JsonSerializable()
class ChattingRoom {
  // 현재 접속중인 유저의 아이디
  final int userId;
  // 상대방의 아이디
  final int yourId;
  final int postId;
  final int roomId;
  final String nickname;
  final String? imageUrl;
  final DateTime? latestChatTime;
  final String? latestChatLog;
  final String? profileUrl;

  ChattingRoom({
    required this.userId,
    required this.yourId,
    required this.postId,
    required this.roomId,
    required this.nickname,
    this.imageUrl,
    this.latestChatTime,
    this.latestChatLog,
    this.profileUrl,
  });

  factory ChattingRoom.fromJson(Map<String, dynamic> json) => _$ChattingRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChattingRoomToJson(this);
}

// 채팅 룸 들어갈 때 필요한 모델
@JsonSerializable()
class EnterChattingRoom {
  final String userId;
  final String yourId;
  final String postId;

  EnterChattingRoom({
    required this.userId,
    required this.yourId,
    required this.postId,
  });

  factory EnterChattingRoom.fromJson(Map<String, dynamic> json) => _$EnterChattingRoomFromJson(json);

  Map<String, dynamic> toJson() => _$EnterChattingRoomToJson(this);
}