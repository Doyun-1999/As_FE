import 'package:auction_shop/chat/model/chat_model.dart';
import 'package:auction_shop/chat/provider/chatroom_provider.dart';
import 'package:auction_shop/chat/provider/chatting_provider.dart';
import 'package:auction_shop/chat/view/chat_info_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/image_widget.dart';
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

    return DefaultLayout(
      appBar: CustomAppBar().noLeadingAppBar(
        popupList: [
          popupItem(text: "Example"),
        ],
        vertFunc: (String? val) {},
        title: "채팅 모음",
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 34),
        child: CustomScrollView(
          slivers: [
            // 간격
            SliverToBoxAdapter(child: SizedBox(height: 45),),
            //topBar(),
            // 채팅방 데이터가 없으면
            // 아무것도 UI 표시하지 않는다.
            if (state.length == 0)
              SliverToBoxAdapter(child: SizedBox())
            else if (state.length != 0)
              SliverList.separated(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  final data = state[index];
                  return ChatListBox(
                    nickname: data.nickname,
                    latestChatLog: data.latestChatLog,
                    latestChatTime: data.latestChatTime == null ? '-' : data.latestChatTime.toString(),
                    productImageUrl: data.imageUrl,
                    userImageUrl: data.profileUrl,
                    func: () async {
                      final extra = state[index];
                      final enterData = MakeRoom(
                          userId: extra.userId,
                          postId: extra.postId,
                          yourId: extra.yourId,);
                      ref.read(chatProvider.notifier).enterChat(enterData);
                  
                      context.pushNamed(ChatInfoScreen.routeName,
                          extra: extra);
                    },
                  );
                },
                separatorBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: auctionColor.subGreyColorE2),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector ChatListBox({
    required String nickname,
    String? latestChatTime,
    String? latestChatLog,
    String? productImageUrl,
    String? userImageUrl,
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
                color: productImageUrl == null ? auctionColor.subGreyColorCC : null,
                borderRadius: BorderRadius.circular(5),
                image: productImageUrl == null ? null : DecorationImage(image: NetworkImage(productImageUrl))
              ),
              width: 56,
              height: 56,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserImage(size: 25, imgPath: userImageUrl,),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        child: Text(
                          nickname,
                          style: tsNotoSansKR(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: auctionColor.subBlackColor49,
                          ),
                        ),
                      ),
                      Text(
                        latestChatTime ?? '없음',
                        style: tsNotoSansKR(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: auctionColor.subGreyColor94,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    latestChatLog ?? '-',
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
