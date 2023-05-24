import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../core/model/user_model.dart';
import '../../database/dbHelper.dart';
import '../../provider/product_provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorite List"),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) => productProvider
                    .userModel!.favoriteList!.isNotEmpty
                ? ListView.builder(
                    itemCount: productProvider.userModel!.favoriteList!.length,
                    itemBuilder: (context, index) => FutureBuilder(
                      future: DbHelper.getProductByPId(
                          productProvider.userModel!.favoriteList![index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final productModel =
                              ProductModel.fromMap(snapshot.data!.data()!);
                          return _wishListItem(
                              context, productModel, productProvider);
                        }
                        return const SpinKitPianoWave(
                          color: AppColor.primary,
                          size: 50.0,
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text("No Favorite Product Found"),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text(
                  "If Delete the favorite list element then long press the tile and delete item"),
            ),
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }

  GestureDetector _wishListItem(BuildContext context, ProductModel productModel,
      ProductProvider productProvider) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColor.primary,
              title: const Text(
                'Please confirm',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Do you want delete?',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                    final provider =
                        Provider.of<UserProvider>(context, listen: false);
                    var previousList = provider.userModel!.favoriteList;
                    previousList!.remove(productModel.productId);
                    provider
                        .updateUserProfileField(AuthService.currentUser!.uid, {
                      userFieldFavoriteList: previousList,
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade400,
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        height: 80,
        padding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 12),
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
                imageUrl: productModel.thumbnailImageUrl,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    overflow: TextOverflow.ellipsis,
                    productModel.productName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'poppins',
                        color: AppColor.secondary),
                  ),
                  // Product Price - Increment Decrement Button
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: () {
                _addToCart(productProvider, productModel);
              },
              child: Text("Add To Cart"),
            )
          ],
        ),
      ),
    );
  }

  void _addToCart(ProductProvider productProvider, ProductModel productModel) {
    productProvider.addProductInCart(productModel, 1);
  }
}
