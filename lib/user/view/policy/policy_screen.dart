import 'package:auction_shop/common/export/route_export.dart';
import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/view/policy/policy_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PolicyScreen extends ConsumerStatefulWidget {
  static String get routeName => "policy";
  const PolicyScreen({super.key});

  @override
  ConsumerState<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends ConsumerState<PolicyScreen> {
  List<bool> values = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // 뒤로 가기 버튼 누를 시,
      // 로그아웃 후 로그인 화면으로 이동
      appBar: CustomAppBar().noActionAppBar(title: "", context: context, func: (){
        ref.read(userProvider.notifier).logout();
        context.goNamed(LoginScreen.routeName);
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "헤이비드 서비스 이용 약관에\n동의해주세요.",
              style: tsNotoSansKR(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: ratio.height * 67),
          checkBoxRow(
            onChanged: (val){
            setState(() {
              if(val!){
                values = [true, true, true, true];
              }else{
                values[0] = val;
              }
            });
          }, text: "네, 모두 동의합니다.", value: values[0],),
          SizedBox(height: ratio.height * 54),
          checkBoxRow(onChanged: (val){
            setState(() {
              values[1] = val!;
            });
          }, text: "[필수] 헤이비드 서비스 이용약관 동의", value: values[1], func: (){
            context.pushNamed(PolicyInfoScreen.routeName, pathParameters: {"index" : "1"});
          },),
          checkBoxRow(onChanged: (val){
            setState(() {
              values[2] = val!;
            });
          }, text: "[필수] 개인 정보 수집 및 이용 동의.", value: values[2], func: (){
            context.pushNamed(PolicyInfoScreen.routeName, pathParameters: {"index" : "2"});
          },),
          checkBoxRow(onChanged: (val){
            setState(() {
              values[3] = val!;
            });
          }, text: "[선택] 마케팅 정보 수신에 대한 동의", value: values[3], func: (){
            context.pushNamed(PolicyInfoScreen.routeName, pathParameters: {"index" : "3"});
          },),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("해당 내용은 이용약관 및 정책에서도 확인이 가능합니다.", style: tsNotoSansKR(fontSize: 14, fontWeight: FontWeight.w400,),),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(text: "동의하고 회원가입", bgColor: (!values[1] || !values[2]) ? Colors.grey : auctionColor.mainColor, func: (){
              if(!values[1] || !values[2]){
                return;
              }
              context.pushNamed(SignupScreen.routeName);
            }),
          ),
          SizedBox(height: ratio.height * 60),
        ],
      ),
    );
  }

  // 체크박스가 있는 row
  checkBoxRow({
    required Function(bool?) onChanged,
    required String text,
    required bool value,
    VoidCallback? func,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: auctionColor.mainColor,
        ),
        Expanded(child: Text(text, style: tsNotoSansKR(fontSize: 14, fontWeight: func == null ? FontWeight.bold : FontWeight.w500,),),),
        if(func != null)
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: func,
            child: const Icon(Icons.arrow_forward_ios)),
        )
      ],
    );
  }
}
