import 'package:auction_shop/common/variable/data.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

// ScrollController 이동 함수
void scrollToEnd(ScrollController controller) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(microseconds: 500),
      curve: Curves.easeOut,
    );
  }

// 리프레쉬 토큰 값 반환
String parseRefreshToken(String cookies) {
  // 쿠키 값을 세미콜론으로 분리합니다.
  final cookieList = cookies.split('; ');

  // 각 쿠키 값을 확인하여 'refresh='로 시작하는 값을 찾습니다.
  for (final cookie in cookieList) {
    if (cookie.startsWith('refresh=')) {
      // 'refresh=' 이후의 값을 반환합니다.
      final token = cookie.substring('refresh='.length).replaceAll('"', '');
      return token.split(';')[0];
    }
  }

  // 기본값 반환 (해당하는 쿠키가 없는 경우 처리)
  return '';
}

String getCategory(int index){
  final categoryData = category;
  return categoryData[index];
}