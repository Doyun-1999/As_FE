import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatInfoScreen extends StatefulWidget {
  static String get routeName => 'chatInfo';
  final String id;
  //final IO.Socket socket = IO.io(BASE_URL + '/sub/room/', IO.OptionBuilder().setTransports(['websocket']).build());
  const ChatInfoScreen({
    required this.id,
    super.key,
  });

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> messages = [
      "Hello!",
      "Hi, how are you?",
      "I'm good, thanks! How about you?",
      "I'm doing well too.",
      "Great to hear!",
      "What's up?",
      "Not much, just working on a project.Not much, just working on a project.Not much, just working on a project.",
      "Cool! Tell me more about it."
    ];
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '홍길동${widget.id}',
          style: tsNotoSansKR(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: auctionColor.subBlackColor49),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.goNamed(RootTab.routeName);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
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
                Expanded(child: CustomTextFormField(controller: _textController, hintText: '메시지 보내기', borderRadius: 100,),),
                SizedBox(width: 10,),
                Transform.rotate(
                  angle: -45 * 3.14 / 180,
                  child: Icon(Icons.send,size: 30,color: auctionColor.mainColor,),),
              ],
            ),
            SizedBox(height: ratio.height * 35,),
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
