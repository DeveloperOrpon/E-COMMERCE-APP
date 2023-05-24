import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/provider/product_provider.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:green_mart/views/screens/search_result_page.dart';
import 'package:green_mart/views/widgets/popular_search_card.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  List<ProductModel> searchList = [];
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: AppColor.primary,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: SvgPicture.asset(
              'assets/icons/Arrow-left.svg',
              color: Colors.white,
            ),
          ),
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: searchController,
              onTap: () {
                setState(() {
                  isSearch = true;
                });
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  searchList = [];

                  setState(() {});
                  return;
                }
                searchList = productProvider.allProductList
                    .where((element) =>
                        element.productName
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) ||
                        element.brandModel.brandName
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                    .toList();

                setState(() {});
              },
              autofocus: false,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.3)),
                hintText: 'Find a products...',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/icons/Search.svg',
                      color: Colors.white),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1), width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
              ),
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Advance Search.',
                    style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.to(SearchResultPage(searchKeyword: ''));
                      },
                      icon: const Icon(Icons.filter_alt_sharp))
                ],
              ),
            ),
            Column(
              children: searchList.map((e) => _searchResult(e)).toList(),
            ),
            if (isSearch && searchList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "No Product Found!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

            // Section 2 - Popular Search
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (searchList.isEmpty)
                  Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                        productProvider.allProductList.length > 4
                            ? 4
                            : productProvider.allProductList.length, (index) {
                      return PopularSearchCard(
                        productModel: productProvider.allProductList[index],
                        onTap: () {
                          Get.to(ProductDetail(
                              product: productProvider.allProductList[index]));
                        },
                      );
                    }),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _searchResult(ProductModel product) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        onTap: () {
          Get.to(ProductDetail(product: product),
              transition: Transition.leftToRightWithFade);
        },
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
          overflow: TextOverflow.ellipsis,
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
