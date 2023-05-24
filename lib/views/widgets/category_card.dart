import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constant/app_color.dart';
import '../../core/model/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel data;
  final VoidCallback onTap;
  const CategoryCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          color: (true) ? Colors.white.withOpacity(0.10) : Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: data.icon,
                    width: 60,
                    fit: BoxFit.cover,
                    color: Colors.white,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            const SpinKitPianoWave(
                      color: AppColor.primary,
                      size: 30.0,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
            Expanded(
              child: Text(
                data.categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
