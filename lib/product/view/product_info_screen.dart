import 'package:auction_shop/common/view/default_layout.dart';
import 'package:flutter/widgets.dart';

class ProductInfoScreen extends StatelessWidget {
  static String get routeName => 'ProductInfo';
  const ProductInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('인포'),
      ),
    );
  }
}
