import 'dart:convert';
import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/export/route_export.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/provider/block_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auction_shop/chat/provider/chatting_provider.dart';
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
        print('Received message: ${frame.body}');
        if(frame.body == null){
          return;
        }
        final data = Chatting.fromJson((jsonDecode(frame.body!) as Map<String, dynamic>));
        ref.read(chatProvider.notifier).addMessage(data);
        print("frame : ${frame}");
        print("frame.command : ${frame.command}");
        print("frame.binaryBody : ${frame.binaryBody}");
        
      },
    );
  }

  // 메시지 데이터 보내기
  void publishMessage() async {
    if (_textController.text.isNotEmpty) {
      // 변수 설정
      // userId, createdAt
      final userId = ref.read(userProvider.notifier).getMemberId();
      final createdAt = DateTime.now();
      final msg = Message(
        roomId: widget.data.roomId,
        userId: userId,
        message: _textController.text,
      );
      final chat = Chatting(
        roomId: widget.data.roomId,
        userId: userId.toString(),
        message: _textController.text,
        createdAt: createdAt,
      );
      // STOMP 클라이언트의 send 메서드를 사용하여 메시지를 발행합니다.
      client.send(
        destination: '/pub/chatroom/${widget.data.roomId}', // 발행할 경로
        body: jsonEncode(msg),
        headers: {'content-type': 'application/json'},
      );

      ref.read(chatProvider.notifier).addMessage(chat);
    }
  }

  // @override
  // void dispose() {
  //   onDisconnect;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider).data;
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
          ref.read(blockProvider.notifier).blockUser(widget.data.userId);
          return;
        }
      }, title: widget.data.nickname, context: context),
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
              imgPath: widget.data.imageUrl
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final data = messages[index];
                  final myId = ref.read(userProvider.notifier).getMemberId();
                  return ChatBox(
                    context,
                    msg: data.message,
                    isOther: data.userId != myId,
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
    String? imgPath,
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
              color: imgPath  == null ? auctionColor.subGreyColorCC : null,
              borderRadius: BorderRadius.circular(5),
              image: imgPath  == null ? null : DecorationImage(image: NetworkImage(imgPath))
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
    required bool isOther,
  }) {
    return Align(
      alignment: isOther ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          color: isOther ? auctionColor.mainColor : auctionColor.subGreyColorDB,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          msg,
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isOther ? Colors.white : auctionColor.subBlackColor49,
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
