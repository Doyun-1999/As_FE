import 'dart:convert';
import 'package:auction_shop/chat/view/chat_info_screen.dart';
import 'package:auction_shop/chat/view/chat_list_screen.dart';
import 'package:auction_shop/common/view/splash_screen.dart';
import 'package:auction_shop/notification/view/notification_screen.dart';
import 'package:auction_shop/product/view/category_screen.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/product/view/product_revise_screen.dart';
import 'package:auction_shop/product/view/register/register_product_screen.dart';
import 'package:auction_shop/product/view/register/register_product_screen2.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/address_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/block_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/answer_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/my_interest_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/mybid_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/question_screen.dart';
import 'package:auction_shop/user/view/mypage_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/user/view/login_screen.dart';
import 'package:auction_shop/user/view/signup_screen.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref: ref);
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) : super() {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  // 라우터 리스트
  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => RootTab(),
          routes: [
            // 채팅
            GoRoute(
              path: 'chat',
              name: ChatListScreen.routeName,
              builder: (_, __) => ChatListScreen(),
              routes: [
                GoRoute(
                  path: 'info/:cid',
                  name: ChatInfoScreen.routeName,
                  builder: (_, __) => ChatInfoScreen(
                    id: __.pathParameters['cid']!,
                  ),
                ),
              ],
            ),

            // product category 내부에 info 화면을 라우팅하면
            // info 화면에도 카테고리 id를 전달해줘야하는 상황 발생
            // 따라서 라우팅을 따로 구성
            GoRoute(
              path: 'products/:cid',
              name: ProductCategoryScreen.routeName,
              builder: (_, __) => ProductCategoryScreen(
                index: int.parse(__.pathParameters['cid']!),
              ),
            ),
            GoRoute(
              path: 'info/:pid',
              name: ProductInfoScreen.routeName,
              // 경매 물품 상세 페이지 화면 전환 애니메이션 추가
              pageBuilder: (_, __) => CustomTransitionPage(
                child: ProductInfoScreen(
                  id: __.pathParameters['pid']!,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // 오른쪽 시작
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            ),

            // 알림
            GoRoute(
              path: 'notification',
              name: NotificationScreen.routeName,
              builder: (_, __) => NotificationScreen(),
            ),

            // 마이페이지
            GoRoute(
              path: 'mypage',
              name: MyPageScreen.routeName,
              builder: (_, __) => MyPageScreen(),
              routes: [
                GoRoute(
                  path: 'mybid',
                  name: MyBidScreen.routeName,
                  builder: (_, __) => MyBidScreen(),
                ),
                GoRoute(
                  path: 'block',
                  name: BlockScreen.routeName,
                  builder: (_, __) => BlockScreen(),
                ),
                GoRoute(
                  path: 'address',
                  name: AddressScreen.routeName,
                  builder: (_, __) => AddressScreen(),
                ),
                GoRoute(
                  path: 'interest',
                  name: MyInterestScreen.routeName,
                  builder: (_, __) => MyInterestScreen(),
                ),
                GoRoute(
                  path: 'answer',
                  name: AnswerScreen.routeName,
                  builder: (_, __) => AnswerScreen(),
                  routes: [
                    GoRoute(
                      path: 'question',
                      name: QuestionScreen.routeName,
                      builder: (_, __) => QuestionScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // 경매 물품 등록
        GoRoute(
          path: '/register',
          name: RegisterProductScreen.routeName,
          builder: (_, __) => RegisterProductScreen(),
          routes: [
            // 등록 두번째 페이지는 사용자가 입력한 데이터들을 전달해야한다.
            GoRoute(
              path: 'register2',
              name: RegisterProductScreen2.routeName,
              builder: (_, __) {
                // 이미지 데이터 리스트화
                final encodedImagePaths = __.uri.queryParameters['images'];
                final List<String> images = encodedImagePaths != null
                    ? List<String>.from(jsonDecode(encodedImagePaths))
                    : [];
                final title = __.uri.queryParameters['title']!;
                final place = __.uri.queryParameters['place']!;
                final details = __.uri.queryParameters['details']!;
                final category = __.uri.queryParameters['category']!;
                return RegisterProductScreen2(
                    images: images,
                    title: title,
                    place: place,
                    details: details,
                    category : category,
                    );
              },
            ),
            GoRoute(
              path: 'category',
              name: CategoryScreen.routeName,
              builder: (_, __) => CategoryScreen(),
            ),
          ],
        ),
        // 경매 물품 수정 화면
        GoRoute(
          path: '/revise',
          name: ProductReviseScreen.routeName,
          builder: (_, __) => ProductReviseScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: SignupScreen.routeName,
          builder: (_, __) => SignupScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
      ];

  // 앱을 처음 시작했을 때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정
  String? redirectLogic(GoRouterState gState) {
    print('redirect 실행');
    final UserModelBase? user = ref.read(userProvider);
    final isLoggin = gState.fullPath == '/login';
    final isSignup = gState.fullPath == '/signup';
    final isSplash = gState.fullPath == '/splash';

    // 유저 정보가 없고 로그인 중이라면
    // 로그인 화면로 이동
    if (user == null) {
      print('유저 정보가 없음');
      if (gState.fullPath == '/signup') {
        return '/signup';
      }
      return isLoggin ? null : '/login';
    }

    // 로딩 상태에는 스플래쉬 화면 출력
    if(user is UserModelLoading){
      return '/splash';
    }

    // 만약 유저가 앱내에서 회원가입이 진행되지 않은 회원이라면
    // 회원가입 화면으로 이동
    if (user is UserModelSignup) {
      return '/signup';
    }

    // 유저 정보가 존재한 상태에서
    // 로그인/회원가입/스플래쉬 화면이라면, 홈화면으로 이동
    if (user is UserModel) {
      print('로그인 상태');
      return (isLoggin || isSignup || isSplash) ? '/' : null;
    }

    // 유저 정보에 에러가 존재하고 로그인 상태가 아니라면
    // 로그인 화면으로 이동
    if (user is UserModelError) {
      print('에러');
      return '/login';
    }

    // 그 이외의 상황시에는 전부 null
    print('그 외 상황');
    return null;
  }
}
