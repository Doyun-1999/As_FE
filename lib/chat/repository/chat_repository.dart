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
  final dio = ref.watch(dioProvider);
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

  void enterChatting(MakeRoom data) async {
    print(data.toJson());
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
      print("resp : ${resp}");
      print("resp.statusCode : ${resp.statusCode}");
      print("resp.data : ${resp.data}");
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
    } catch (error) {
      yield* Stream.error(error);
    }
  }

  // SSE 연결
  void sseConnect(int memberId) async {
    try {
      final resp = await dio.get(
        BASE_URL + '/sse/connect',
        queryParameters: {"userId": memberId},
        options: Options(responseType: ResponseType.stream),
      );

      final stream = resp.data.stream;
      print("resp.statusCode : ${resp.statusCode}");
      print("resp.data.toString : ${resp.data.toString()}");
      print("resp.data : ${resp.data}");
      print("resp.data.runTimeType : ${resp.data.runtimeType}");
      print("stream : ${stream}");

      // StreamTransformer를 사용하여 데이터를 변환
      final transformer = StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          print("data : ${data}");
          print("sink : ${sink}");
          sink.add(utf8.decode(data));
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(error, stackTrace);
        },
      );

      // 변환된 스트림에서 데이터 수신
      await for (String data in stream.transform(transformer)) {
        try {
          // SSE 메시지에서 "data: "로 시작하는 라인을 추출하여 JSON 파싱
          for (var line in data.split('\n')) {
            if (line.startsWith('data: ')) {
              final jsonData =
                  json.decode(line.substring(6)); // 'data: ' 이후 부분만 파싱
              print("json : ${jsonData}");
              print("jsonType : ${jsonData.runtimeType}");

              if (jsonData is Map<String, dynamic> &&
                  jsonData.containsKey('timeout')) {
                final timeout = jsonData['timeout'];
                if (timeout == 0) {
                  print("Timeout is set to 0, connection will be kept alive.");
                } else {
                  print("Timeout is set to $timeout");
                }
              } else {
                print("Received non-timeout message: $jsonData");
              }
            } else {
              print("Received non-data message: $line");
            }
          }
        } catch (e) {
          print('Error decoding data: $e');
        }
      }
    } catch (e) {
      print('Connection error: $e');
    }
  }
}
