import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';

class OnButtonScreen extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final AppBar? appBar;
  final bool resizeToAvoidBottomInset;
  final CustomButton button;
  const OnButtonScreen({
    required this.child,
    this.bgColor = Colors.white,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    required this.button,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            child,
            Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: button,
                ),
                SizedBox(height: ratio.height * 59),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
