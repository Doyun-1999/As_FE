// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetails _$ChatDetailsFromJson(Map<String, dynamic> json) => ChatDetails(
      data: (json['data'] as List<dynamic>)
          .map((e) => Chatting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatDetailsToJson(ChatDetails instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Chatting _$ChattingFromJson(Map<String, dynamic> json) => Chatting(
      id: json['id'] as String,
      roomId: (json['roomId'] as num).toInt(),
      userId: json['userId'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChattingToJson(Chatting instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'userId': instance.userId,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      roomId: (json['roomId'] as num).toInt(),
      userId: json['userId'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'userId': instance.userId,
      'message': instance.message,
    };

MakeRoom _$MakeRoomFromJson(Map<String, dynamic> json) => MakeRoom(
      userId: json['userId'] as String,
      postId: json['postId'] as String,
      yourId: json['yourId'] as String,
    );

Map<String, dynamic> _$MakeRoomToJson(MakeRoom instance) => <String, dynamic>{
      'userId': instance.userId,
      'postId': instance.postId,
      'yourId': instance.yourId,
    };

ChattingRoom _$ChattingRoomFromJson(Map<String, dynamic> json) => ChattingRoom(
      userId: json['userId'] as String,
      yourId: json['yourId'] as String,
      postId: json['postId'] as String,
      roomId: (json['roomId'] as num).toInt(),
    );

Map<String, dynamic> _$ChattingRoomToJson(ChattingRoom instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'yourId': instance.yourId,
      'postId': instance.postId,
      'roomId': instance.roomId,
    };

EnterChattingRoom _$EnterChattingRoomFromJson(Map<String, dynamic> json) =>
    EnterChattingRoom(
      userId: json['userId'] as String,
      yourId: json['yourId'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$EnterChattingRoomToJson(EnterChattingRoom instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'yourId': instance.yourId,
      'postId': instance.postId,
    };

FirstChat _$FirstChatFromJson(Map<String, dynamic> json) => FirstChat(
      id: json['id'] as String,
      roomId: (json['roomId'] as num).toInt(),
    );

Map<String, dynamic> _$FirstChatToJson(FirstChat instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
    };
