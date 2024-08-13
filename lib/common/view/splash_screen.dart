import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
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
            Image.asset('assets/logo/main_logo_white.png'),
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 1,),
            CircularProgressIndicator(color: Colors.white,),
          ],
        ),
      ),
    );
  }
}
