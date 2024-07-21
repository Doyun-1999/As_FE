import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final BottomNavigationBar? bottomNavigationBar;
  final AppBar? appBar;
  final bool resizeToAvoidBottomInset;
  const DefaultLayout({
    required this.child,
    this.bgColor = Colors.white,
    this.bottomNavigationBar = null,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      backgroundColor: bgColor,
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
