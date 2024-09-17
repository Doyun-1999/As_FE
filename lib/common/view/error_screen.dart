import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  static String get routeName => 'error';

  final String? route;
  const ErrorScreen({
    this.route,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            
            Image.asset(
              'assets/img/error.png',
              width: ratio.width * 180,
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              "오류가 발생했습니다.",
              style: tsNotoSansKR(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ratio.height * 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "다시 시도",
                func: (){
                  // 이동하라는 설정된 라우트가 있으면
                  // 해당 경로로 이동
                  if(route != null){
                    context.goNamed(route!);
                    return;
                  }
                  context.pop();
                },
              ),
            ),
            SizedBox(height: ratio.height * 60,),
          ],
        ),
      ),
    );
  }
}
