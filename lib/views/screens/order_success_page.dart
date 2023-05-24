import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/database/dbHelper.dart';
import 'package:green_mart/provider/product_provider.dart';
import 'package:green_mart/views/screens/page_switcher.dart';
import 'package:provider/provider.dart';

import '../../core/model/OrderModel.dart';
import 'all_order_details_page.dart';

class OrderSuccessPage extends StatefulWidget {
  final bool isDeliveryOnline;
  const OrderSuccessPage({super.key, required this.isDeliveryOnline});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  bool isOrderStatus = false;
  int count = 0;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      _sentOrder();
      count++;
    }
    return isOrderStatus && errorText == null
        ? Scaffold(
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              height: 184,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(const AllOrderDetails());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.primary,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColor.border,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Your Orders',
                        style: TextStyle(
                            color: AppColor.secondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const PageSwitcher()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'poppins'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            extendBody: true,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 124,
                    height: 124,
                    margin: EdgeInsets.only(bottom: 32),
                    child: SvgPicture.asset('assets/icons/Success.svg'),
                  ),
                  const Text(
                    'Order Success! 😆',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      'We have received your order',
                      style:
                          TextStyle(color: AppColor.secondary.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
        : errorText != null
            ? Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorText!,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Back Shopping Cart',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: 'poppins'),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitSpinningLines(
                      color: AppColor.primary,
                      size: 80.0,
                    ),
                    Text(
                      "Wait for order complete",
                      style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
  }

  Future<void> _sentOrder() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (provider.userModel!.wishList != null ||
        provider.userModel!.wishList!.isNotEmpty) {
      final orderModel = OrderModel(
          deliveryType:
              widget.isDeliveryOnline ? "Online Delivery" : "Cash-On Delivery",
          orderId: DateTime.now().millisecondsSinceEpoch.toString(),
          cartItems: provider.userModel!.wishList!,
          userInfo: provider.userModel!,
          deliveryTime: Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
              .add(const Duration(days: 7))
              .millisecondsSinceEpoch),
          orderTime: Timestamp.now());

      await DbHelper.addOrder(orderModel).then((value) async {
        await provider.deleteAllCartItem();
        setState(() {
          isOrderStatus = true;
        });
      }).catchError((onError) {
        setState(() {
          errorText = onError.toString();
          isOrderStatus = true;
        });
      });
    }
  }
}
