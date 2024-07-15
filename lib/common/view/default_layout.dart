import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final BottomNavigationBar? bottomNavigationBar;
  final AppBar? appBar;
  const DefaultLayout({
    required this.child,
    this.bgColor = Colors.white,
    this.bottomNavigationBar = null,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: bgColor,
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
