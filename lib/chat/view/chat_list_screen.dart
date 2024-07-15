import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatListScreen extends StatelessWidget {
  static String get routeName => "chat";
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 34),
        child: CustomScrollView(
          slivers: [
            topBar(),
            SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, index){
                return ChatListBox(username: '홍길동$index', date: "어제", content: '안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요');
            })
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter topBar() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ratio.height * 50,
          ),
          Text(
            "경매 채팅",
            style: tsNotoSansKR(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: auctionColor.subBlackColor2,
            ),
          ),
          SizedBox(
            height: ratio.height * 40,
          ),
        ],
      ),
    );
  }

  IntrinsicHeight ChatListBox(
      {required String username,
      required String date,
      required String content}) {
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
                Row(
                  children: [
                    Container(
                      width: ratio.width * 25,
                      height: ratio.height * 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: auctionColor.subGreyColorDB,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      child: Text(
                        username,
                        style: tsNotoSansKR(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: auctionColor.subBlackColor2,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: tsNotoSansKR(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: auctionColor.subGreyColor94,
                      ),
                    ),
                  ],
                ),
                Text(
                  content,
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
          )
        ],
      ),
    );
  }
}
