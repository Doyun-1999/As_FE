import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dropdown.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/bid_card.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:auction_shop/user/provider/my_bid_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyBiddingScreen extends ConsumerStatefulWidget {
  static String get routeName => "mybidding";
  const MyBiddingScreen({super.key});

  @override
  ConsumerState<MyBiddingScreen> createState() => _MyBiddingScreenState();
}

class _MyBiddingScreenState extends ConsumerState<MyBiddingScreen> {
  final dropDownList = ["유력순", "최신순", "가격순"];
  String dropDownValue = "유력순";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(MyBidProvider);

    // 데이터 받아오는 로딩 상태일 때
    if (state is CursorPaginationLoading) {
      final fakeData = [
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
      ];
      return RefreshIndicator(
        onRefresh: () async {
            ref.read(MyBidProvider.notifier).refetching();
          },
        child: DefaultLayout(
          appBar: CustomAppBar().noActionAppBar(title: "입찰 중 목록", context: context),
          child: Skeletonizer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  productDropdownButton(),
                  productSliverList(fakeData),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 에러 발생했을 때
    if (state is CursorPaginationError) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: "입찰 중 목록", context: context),
        child: Center(
          child: Text("에러가 발생했습니다."),
        ),
      );
    }

    // 데이터를 성공적으로 받아왔을 때
    final data = state as CursorPagination<MyBidModel>;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(MyBidProvider.notifier).refetching();
      },
      child: DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: "입찰 중 목록", context: context),
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
                  ref.read(MyBidProvider.notifier).sortState(0);
                }
                if(val == dropDownList[1]){
                  ref.read(MyBidProvider.notifier).sortState(1);
                }
                if(val == dropDownList[2]){
                  ref.read(MyBidProvider.notifier).sortState(2);
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
        final date =
            "${model.bidTime.year}.${model.bidTime.month}.${model.bidTime.day}";
        return Column(
          children: [
            // Product의 데이터를 담은 Row
            ProductInfo(
              productId: model.productId,
              title: model.title,
              initial_price: model.initial_price,
              current_price: model.current_price,
              imageUrl: model.imageUrl,
            ),
            SizedBox(height: 12),
            // 경매 이력 Box
            BidCard(
              rightSideText: (model.bidStatus != "FAILED") ? "유력" : "",
              bottomMargin: 0,
              isNow: (model.bidStatus != "FAILED"),
              date: date,
              price: model.amount,
              isImage: false,
            ),
          ],
        );
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

  Row ProductInfo({
    String? imageUrl,
    required String title,
    required int initial_price,
    required int current_price,
    required int productId,
  }) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: imageUrl == null ? auctionColor.subGreyColorD9 : null,
            image: imageUrl == null ? null : DecorationImage(image: NetworkImage(imageUrl)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: tsNotoSansKR(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "${formatToManwon(initial_price)} 시작",
                style: tsNotoSansKR(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${formatToManwon(current_price)} 입찰 중",
                style: tsNotoSansKR(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(onPressed: (){
          print("눌려");
          context.pushNamed(ProductInfoScreen.routeName, pathParameters: {"pid" : productId.toString()});
        }, icon: Icon(Icons.arrow_forward_ios)),
      ],
    );
  }
}
