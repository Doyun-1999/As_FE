import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentCompleteScreen extends ConsumerWidget {
  static String get routeName => "payment_complete";
  final String productId;
  const PaymentCompleteScreen({
    required this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.read(userProvider.notifier).getDefaultAddress();
    return DefaultLayout(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: ratio.height * 110),
            Image.asset('assets/img/payment_complete.png'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              margin: EdgeInsets.symmetric(vertical: ratio.height * 42, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: auctionColor.subGreyColorB6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${address.address}, ${address.zipcode}\n${address.detailAddress}",
                  textAlign: TextAlign.center,
                  style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Text(
              "결제가 완료되었습니다.\n해당 주소로 배송예정입니다.",
              style: tsNotoSansKR(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "확인",
                func: () {
                  context.goNamed(ProductInfoScreen.routeName, pathParameters: {'pid': (productId).toString()});
                },
              ),
            ),
            SizedBox(height: ratio.height * 60),
          ],
        ),
      ),
    );
  }
}
