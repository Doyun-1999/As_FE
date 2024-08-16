import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductLoadingScreen extends ConsumerWidget {
  const ProductLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.read(productProvider.notifier).getFakeData();
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
