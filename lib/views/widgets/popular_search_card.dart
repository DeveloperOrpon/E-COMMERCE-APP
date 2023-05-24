import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/Product.dart';

class PopularSearchCard extends StatelessWidget {
  final ProductModel productModel;
  final VoidCallback onTap;

  const PopularSearchCard(
      {super.key, required this.productModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width / 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColor.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: productModel.thumbnailImageUrl,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const SpinKitPianoWave(
                  color: AppColor.primary,
                  size: 30.0,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                productModel.productName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
