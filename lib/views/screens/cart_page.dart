import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/order_success_page.dart';
import 'package:green_mart/views/screens/page_switcher.dart';
import 'package:green_mart/views/screens/update_user_info.dart';
import 'package:green_mart/views/widgets/cart_tile.dart';
import 'package:provider/provider.dart';

import '../../constant/helper_function.dart';
import '../../provider/product_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isDeliveryOnline = true;
  final focusNode = FocusNode();
  final tranController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () {
                    _deleteCart(productProvider);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  )),
            )
          ],
          title: Column(
            children: [
              const Text('Your Cart',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              Text('${productProvider.userModel!.wishList!.length} items',
                  style: TextStyle(
                      fontSize: 14, color: Colors.green.withOpacity(0.7))),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: AppColor.primarySoft,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        // Checkout Button
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: AppColor.border, width: 1))),
          child: ElevatedButton(
            onPressed: () {
              if (productProvider.userModel!.wishList!.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Cart Is Empty!!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              }
              if (isDeliveryOnline) {
                if (tranController.text.length < 6) {
                  showSnackBar(
                      "Information", "Input Transition Number (6 digit)");
                  return;
                }
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OrderSuccessPage(isDeliveryOnline: isDeliveryOnline)));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 6,
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'poppins'),
                  ),
                ),
                Container(
                  width: 2,
                  height: 26,
                  color: Colors.white.withOpacity(0.5),
                ),
                Flexible(
                  flex: 6,
                  child: Text(
                    productProvider.userModel!.wishList != null
                        ? "${calculateTotalCost(productProvider.userModel!.wishList!)} $currencySymbol"
                        : '0.0 $currencySymbol',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'poppins'),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (productProvider.userModel!.wishList!.isNotEmpty)
              const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Tap the product for review !! 💛💛",
                    style: TextStyle(color: AppColor.primary),
                  ),
                ),
              ),
            productProvider.userModel!.wishList!.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CartTile(
                        cart: productProvider.userModel!.wishList![index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: productProvider.userModel!.wishList!.length,
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 164,
                          height: 164,
                          margin: EdgeInsets.only(bottom: 32),
                          child: SvgPicture.asset('assets/icons/Paper Bag.svg'),
                        ),
                        const Text(
                          'Empty Cart  ☹️',
                          style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 48, top: 12),
                          child: Text(
                            'Go to home and explore our interesting \nproducts and add to cart',
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.8)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PageSwitcher()));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            backgroundColor: AppColor.border,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Start Shopping',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
            // Section 2 - Shipping Information
            if (productProvider.userModel!.wishList!.isNotEmpty)
              Consumer<UserProvider>(
                builder: (context, userProvider, child) => Container(
                  margin: EdgeInsets.only(top: 24),
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.border, width: 1),
                  ),
                  child: Column(
                    children: [
                      // header
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Shipping information',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.secondary),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(const UpdateUserInformation());
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColor.primary,
                                shape: CircleBorder(),
                                backgroundColor: AppColor.border,
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/Pencil.svg',
                                width: 16,
                                color: AppColor.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Name
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: SvgPicture.asset(
                                  'assets/icons/Profile.svg',
                                  width: 18),
                            ),
                            Expanded(
                              child: Text(
                                userProvider.userModel!.displayName ??
                                    "No Name",
                                style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Address
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: SvgPicture.asset('assets/icons/Home.svg',
                                  width: 18),
                            ),
                            Expanded(
                              child: Text(
                                userProvider.userModel!.address ?? "No Address",
                                style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Phone Number
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: SvgPicture.asset(
                                  'assets/icons/Profile.svg',
                                  width: 18),
                            ),
                            Expanded(
                              child: Text(
                                userProvider.userModel!.phone ??
                                    "No Phone Number",
                                style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Section 3 - Select Shipping method
            if (productProvider.userModel!.wishList!.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 24),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.border, width: 1),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColor.primarySoft,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      // Content
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Select Shipping method',
                                  style: TextStyle(
                                      color:
                                          AppColor.secondary.withOpacity(0.7),
                                      fontSize: 10)),
                              const Text('Official Shipping',
                                  style: TextStyle(
                                      color: AppColor.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'poppins')),
                            ],
                          ),
                          const Text('Total Cost $currencySymbol',
                              style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Shipping',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.secondary),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '1-${productProvider.orderConstantModel!.deliveryTime} Days',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.secondary
                                            .withOpacity(0.7)),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    (productProvider
                                                .userModel!.wishList!.length *
                                            productProvider
                                                .orderConstantModel!.vat)
                                        .toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //discount
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Discount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.secondary),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '${productProvider.orderConstantModel!.discount} %',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.secondary
                                            .withOpacity(0.7)),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    calculateOverallDiscount(
                                            calculateTotalCost(productProvider
                                                .userModel!.wishList!),
                                            productProvider
                                                .orderConstantModel!.discount)
                                        .toStringAsFixed(1),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondary),
                              ),
                              Text(
                                productProvider.userModel!.wishList!.length
                                    .toString(),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primary),
                              ),
                              Text(
                                calculateOverallTotal(
                                        calculateTotalCost(productProvider
                                            .userModel!.wishList!),
                                        calculateOverallDiscount(
                                            calculateTotalCost(productProvider
                                                .userModel!.wishList!),
                                            productProvider
                                                .orderConstantModel!.discount),
                                        (productProvider
                                                .userModel!.wishList!.length *
                                            productProvider
                                                .orderConstantModel!.vat))
                                    .toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Online Delivery',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondary),
                              ),
                              CupertinoSwitch(
                                value: isDeliveryOnline,
                                onChanged: (value) {
                                  setState(() {
                                    isDeliveryOnline = !isDeliveryOnline;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '( If You Want To Cash-On Delivery Then Close The Switch of Online delivery )',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  color: Colors.red),
                            ),
                          ),

                          AnimatedOpacity(
                            opacity: isDeliveryOnline ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticInOut,
                            child: (isDeliveryOnline)
                                ? AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.primarySoft,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                      ),
                                      border: Border.all(
                                          color: AppColor.border, width: 1),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectableText.rich(
                                          TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              const TextSpan(
                                                  text:
                                                      'Bkash & Rocket Number :',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColor.secondary)),
                                              TextSpan(
                                                  text:
                                                      '0${productProvider.orderConstantModel!.phoneNumber}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: AppColor.primary,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          'Sent Money In this number and input transition number in field',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.secondary),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CupertinoTextField(
                                            focusNode: focusNode,
                                            controller: tranController,
                                            placeholder: 'Transition Number',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _deleteCart(ProductProvider productProvider) {
    productProvider.deleteAllCartItem();
  }
}
