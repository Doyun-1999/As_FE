import 'package:auction_shop/common/view/home_screen.dart';
import 'package:auction_shop/user/provider/auth_provider.dart';
import 'package:auction_shop/user/view/login_screen.dart';
import 'package:auction_shop/user/view/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
    
    List<GoRoute> routes = [
      GoRoute(
        path: '/',
        name: HomeScreen.routeName,
        builder: (_, __) => HomeScreen()
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.routeName,
        builder: (_, __) => LoginScreen()
      ),
      GoRoute(
        path: '/signup',
        name: SignupScreen.routeName,
        builder: (_, __) => SignupScreen()
      ),
    ];
    
    
    return GoRouter(
      routes: routes,
      initialLocation: '/login',
      redirect: (_, state) => ref.read(authProvider.notifier).redirectLogic(state)
    );
});