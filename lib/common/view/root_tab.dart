import 'package:auction_shop/chat/view/chat_list_screen.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/view/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:auction_shop/common/view/home_screen.dart';
import 'package:auction_shop/common/layout/default_layout.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller; //'?'를 사용하는건 비효율적 -> 사용할 때마다 null인지 확인해야함
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this); //vsync 를 사용하려면 with SingleTickerProviderStateMixin를 같이 사용해야함
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(),
          ChatListScreen(),
          Center(child: Text('3'),),
          Center(child: Text('4'),),
          MyPageScreen(),
        ]
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: auctionColor.mainColor,),
        unselectedIconTheme: IconThemeData(color: auctionColor.subGreyColor9E,),
        selectedLabelStyle: TextStyle(fontSize: 12, color: auctionColor.subGreyColor9E,),
        unselectedLabelStyle: TextStyle(fontSize: 12, color: auctionColor.subGreyColor9E,),
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30,), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded, size: 30,), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 30,), label: '상품등록'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined, size: 30,), label: '알림'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 30,), label: '내정보'),
        ],
      ),
    );
  }
}
