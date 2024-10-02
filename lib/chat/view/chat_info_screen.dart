import 'dart:convert';
import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/provider/block_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'chatInfo';
  final ChattingRoom data;
  const ChatInfoScreen({
    required this.data,
    super.key,
  });

  @override
  ConsumerState<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends ConsumerState<ChatInfoScreen> {
  TextEditingController _textController = TextEditingController();

  late StompClient client = StompClient(
    config: StompConfig(
      url: 'ws://heybid.shop/ws',
      onConnect: onConnect,
      onDisconnect: onDisconnect,
      onWebSocketError: (error) => print('WebSocket error: $error'),
    ),
  );

  @override
  void initState() {
    super.initState();
    client.activate();
  }

  // 연결 성공 시 호출되는 콜백 함수
  void onConnect(StompFrame frame) {
    print('STOMP 연결 완료');

    // 서버에서 구독을 시작합니다.
    subscribeToTopic();

    // 메시지를 발행합니다.
    publishMessage();
  }

  // 연결 해제 시 호출되는 콜백 함수
  void onDisconnect(StompFrame frame) {
    print('STOMP 연결 해제됨');
  }

  // 구독을 통한 메시지 데이터 받아오기
  void subscribeToTopic() {
    // STOMP 클라이언트의 subscribe 메서드를 사용하여 토픽을 구독합니다.
    client.subscribe(
      headers: {'content-type': 'application/json'},
      destination: '/sub/chatroom/${widget.data.roomId}', // 구독할 토픽의 경로
      callback: (frame) {
        print("frame : ${frame}");
        print("frame.command : ${frame.command}");
        print("frame.binaryBody : ${frame.binaryBody}");
        print('Received message: ${frame.body}');
      },
    );
  }

  // 메시지 데이터 보내기
  void publishMessage() {
    if (_textController.text.isNotEmpty) {
      final msg = Message(
        roomId: widget.data.roomId,
        userId: widget.data.userId,
        message: _textController.text,
      );
      // STOMP 클라이언트의 send 메서드를 사용하여 메시지를 발행합니다.
      client.send(
        destination: '/pub/chatroom/${widget.data.roomId}', // 발행할 경로
        body: jsonEncode(msg),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // @override
  // void dispose() {
  //   onDisconnect;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> messages = [
      // "Hello!",
      // "Hi, how are you?",
      // "I'm good, thanks! How about you?",
      // "I'm doing well too.",
      // "Great to hear!",
      // "What's up?",
      // "Not much, just working on a project.Not much, just working on a project.Not much, just working on a project.",
      // "Cool! Tell me more about it."
    ];
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().allAppBar(popupList: [
        popupItem(text: "채팅방 나가기"),
        PopupMenuDivider(),
        popupItem(text: "계정 차단하기"),
      ], vertFunc: (val){
        if(val == "채팅방 나가기"){
          return;
        }
        if(val == "계정 차단하기"){
          ref.read(blockProvider.notifier).blockUser(int.parse(widget.data.userId));
          return;
        }
      }, title: widget.data.userId, context: context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            auctionInfoRow(
              title: "입찰중 서류 가방",
              startPrice: "5만원 시작",
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBox(
                    context,
                    msg: messages[index],
                    isMe: index % 2 == 0 ? false : true,
                  );
                },
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.add,
                  size: 40,
                  color: auctionColor.mainColor,
                ),
                Expanded(
                  child: CustomTextFormField(
                    borderColor: auctionColor.subGreyColorEF,
                    fillColor: auctionColor.subGreyColorEF,
                    filled: true,
                    controller: _textController,
                    hintText: '메시지 보내기',
                    contentPadding: const EdgeInsets.only(top: 0, bottom: 0, left: 20),
                    borderRadius: 100,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    publishMessage();
                  },
                  child: Transform.rotate(
                    angle: -45 * 3.14 / 180,
                    child: Icon(
                      Icons.send,
                      size: 30,
                      color: auctionColor.mainColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ratio.height * 35,
            ),
          ],
        ),
      ),
    );
  }

  IntrinsicHeight auctionInfoRow({
    required String title,
    required String startPrice,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 25,
              right: 15,
            ),
            decoration: BoxDecoration(
              color: auctionColor.subGreyColorCC,
              borderRadius: BorderRadius.circular(5),
            ),
            width: ratio.width * 56,
            height: ratio.height * 56,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    '$title',
                    style: tsNotoSansKR(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: auctionColor.subGreyColor94,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$startPrice',
                  style: tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: auctionColor.subGreyColor94,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Align ChatBox(
    BuildContext context, {
    required String msg,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          color: isMe ? auctionColor.mainColor : auctionColor.subGreyColorDB,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          msg,
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isMe ? Colors.white : auctionColor.subBlackColor49,
          ),
        ),
      ),
    );
  }

  Align isFirstChatBox(
    BuildContext context, {
    required String msg,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            margin: const EdgeInsets.only(bottom: 13, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
            decoration: BoxDecoration(
              color: auctionColor.subGreyColorDB,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              msg,
              style: tsNotoSansKR(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: auctionColor.subBlackColor49,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
