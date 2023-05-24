import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:green_mart/views/widgets/rating_tag.dart';

import '../../constant/helper_function.dart';

class ItemCard extends StatelessWidget {
  final ProductModel product;
  final Color titleColor;
  final Color priceColor;

  const ItemCard({
    super.key,
    required this.product,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetail(product: product)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Container(
              width: MediaQuery.of(context).size.width / 2 - 16 - 12,
              height: MediaQuery.of(context).size.width / 2 - 16 - 12,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnailImageUrl,
                      width: MediaQuery.of(context).size.width / 2 - 16 - 12,
                      height: MediaQuery.of(context).size.width / 2 - 16 - 12,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const SpinKitPianoWave(
                        color: AppColor.primary,
                        size: 44.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  RatingTag(
                    value: product.ratings!.isEmpty
                        ? 0.0
                        : calculateRating(product.ratings!),
                    margin: EdgeInsets.all(0),
                  ),
                ],
              ),
            ),

            // item details
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    product.productName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          '${(product.salePrice)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                            color: priceColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${product.salePrice * (100 - product.productDiscount) / 100} $currencySymbol',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: priceColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product.brandModel.brandName,
                    style: TextStyle(
                      color: titleColor == Colors.white
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 10,
                    ),
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
