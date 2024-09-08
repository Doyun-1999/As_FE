import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepository = Provider((ref) {
  final dio = Dio();
  final baseUrl = BASE_URL;

  return ChatRepository(dio, ref, baseUrl: baseUrl);
});

class ChatRepository extends BasePaginationRepository{
  final Dio dio;
  final String baseUrl;
  final Ref ref;

  ChatRepository(
    this.dio,
    this.ref, {
    required this.baseUrl,
  });

  Future enterChatting(MakeRoom data) async {
    final resp = await dio.get(BASE_URL + '/chatroom/enter', data: data.toJson());
    print("resp.statusCode : ${resp.statusCode}");
    print("resp.data : ${resp.data}");
    // return
  }

  // Dio를 이용한 CustomSSE 방식 구현
  // 채팅방 연결
  Future<CursorPagination<ChattingRoom>> paginate() async {
    final memberId = ref.read(userProvider.notifier).getMemberId();
    final resp = await dio.get(
        BASE_URL + '/chatroom/list/${memberId}',
      );
      print("resp.statusCode : ${resp.statusCode}");
      if((resp.data as List).isEmpty){
        return CursorPagination(data: []);
      }
      final data = {"data" : resp.data};
      final dataList = CursorPagination.fromJson(data, (json) => ChattingRoom.fromJson(json as Map<String, dynamic>));
      return dataList;
  }

  // SSE 연결 함수
  Stream<String> connectToSSE(int userId) async* {
    try {
      final response = await dio.get(
        BASE_URL + '/sse/connect',
        queryParameters: {"userId": userId},
        options: Options(responseType: ResponseType.stream),
      );


      final stream = response.data.stream;

      // StreamTransformer를 사용하여 데이터를 변환
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
