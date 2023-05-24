import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/Brand_model.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:provider/provider.dart';

import '../../constant/app_const.dart';
import '../../core/model/Product.dart';
import '../../core/model/category_model.dart';
import '../../provider/product_provider.dart';
import 'brand_ways_product_screen.dart';
import 'category_ways_product_screen.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;
  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchInputController = TextEditingController();
  List searchedProductData = [];
  @override
  void initState() {
    super.initState();
    searchInputController.text = widget.searchKeyword;
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: 40,
            child: TextField(
              enabled: false,
              autofocus: false,
              controller: searchInputController,
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
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: AppColor.secondary,
            child: TabBar(
              controller: tabController,
              indicatorColor: AppColor.accent,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins',
                  fontSize: 12),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'poppins',
                  fontSize: 12),
              tabs: const [
                Tab(
                  text: 'New',
                ),
                Tab(
                  text: 'Product',
                ),
                Tab(
                  text: 'Brand',
                ),
                Tab(
                  text: 'Category',
                ),
              ],
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) => TabBarView(
          controller: tabController,
          children: [
            // 1 - Related
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: productProvider.getNewProduct().length,
              itemBuilder: (context, index) =>
                  _searchResult(productProvider.getNewProduct()[index]),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: productProvider.allProductList.length,
              itemBuilder: (context, index) =>
                  _searchResult(productProvider.allProductList[index]),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: productProvider.brandList.length,
              itemBuilder: (context, index) => _searchBrand(
                  productProvider.brandList[index], productProvider),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: productProvider.categoryList.length,
              itemBuilder: (context, index) => _searchCategory(
                  productProvider.categoryList[index], productProvider),
            ),
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

  Container _searchBrand(
      BrandModel brandModel, ProductProvider productProvider) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        onTap: () {
          Get.to(BrandWaysProductScreen(brandModel: brandModel),
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
          tag: brandModel.brandImage,
          child: CachedNetworkImage(
            imageUrl: brandModel.brandImage,
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
          brandModel.brandName,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          "Total Product : ${productProvider.getProductByBrand(brandModel.brandId!).length}",
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Container _searchCategory(
      CategoryModel categoryModel, ProductProvider productProvider) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        onTap: () {
          Get.to(CategoryWaysProductScreen(categoryModel: categoryModel),
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
          tag: categoryModel.icon,
          child: CachedNetworkImage(
            imageUrl: categoryModel.icon,
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
          categoryModel.categoryName,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          "Total Product : ${productProvider.getProductByCategory(categoryModel.categoryId!).length}",
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
