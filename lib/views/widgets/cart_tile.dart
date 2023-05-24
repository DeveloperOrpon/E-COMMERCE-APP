import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/constant/helper_function.dart';
import 'package:green_mart/core/model/Cart.dart';
import 'package:green_mart/provider/product_provider.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:provider/provider.dart';

class CartTile extends StatefulWidget {
  final Cart cart;
  final int index;
  const CartTile({super.key, required this.cart, required this.index});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => InkWell(
        onTap: () {
          startLoading();
          Get.to(ProductDetail(product: widget.cart.productModel),
              arguments: true, transition: Transition.leftToRightWithFade);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border, width: 1),
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
                  imageUrl: widget.cart.productModel.thumbnailImageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const SpinKitPianoWave(
                    color: AppColor.primary,
                    size: 50.0,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              // Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.cart.productModel.productName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          color: AppColor.secondary),
                    ),
                    // Product Price - Increment Decrement Button
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Product Price
                          Expanded(
                            child: Text(
                              '${((widget.cart.productModel.salePrice * (100 - widget.cart.productModel.productDiscount)) / 100)}$currencySymbol X ${widget.cart.count} ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'poppins',
                                  color: AppColor.primary),
                            ),
                          ),
                          // Increment Decrement Button
                          Container(
                            height: 26,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.primarySoft,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (widget.cart.count > 1) {
                                      widget.cart.count--;
                                      productProvider.updateProductInCart(
                                          widget.index, widget.cart.count);
                                    } else {
                                      productProvider
                                          .removeProductInCart(widget.index);
                                    }
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColor.primarySoft,
                                    ),
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${widget.cart.count}',
                                      style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.cart.count++;
                                    productProvider.updateProductInCart(
                                        widget.index, widget.cart.count);
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColor.primarySoft,
                                    ),
                                    child: const Text(
                                      '+',
                                      style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
