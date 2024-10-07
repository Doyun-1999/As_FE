import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatDetails{
  final List<Chatting> data;

  ChatDetails({
    required this.data,
  });

  factory ChatDetails.fromJson(Map<String, dynamic> json) => _$ChatDetailsFromJson(json);
}

// 하나의 채팅 모델
@JsonSerializable()
class Chatting{
  // final String id;
  final int roomId;
  final String userId;
  final String message;
  final DateTime createdAt;

  Chatting({
    // required this.id,
    required this.roomId,
    required this.userId,
    required this.message,
    required this.createdAt
  });

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
  final int userId;
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

// 채팅방이 처음 만들어졌을 때
// 서버로부터 받는 roomid과 pk인 id
@JsonSerializable()
class FirstChat{
  final String id;
  final int roomId;

  FirstChat({
    required this.id,
    required this.roomId,
  });

  factory FirstChat.fromJson(Map<String, dynamic> json) => _$FirstChatFromJson(json);

  Map<String, dynamic> toJson() => _$FirstChatToJson(this);
}
