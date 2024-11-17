import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PolicyInfoScreen extends StatelessWidget {
  static String get routeName => "policy_info";
  final int index;
  const PolicyInfoScreen({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(title: "", context: context),
      child: mainWidget(),
    );
  }

  // 변수로 들어온 index에 따라 view가 달라진다.
  // 1) index = 1 (서비스 이용 약관)
  // 1) index = 2 (개인정보 수집 및 이용에 대한 안내)
  // 1) index = 3 (마케팅 정보 수신)
  Widget mainWidget(){
    if(index == 2){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("개인정보 수집 및 이용에 대한 안내 (필수)", style: tsNotoSansKR(fontSize: 14, fontWeight: FontWeight.bold,),),
            ),
            Image.asset('assets/img/personal_policy.png', width: double.infinity,),
          ],
        ),
      );
    }
    if(index == 3){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("마케팅 정보 수신에 대한 동의 (선택)", style: tsNotoSansKR(fontSize: 14, fontWeight: FontWeight.bold,),),
            ),
            Image.asset('assets/img/marketing_policy.png', width: double.infinity,),
          ],
        ),
      ); 
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(servicePolicy, style: tsNotoSansKR(fontSize: 12, fontWeight: FontWeight.w500,),),
          ],
        ),
      ),
    );
  }
}
