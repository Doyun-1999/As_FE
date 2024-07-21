import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageScreen extends ConsumerWidget {
  static String get routeName => 'mypage';
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                ref.read(userProvider.notifier).logout();
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
