
import 'package:auction_shop/user/provider/auth_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    
    final provider = ref.read(authProvider);

    return GoRouter(
      routes: provider.routes,
      initialLocation: '/login',
      refreshListenable: provider,
      redirect: (_, state) {
        return provider.redirectLogic(state);
      }
    );
  },
);
