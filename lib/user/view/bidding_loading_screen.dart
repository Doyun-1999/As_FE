import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/user/component/user_bid_card.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BiddingLoadingScreen extends ConsumerWidget {
  final String title;
  const BiddingLoadingScreen({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fakeData = [
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
        MyBidModel(productId: 0, title: 'title', initial_price: 0, current_price: 0, amount: 0, bidTime: DateTime.now(), bidStatus: "FAILED"),
      ];
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: title, context: context),
        child: Skeletonizer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 50),
                ),
                productSliverList(fakeData),
              ],
            ),
          ),
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