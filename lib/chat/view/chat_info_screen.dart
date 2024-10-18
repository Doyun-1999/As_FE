import 'dart:convert';
import 'package:auction_shop/common/export/route_export.dart';
import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/provider/block_provider.dart';
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

  late int myId;

  late StompClient client = StompClient(
    config: StompConfig(
      url: 'ws://heybid.shop/ws',
      onConnect: onConnect,
      // onDisconnect: onDisconnect,
      onWebSocketError: (error) => print('WebSocket error: $error'),
    ),
  );

  @override
  void initState() {
    client.activate();
    myId = ref.read(userProvider.notifier).getMemberId();
    super.initState();
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
    final roomId = widget.data.roomId;
    // STOMP 클라이언트의 subscribe 메서드를 사용하여 토픽을 구독합니다.
    client.subscribe(
      headers: {'content-type': 'application/json'},
      destination: '/sub/chatroom/${roomId}', // 구독할 토픽의 경로
      callback: (frame) {
        print('Received message: ${frame.body}');
        if(frame.body == null){
          return;
        }
        if (!mounted) {
          print("끊겼다는데");
          return;
        }
        final data = Chatting.fromJson((jsonDecode(frame.body!) as Map<String, dynamic>));
        ref.read(chatProvider.notifier).addMessage(chat: data, roomId: roomId);
        print("frame : ${frame}");
        print("frame.command : ${frame.command}");
        print("frame.binaryBody : ${frame.binaryBody}");
        
      },
    );
  }

  // @override
  // void dispose() {
  //   print("Widget ${this.runtimeType} is disposed");
  //   super.dispose();
  // }

  // 메시지 데이터 보내기
  void publishMessage() async {
    final roomId = widget.data.roomId;
    if (_textController.text.isNotEmpty) {
      final msg = Message(
        roomId: roomId,
        userId: myId,
        message: _textController.text,
      );
      // STOMP 클라이언트의 send 메서드를 사용하여 메시지를 발행합니다.
      client.send(
        destination: '/pub/chatroom/${roomId}', // 발행할 경로
        body: jsonEncode(msg),
        headers: {'content-type': 'application/json'},
      );
      _textController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatInfo = ref.watch(chatInfoProvider(widget.data.roomId));
    if(chatInfo == null){
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: widget.data.nickname, context: context),
        child: Center(
          child: Text("에러가 발생했습니다."),
        ),
      );
    }
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().allAppBar(popupList: [
        popupItem(text: "채팅방 나가기"),
        PopupMenuDivider(),
        popupItem(text: "계정 차단하기"),
        PopupMenuDivider(),
        popupItem(text: "계정 신고하기"),
      ], vertFunc: (val){
        switch(val){
          case "채팅방 나가기":
          return;
          case "계정 차단하기":
          ref.read(blockProvider.notifier).blockUser(widget.data.userId);
          return;
          case "계정 신고하기":
          return;
        }
      }, title: widget.data.nickname, context: context,),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            auctionInfoRow(
              title: chatInfo.title,
              startPrice: "${formatToManwon(chatInfo.currentPrice)}",
              imgPath: widget.data.imageUrl
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chatInfo.chatLog.length,
                itemBuilder: (context, index) {
                  final data = chatInfo.chatLog[index];
                  return ChatBox(
                    context,
                    msg: data.message,
                    isEqual: data.userId == myId,
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
                    final createdAt = DateTime.now();
                    final chat = Chatting(
                      userId: myId,
                      message: _textController.text,
                      createdAt: createdAt,
                    );
                    //ref.read(chatProvider.notifier).addMessage(chat: chat, roomId: widget.data.roomId);
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

  // 경매 물품의 정보를 담고 있는 위젯
  // 제목, 현재 가격, 이미지
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

  // 하나의 채팅 박스
  Align ChatBox(
    BuildContext context, {
    required String msg,
    required bool isEqual,
  }) {
    return Align(
      alignment: isEqual ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          color: isEqual ? auctionColor.mainColor : auctionColor.subGreyColorDB,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          msg,
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isEqual ? Colors.white : auctionColor.subBlackColor49,
          ),
        ),
      ),
    );
  }

  // 첫 번째 채팅 박스
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
