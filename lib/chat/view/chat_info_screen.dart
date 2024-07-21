import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatInfoScreen extends StatelessWidget {
  static String get routeName => 'chatInfo';
  final String id;
  const ChatInfoScreen({
    required this.id,
    super.key,
  });

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
          '홍길동$id',
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
      child: Column(
        children: [
          SizedBox(height: 20,),
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
              Icon(Icons.add)
            ],
          )
        ],
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
              left: 20,
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
          SizedBox(width: 25,),
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
        margin: const EdgeInsets.only(bottom: 13, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          color: auctionColor.subGreyColorDB,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(msg),
      ),
    );
  }
}
