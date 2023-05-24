import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/constant/helper_function.dart';
import 'package:green_mart/core/model/OrderModel.dart';
import 'package:green_mart/provider/product_provider.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/page_switcher.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllOrderDetails extends StatefulWidget {
  const AllOrderDetails({Key? key}) : super(key: key);

  @override
  State<AllOrderDetails> createState() => _AllOrderDetailsState();
}

class _AllOrderDetailsState extends State<AllOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Your Order details"),
          backgroundColor: AppColor.primary,
          leading: IconButton(
              onPressed: () {
                Get.offAll(PageSwitcher());
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: ListView.builder(
          itemCount: userProvider.orderList.length,
          itemBuilder: (context, index) =>
              _orderItemView(context, userProvider.orderList[index]),
        ),
      ),
    );
  }

  Consumer _orderItemView(BuildContext context, OrderModel orderList) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: MediaQuery.of(context).size.width,
              height: 80,
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
                      Row(
                        children: [
                          Text('Order Time :',
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                  fontSize: 10)),
                          SizedBox(width: 10),
                          Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(orderList.orderTime.toDate()),
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                  fontSize: 10)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Delivery Time',
                              style: TextStyle(
                                  color: AppColor.secondary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'poppins')),
                          SizedBox(width: 10),
                          Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(orderList.deliveryTime.toDate()),
                              style: const TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Delivery Type :',
                              style: TextStyle(
                                  color: AppColor.secondary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'poppins')),
                          const SizedBox(width: 10),
                          Text(orderList.deliveryType,
                              style: const TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                    ],
                  ),
                  Text(
                      "${calculateOverallTotal(calculateTotalCost(orderList.cartItems), calculateOverallDiscount(calculateTotalCost(orderList.cartItems), productProvider.orderConstantModel!.discount), (orderList.cartItems.length * productProvider.orderConstantModel!.vat))} $currencySymbol",
                      style: const TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            'Shipping const : ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'With Tex',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7)),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${orderList.cartItems.length * productProvider.orderConstantModel!.vat}$currencySymbol",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: const Text(
                      'Show Order Product',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary),
                    ),
                    children: orderList.cartItems
                        .map((cart) => InkWell(
                              onTap: () {
                                Get.to(
                                    ProductDetail(product: cart.productModel),
                                    transition: Transition.leftToRightWithFade);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                padding: const EdgeInsets.only(
                                    top: 5, left: 5, bottom: 5, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColor.border, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    // Image
                                    Container(
                                      width: 70,
                                      height: 70,
                                      margin: EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: AppColor.border,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            cart.productModel.thumbnailImageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                const SpinKitPianoWave(
                                          color: AppColor.primary,
                                          size: 50.0,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product Name
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            cart.productModel.productName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'poppins',
                                                color: AppColor.secondary),
                                          ),
                                          // Product Price - Increment Decrement Button
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Product Price
                                                Expanded(
                                                  child: Text(
                                                    '${cart.productModel.salePrice * (100 - cart.productModel.productDiscount) / 100}$currencySymbol X ${cart.count} ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'poppins',
                                                        color:
                                                            AppColor.primary),
                                                  ),
                                                ),
                                                // Increment Decrement Button
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 26,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: AppColor.primarySoft,
                                                  ),
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        (cart.productModel
                                                                    .salePrice *
                                                                (100 -
                                                                    cart.productModel
                                                                        .productDiscount) /
                                                                100 *
                                                                cart.count)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'poppins',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
