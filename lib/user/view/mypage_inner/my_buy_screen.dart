import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dropdown.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/user_bid_card.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:auction_shop/user/provider/my_buy_provider.dart';
import 'package:auction_shop/user/view/bidding_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBuyScreen extends ConsumerStatefulWidget {
  static String get routeName => "mybuy";
  const MyBuyScreen({super.key});

  @override
  ConsumerState<MyBuyScreen> createState() => _MyBuyScreenState();
}

class _MyBuyScreenState extends ConsumerState<MyBuyScreen> {

  final dropDownList = ["유력순", "최신순", "가격순"];
  String dropDownValue = "유력순";
  final appBarTitle = "낙찰 완료 목록";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(MyBuyProvider);

    // 데이터 받아오는 로딩 상태일 때
    if (state is CursorPaginationLoading) {
      return BiddingLoadingScreen(title: appBarTitle);
    }

    // 에러 발생했을 때
    if (state is CursorPaginationError) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: appBarTitle, context: context),
        child: Center(
          child: Text("에러가 발생했습니다."),
        ),
      );
    }

    // 데이터를 성공적으로 받아왔을 때
    final data = state as CursorPagination<MyBidModel>;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(MyBuyProvider.notifier).refetching();
      },
      child: DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: appBarTitle, context: context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              productDropdownButton(),
              productSliverList(data.data),
            ],
          ),
        ),
      ),
    );
  }

  // dropdown Widget
  // 최신순 / 유력순 / 가격순
  SliverToBoxAdapter productDropdownButton() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 20),
          ProductDropDown(
            onChanged: (val) {
              setState(() {
                if(val == dropDownList[0]){
                  ref.read(MyBuyProvider.notifier).sortState(0);
                }
                if(val == dropDownList[1]){
                  ref.read(MyBuyProvider.notifier).sortState(1);
                }
                if(val == dropDownList[2]){
                  ref.read(MyBuyProvider.notifier).sortState(2);
                }
                dropDownValue = val!;
              });
            },
            dropDownList: dropDownList,
            dropDownValue: dropDownValue,
          ),
        ],
      ),
    );
  }

  // 입찰 카드 데이터들
  SliverList productSliverList(List<MyBidModel> data) {
    return SliverList.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final model = data[index];
        return UserBidCard.fromModel(model: model);
      },
      // 구분선 Widget
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            color: auctionColor.subGreyColorE2,
          ),
        );
      },
    );
  }
}