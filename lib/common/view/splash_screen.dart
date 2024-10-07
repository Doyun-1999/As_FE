import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => "splash";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: auctionColor.mainColor,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6 * 1,),
            Image.asset(
              'assets/logo/main_logo_white.png',
              height: ratio.height * 150,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 8 * 1,),
            Image.asset('assets/img/loading.gif', width: ratio.width * 125, height: ratio.height * 125,),
            Spacer(),
            Text(
              "로그인 오류시 cs@juyo.com",
              style: tsNotoSansKR(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            SizedBox(height: ratio.height * 60),
          ],
        ),
      ),
    );
  }
}
