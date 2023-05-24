import 'package:flutter/material.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/helper_function.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_const.dart';

class AddToCartModal extends StatefulWidget {
  final ProductModel productModel;

  const AddToCartModal({super.key, required this.productModel});
  @override
  _AddToCartModalState createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<AddToCartModal> {
  int sumProduct = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Container(
        height: 190,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ----------
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 6,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColor.primarySoft,
              ),
            ),
            // Section 1 - increment button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.productModel.productName,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Color(0xFF0A0E2F).withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (sumProduct > 1) {
                            sumProduct--;
                          }
                        });
                      },
                      child: Icon(Icons.remove, size: 20, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.primary,
                        shape: CircleBorder(),
                        backgroundColor: AppColor.border,
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        sumProduct.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sumProduct++;
                        });
                      },
                      child: Icon(Icons.add, size: 20, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.primary,
                        shape: CircleBorder(),
                        backgroundColor: AppColor.border,
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  ],
                )
              ],
            ),
            // Section 2 - Total and add to cart button
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 18),
              padding: EdgeInsets.all(4),
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor.primarySoft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('TOTAL',
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'poppins')),
                          // ${(product.salePrice * (100 - product.productDiscount)) / 100}
                          Text(
                              "${((widget.productModel.salePrice * (100 - widget.productModel.productDiscount)) / 100) * sumProduct} $currencySymbol",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      onPressed: () {
                        productProvider.addProductInCart(
                            widget.productModel, sumProduct);
                        Navigator.pop(context);
                        showSnackBar(
                          'Information',
                          "Product Added To Cart",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'poppins'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
