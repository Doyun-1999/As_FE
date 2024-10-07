import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/model/block_model.dart';
import 'package:auction_shop/user/provider/block_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlockScreen extends ConsumerWidget {
  static String get routeName => 'block';
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blockProvider);

    // 로딩 화면 skeletion
    if(state is BlockLoading){
      final data = ref.read(blockProvider.notifier).getFakeData();
      return DefaultLayout(
        bgColor: auctionColor.subGreyColorF6,
        appBar: CustomAppBar().noActionAppBar(title: "차단 목록", context: context,),
        child: Skeletonizer(
          textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.3),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20,
              );
            },
            shrinkWrap: true,
            itemCount: data.list.length,
            itemBuilder: (context, index) {
              final blockData = data.list[index];
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    blockBox(ref, name: '${blockData.blockedMemberName}', id: blockData.id),
                  ],
                );
              }
              return blockBox(ref, name: '${blockData.blockedMemberName}', id: blockData.id);
            },
          ),
          ),
        ),
      );
    }

    // 실제 데이터 화면
    final data = state as BlockUserList;
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        func: (){
          context.pop();
        },
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          popupItem(text: "수정하기"),
        ],
        title: '차단 내역',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(blockProvider.notifier).getBlockUsers(isRefetching: true);
            },
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                );
              },
              shrinkWrap: true,
              itemCount: data.list.length,
              itemBuilder: (context, index) {
                final blockData = data.list[index];
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      blockBox(ref, name: '${blockData.blockedMemberName}', id: blockData.id),
                    ],
                  );
                }
                return blockBox(ref, name: '${blockData.blockedMemberName}', id: blockData.id);
              },
            ),
          ),
        ),
      ),
    );
  }

  Row blockBox(
    WidgetRef ref,
    {
    required String name,
    required int id,
  }) {
    return Row(
      children: [
        UserImage(
          size: 55,
        ),
        SizedBox(
          width: ratio.width * 17,
        ),
        Text(
          name,
          style: tsInter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            ref.read(blockProvider.notifier).blockUserRemove(id);
          },
          child: Text(
            '차단 해제',
            style: tsInter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: auctionColor.subGreyColorB6,
            ),
          ),
        ),
      ],
    );
  }
}
