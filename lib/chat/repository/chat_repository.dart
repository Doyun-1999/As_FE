import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepository = Provider((ref) {
  final dio = Dio();
  final baseUrl = BASE_URL;

  return ChatRepository(dio, ref, baseUrl: baseUrl);
});

class ChatRepository {
  final Dio dio;
  final String baseUrl;
  final Ref ref;

  ChatRepository(
    this.dio,
    this.ref, {
    required this.baseUrl,
  });

  // 채팅방 처음 들어가기 / 만들기
  Future<ChatDetails> enterChatting(MakeRoom data) async {
    final url = baseUrl + '/chatroom/enter/${data.userId}/${data.yourId}/${data.postId}';
    print("url : ${url}");
    final resp = await dio.get(url, data: data.toJson());
    print("채팅 데이터의 resp.statusCode : ${resp.statusCode}");
    print("채팅 데이터의 resp.data : ${resp.data}");
    return ChatDetails.fromJson(resp.data);
  }

  // 채팅방 데이터 가져오기
  Future<List<ChattingRoom>> getChattingRoomList() async {
    final memberId = ref.read(userProvider.notifier).getMemberId();
    final resp = await dio.get(
      BASE_URL + '/chatroom/list/${memberId}',
    );
    print("채팅방 데이터의 resp.statusCode : ${resp.statusCode}");
    print("채팅방 데이터의 resp.data : ${resp.data}");
    if ((resp.data as List).isEmpty) {
      return [];
    }
    final dataList =
        (resp.data as List).map((e) => ChattingRoom.fromJson(e)).toList();
    return dataList;
  }

  // SSE 연결 함수
  // Dio를 이용한 CustomSSE 방식 구현
  Stream<String> connectToSSE(int userId) async* {
    try {
      final response = await dio.get(
        BASE_URL + '/sse/connect',
        queryParameters: {"userId": userId},
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;

      print("Dio stream type : ${stream.runtimeType}");
      // StreamTransformer를 사용하여 데이터를 변환 (Uint8List => String)
      final transformer = StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data));
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(error, stackTrace);
        },
      );

      yield* stream.transform(transformer);
    } on DioException catch (e) {
      print("에러가 발생함");
      print("e.message : ${e.message}");
      print("e.response : ${e.response}");
      print("e.error : ${e.error}");
      print("e.requestOptions : ${e.requestOptions}");
      yield* Stream.error(e);
    }
  }
}
