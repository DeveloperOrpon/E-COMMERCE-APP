import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/page_switcher.dart';
import 'package:green_mart/views/screens/welcome_page.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_service.dart';
import '../../provider/product_provider.dart';

class LancherPage extends StatefulWidget {
  const LancherPage({Key? key}) : super(key: key);
  static const String routeName = "/lancherPage";

  @override
  State<LancherPage> createState() => _LancherPageState();
}

class _LancherPageState extends State<LancherPage> {
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        if (AuthService.currentUser != null) {
          userProvider.getUserInfo();
          userProvider.getAllUserOrderList();
          userProvider.getAdmin();

          Provider.of<ProductProvider>(context, listen: false)
              .getAllCategories();
          Provider.of<ProductProvider>(context, listen: false).getAllBrands();
          Provider.of<ProductProvider>(context, listen: false).getAllProducts();
          Provider.of<ProductProvider>(context, listen: false).getAllPurchase();
          Provider.of<ProductProvider>(context, listen: false).getUserInfo();
          Provider.of<ProductProvider>(context, listen: false)
              .getOrderConstrain();
          EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PageSwitcher()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WelcomePage()));
        }
        EasyLoading.dismiss();
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/images/app_logo.png"),
          ),
        ],
      ),
    );
  }
}
