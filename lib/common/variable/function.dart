import 'package:flutter/widgets.dart';

// ScrollController 이동 함수
void scrollToEnd(ScrollController controller) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(microseconds: 500),
      curve: Curves.easeOut,
    );
  }