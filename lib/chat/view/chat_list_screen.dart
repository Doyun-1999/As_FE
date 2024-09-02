import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/provider/chatroom_provider.dart';
import 'package:auction_shop/chat/view/chat_info_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  static String get routeName => "chat";
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatRoomProvider);

    if (state is CursorPaginationLoading) {
      DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    if (state is CursorPaginationError) {
      DefaultLayout(
        child: Center(
          child: Text("error"),
        ),
      );
    }

    final data = (state as CursorPagination<ChattingRoom>).data;

    return DefaultLayout(
      appBar: CustomAppBar().noLeadingAppBar(
        popupList: [
          popupItem(text: "Example"),
        ],
        vertFunc: (String? val) {
          print(val);
        },
        title: "채팅 모음",
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 34),
        child: CustomScrollView(
          slivers: [
            //topBar(),
            if (data.length == 0)
              SliverToBoxAdapter(
                child: Center(
                  child: Text("채팅방이 없습니다.", textAlign: TextAlign.center,),
                ),
              ),
            if (data.length != 0)
              SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: ChatListBox(
                      func: () async {
                        //getChatList(ref);
                        final extra = data[index];
                        context.goNamed(ChatInfoScreen.routeName, extra: extra);
                      },
                      username: 'userId : ${data[index].userId}',
                      date: "postId : ${data[index].postId}",
                      content: "yourId : ${data[index].yourId}",
                    ),
                  );
                },
              ),
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
              color: auctionColor.subBlackColor49,
            ),
          ),
          SizedBox(
            height: ratio.height * 40,
          ),
        ],
      ),
    );
  }

  GestureDetector ChatListBox({
    required String username,
    required String date,
    required String content,
    required VoidCallback func,
  }) {
    return GestureDetector(
      onTap: func,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
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
                            color: auctionColor.subBlackColor49,
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
      ),
    );
  }
}
