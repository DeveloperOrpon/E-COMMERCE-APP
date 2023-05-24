import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:green_mart/core/model/Brand_model.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:provider/provider.dart';

import '../../constant/app_color.dart';
import '../../constant/app_const.dart';
import '../../core/model/Product.dart';
import '../../provider/product_provider.dart';

class BrandWaysProductScreen extends StatelessWidget {
  final BrandModel brandModel;
  const BrandWaysProductScreen({Key? key, required this.brandModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(brandModel.brandName),
          backgroundColor: AppColor.primary,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(brandModel.brandImage),
                    fit: BoxFit.cover,
                    opacity: .2),
                color: AppColor.primarySoft,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: brandModel.brandImage,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const SpinKitPianoWave(
                        color: AppColor.primary,
                        size: 30.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    "Brand : ${brandModel.brandName}",
                    style: const TextStyle(
                      color: AppColor.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      "Total Product : ${productProvider.getProductByBrand(brandModel.brandId!).length}"),
                ],
              ),
            ),
            if (productProvider
                .getProductByBrand(brandModel.brandId!)
                .isNotEmpty)
              Column(
                children: productProvider
                    .getProductByBrand(brandModel.brandId!)
                    .map((e) => _productPreview(e))
                    .toList(),
              )
            else
              const Center(
                child: Text(
                  "No Product Found!!!!!!!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Container _productPreview(ProductModel product) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        onTap: () {
          Get.to(ProductDetail(product: product),
              transition: Transition.leftToRightWithFade);
        },
        tileColor: AppColor.primarySoft,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(14),
              topLeft: Radius.circular(14),
            ),
            side: BorderSide(
              color: AppColor.primary,
              width: 1,
            )),
        leading: Hero(
          tag: product.additionalImages[2],
          child: CachedNetworkImage(
            imageUrl: product.additionalImages[0],
            width: 65,
            height: 65,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                const SpinKitPianoWave(
              color: AppColor.primary,
              size: 50.0,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          product.productName,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          "${product.category.categoryName}(${product.brandModel.brandName})",
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
        ),
        trailing: Text(
          "${product.salePrice} $currencySymbol",
          style: const TextStyle(
              color: Colors.green, fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
