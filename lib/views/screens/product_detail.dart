import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/app_const.dart';
import 'package:green_mart/constant/helper_function.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/core/model/Review.dart';
import 'package:green_mart/database/dbHelper.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/cart_page.dart';
import 'package:green_mart/views/screens/image_viewer.dart';
import 'package:green_mart/views/screens/reviews_page.dart';
import 'package:green_mart/views/widgets/custom_app_bar.dart';
import 'package:green_mart/views/widgets/modals/add_to_cart_modal.dart';
import 'package:green_mart/views/widgets/rating_tag.dart';
import 'package:green_mart/views/widgets/review_tile.dart';
import 'package:green_mart/views/widgets/selectable_circle_color.dart';
import 'package:green_mart/views/widgets/selectable_circle_size.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/model/user_model.dart';
import 'message_page.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel product;

  const ProductDetail({required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  final commentController = TextEditingController();
  final focusNode = FocusNode();
  double selectRating = 3.0;
  bool isDoReview = false;
  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments;
    isDoReview = args == null ? false : true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ProductModel product = widget.product;
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColor.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(right: 14),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.to(const MessagePage(),
                        transition: Transition.leftToRightWithFade);
                  },
                  child: SvgPicture.asset('assets/icons/Chat.svg',
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return AddToCartModal(
                            productModel: product,
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Add To Cart',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(left: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.to(const CartPage(),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: SvgPicture.asset('assets/icons/Bag.svg',
                          color: Colors.white),
                    ),
                  ),
                  if (userProvider.userModel!.wishList!.isNotEmpty)
                    Positioned(
                      right: -5,
                      top: -10,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.amber,
                        child: Text(
                          userProvider.userModel!.wishList!.length.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white),
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1 - appbar & product image
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // product image
                Hero(
                  tag: product.additionalImages[0],
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageViewer(imageUrl: product.additionalImages),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 310,
                      color: Colors.white,
                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        controller: productImageSlider,
                        children: List.generate(
                          product.additionalImages.length,
                          (index) => CachedNetworkImage(
                            imageUrl: product.additionalImages[index],
                            fit: BoxFit.fitHeight,
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
                      ),
                    ),
                  ),
                ),
                // appbar
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) => CustomAppBar(
                    title: product.category.categoryName,
                    leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                    rightIcon: SvgPicture.asset(
                      'assets/icons/Bookmark.svg',
                      color: Colors.black.withOpacity(0.5),
                    ),
                    leftOnTap: () {
                      Navigator.of(context).pop();
                    },
                    rightOnTap: () {
                      _saveAsFavorite(product, userProvider);
                    },
                  ),
                ),
                // indicator
                Positioned(
                  bottom: 16,
                  child: SmoothPageIndicator(
                    controller: productImageSlider,
                    count: product.additionalImages.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: AppColor.primary,
                      activeDotColor: Colors.amber,
                      dotHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            // Section 2 - product info
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.productName,
                            style: TextStyle(
                                fontSize:
                                    product.productName.length > 16 ? 18 : 24,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'poppins',
                                color: AppColor.secondary),
                          ),
                        ),
                        RatingTag(
                          margin: const EdgeInsets.only(left: 10),
                          value: product.ratings!.isEmpty ||
                                  product.ratings == null
                              ? 0.0
                              : calculateRating(product.ratings!),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Text(
                          '${product.salePrice} ',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'poppins',
                              decoration: TextDecoration.lineThrough,
                              color: AppColor.primary),
                        ),
                        Text(
                          '${(product.salePrice * (100 - product.productDiscount)) / 100} $currencySymbol',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'poppins',
                              color: AppColor.primary),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Product Information',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.justify,
                    product.shortDescription ?? '',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        height: 150 / 100),
                  ),
                  Text(
                    textAlign: TextAlign.justify,
                    product.longDescription ?? '',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        height: 150 / 100),
                  ),
                ],
              ),
            ),
            // Section 3 - Color Picker
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SelectableCircleColor(
                    colorWay: product.colors,
                    margin: const EdgeInsets.only(top: 12),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Section 4 - Size Picker
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Size',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SelectableCircleSize(
                    productSize: product.sizes,
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Section 5 - Reviews
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    initiallyExpanded: true,
                    childrenPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    tilePadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    title: const Text(
                      'Reviews',
                      style: TextStyle(
                        color: AppColor.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'poppins',
                      ),
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product.ratings != null
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  ReviewTile(review: product.ratings![index]),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemCount: product.ratings!.length > 2
                                  ? 2
                                  : product.ratings!.length,
                            )
                          : const Text("No Review or Rating"),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 52, top: 12, bottom: 6),
                        child: ElevatedButton(
                          onPressed: product.ratings == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReviewsPage(
                                        reviews: product.ratings!,
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.primary,
                            elevation: 0,
                            backgroundColor: AppColor.primarySoft,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'See More Reviews',
                            style: TextStyle(
                                color: AppColor.secondary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (isDoReview)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Submit Your Comment & Review',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            if (isDoReview)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: commentController,
                  autofocus: false,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Comment........',
                    prefixIcon: const Icon(Icons.comment),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColor.border, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColor.primary, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColor.primarySoft,
                    filled: true,
                  ),
                ),
              ),
            if (isDoReview)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      selectRating = rating;
                    },
                  ),
                ),
              ),
            if (isDoReview)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CupertinoButton(
                  onPressed: () {
                    focusNode.unfocus();
                    _sentComment(widget.product);
                  },
                  color: AppColor.primary,
                  child: const Text("Submit"),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _sentComment(ProductModel product) async {
    EasyLoading.show(status: "wait");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final rating = RatingModel(
        rId: AuthService.currentUser!.uid,
        userModel: userProvider.userModel!,
        productId: product.productId!,
        rating: selectRating.toString(),
        review: commentController.text);
    product.ratings!.add(rating);
    commentController.text = '';
    await DbHelper.updateProductField(product.productId!, {
      productFieldAvgRating:
          product.ratings!.map((rating) => rating.toMap()).toList()
    }).then((value) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Review Post",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColor.primary,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((onError) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: onError.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _saveAsFavorite(ProductModel product, UserProvider userProvider) {
    var previousList = userProvider.userModel!.favoriteList;
    previousList!.add(product.productId!);
    userProvider.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldFavoriteList: previousList,
    }).then((value) {
      Get.snackbar(
        "Information",
        "Product Added Favorite List",
        backgroundColor: AppColor.primary,
        colorText: Colors.white,
        // duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }).catchError((onError) {
      Get.snackbar(
        "Information",
        "Product Unsuccessful",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        // duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    });
  }
}
