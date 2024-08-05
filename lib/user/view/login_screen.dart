import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => "login";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);
    final storage = ref.watch(secureStorageProvider);

    return DefaultLayout(
      bgColor: auctionColor.mainColor,
      child: Container(
        //width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8 * 1,
            ),
            Image.asset(
              'assets/logo/main_logo_white.png',
              height: ratio.height * 150,
            ),
            Text('경매로 중고거래를 더 새롭게!',
                style: tsNotoSansKR(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                )),
            SizedBox(
              height: ratio.height * 100,
            ),
            loginContainer(
              imgPath: 'assets/logo/kakao_logo.png',
              text: "카카오톡으로 로그인",
              func: (state is UserModelLoading)
                  ? null
                  : () async {
                      await ref
                          .read(userProvider.notifier)
                          .login(platform: LoginPlatform.kakao);
                    },
              bgColor: (state is UserModelLoading)
                  ? auctionColor.subGreyColor94
                  : Color(0xFFFCDC55),
              textColor: auctionColor.subBlackColor3E24,
            ),
            loginContainer(
              imgPath: 'assets/logo/naver_logo.png',
              text: "네이버로 로그인",
              func: (state is UserModelLoading)
                  ? null
                  : () async {
                      await ref.read(userProvider.notifier).login(platform: LoginPlatform.naver);
                    },
              bgColor: (state is UserModelLoading)
                  ? auctionColor.subGreyColor94
                  : Color(0xFF45B649),
              textColor: Colors.white,
            ),
            loginContainer(
              imgPath: 'assets/logo/google_logo.png',
              text: "구글로 로그인",
              func: (state is UserModelLoading)
                  ? null
                  : () async {
                      await ref
                          .read(userProvider.notifier)
                          .login(platform: LoginPlatform.google);
                    },
              bgColor: (state is UserModelLoading)
                  ? auctionColor.subGreyColor94
                  : Colors.white,
              textColor: auctionColor.subBlackColor3E24,
            ),
            loginContainer(
                icon: Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                ),
                imgPath: null,
                text: "이메일 로그인∙회원가입",
                func: () async {
                  final refresh = await storage.read(key: REFRESH_TOKEN);
                  final access = await storage.read(key: ACCESS_TOKEN);
                  print(refresh);
                  print(access);
                },
                // func: (state is UserModelLoading) ? null : () {
                //   context.pushNamed(SignupScreen.routeName);
                // },
                borderColor: (state is UserModelLoading)
                    ? auctionColor.subGreyColor94
                    : Colors.white,
                bgColor: (state is UserModelLoading)
                    ? auctionColor.subGreyColor94
                    : null,
                textColor: Colors.white),
            Spacer(),
            Text(
              "로그인 오류시 cs@juyo.com",
              style: tsPretendard(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

GestureDetector loginContainer({
  Icon? icon = null,
  required String? imgPath,
  required String text,
  required VoidCallback? func,
  required Color? bgColor,
  Color? borderColor = null,
  required Color textColor,
}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: borderColor ?? bgColor!)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: icon ??
                  Image.asset(
                    imgPath!,
                    width: 30,
                  )),
          Align(
            alignment: Alignment.center,
            child: Text(text,
                style: tsNotoSansKR(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor,
                )),
          ),
        ],
      ),
    ),
  );
}
