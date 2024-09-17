import 'package:auction_shop/common/view/error_screen.dart';
import 'package:auction_shop/payment/model/payment_model.dart';
import 'package:auction_shop/payment/repository/payment_repository.dart';
import 'package:auction_shop/payment/view/payment_complete_screen.dart';
import 'package:auction_shop/product/provider/product_detail_provider.dart';
import 'package:auction_shop/product/repository/bid_repository.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';

class PaymentScreen extends ConsumerWidget {
  final PurchaseData model;

  const PaymentScreen({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.read(userProvider.notifier).getDefaultAddress();
    final data = PaymentData(
      pg: 'html5_inicis', // PG사
      payMethod: 'card', // 결제수단
      name: '아임포트 결제', // 주문명
      merchantUid: 'IMP${DateTime.now()}', // 주문번호
      amount: model.price, // 결제금액
      buyerName: model.user.name, // 구매자 이름
      buyerTel: model.user.phone, // 구매자 연락처
      buyerEmail: model.user.email, // 구매자 이메일
      buyerAddr: '${address.address} ${address.detailAddress}', // 구매자 주소
      buyerPostcode: address.zipcode, // 구매자 우편번호
      appScheme: 'myapp', // 앱 URL scheme
      cardQuota: [2, 3], //결제창 UI 내 할부개월수 제한
    );
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('아임포트 결제'),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://blog.kakaocdn.net/dn/rbZbI/btrku2yqqgW/J5dUrSFJ5wJBwJhuyJdNEk/img.jpg',
                width: 200,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */ //imp85016820
      userCode: 'imp06856072',
      /* [필수입력] 결제 데이터 */
      data: data,
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) async {
        final resultData = PaymentResult.fromJson(result);
        print("result : ${resultData.toJson()}");
        print("data : ${data.toJson()}");
        await ref.read(PaymentRepositoryProvider).payment(productId: model.productId, impUid: resultData.imp_uid);
        // 만약 거래가 성공적으로 이루어지지 못했을 경우
        // 에러 화면으로 이동
        if(resultData.imp_success != "true"){
          context.goNamed(ErrorScreen.routeName, queryParameters: {"route" : '/'},);
          return;
        }
        // 거래가 만약 상향식 거래일 경우
        // 입찰 함수 실행
        if(!model.isDESCENDING){
          await ref.read(bidRepositoryProvider).pushBid(productId: model.productId, impUid: resultData.imp_uid);
        }
        // 입찰 / 결제 후 다시 해당 경매 물품에 대한 데이터 받아온 후
        // 결제 완료 화면으로 이동
        await ref.read(productDetailProvider.notifier).getProductDetail(productId: model.productId, isUpdate: true);
        return context.goNamed(PaymentCompleteScreen.routeName);
      },
    );
  }
}
