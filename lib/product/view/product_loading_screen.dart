import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductLoadingScreen extends ConsumerWidget {
  const ProductLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // skeleton을 위한 가짜 데이터
    final data = [
      ProductModel(product_id: 0, title: '가짜 데이터 데이터', conditions: 'conditions', categories: [], tradeTypes: [], initial_price: 5000, current_price: 1000, productType: "DESCENDING", likeCount: 0, liked: false, bidCount: 0, createdBy: "", sold: true),
      ProductModel(product_id: 0, title: '가짜 데이터 데이터', conditions: 'conditions', categories: [], tradeTypes: [], initial_price: 5000, current_price: 1000, productType: "DESCENDING", likeCount: 0, liked: false, bidCount: 0, createdBy: "", sold: true),
      ProductModel(product_id: 0, title: '가짜 데이터 데이터', conditions: 'conditions', categories: [], tradeTypes: [], initial_price: 5000, current_price: 1000, productType: "DESCENDING", likeCount: 0, liked: false, bidCount: 0, createdBy: "", sold: true),
      ProductModel(product_id: 0, title: '가짜 데이터 데이터', conditions: 'conditions', categories: [], tradeTypes: [], initial_price: 5000, current_price: 1000, productType: "DESCENDING", likeCount: 0, liked: false, bidCount: 0, createdBy: "", sold: true),
      ProductModel(product_id: 0, title: '가짜 데이터 데이터', conditions: 'conditions', categories: [], tradeTypes: [], initial_price: 5000, current_price: 1000, productType: "DESCENDING", likeCount: 0, liked: false, bidCount: 0, createdBy: "", sold: true),
    ];
    return Skeletonizer(
      textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final model = data[index];
            return IntrinsicHeight(
              child: ProductCard.fromModel(
                model: model,
                isSkeletion: true,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: auctionColor.subGreyColorE2,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductInfoLoadingScreen extends StatelessWidget {
  const ProductInfoLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.3),
      child: ProductInfoScreen(
        isSkeleton: true,
        id: '0',
      ),
    );
  }
}