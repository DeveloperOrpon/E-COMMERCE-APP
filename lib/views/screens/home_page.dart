import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/category_model.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/message_page.dart';
import 'package:green_mart/views/screens/search_page.dart';
import 'package:green_mart/views/widgets/category_card.dart';
import 'package:green_mart/views/widgets/custom_icon_button_widget.dart';
import 'package:green_mart/views/widgets/dummy_search_widget_1.dart';
import 'package:green_mart/views/widgets/flashsale_countdown_tile.dart';
import 'package:green_mart/views/widgets/item_card.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';
import 'cart_page.dart';
import 'category_ways_product_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? flashsaleCountdownTimer;
  Duration flashsaleCountdownDuration = Duration(
    hours: 24 - DateTime.now().hour,
    minutes: 60 - DateTime.now().minute,
    seconds: 60 - DateTime.now().second,
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      setCountdown();
    });
  }

  void setCountdown() {
    if (this.mounted) {
      setState(() {
        final seconds = flashsaleCountdownDuration.inSeconds - 1;

        if (seconds < 1) {
          flashsaleCountdownTimer!.cancel();
        } else {
          flashsaleCountdownDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void dispose() {
    if (flashsaleCountdownTimer != null) {
      flashsaleCountdownTimer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = flashsaleCountdownDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String minutes = flashsaleCountdownDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String hours = flashsaleCountdownDuration.inHours
        .remainder(24)
        .toString()
        .padLeft(2, '0');
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => productProvider.userModel !=
              null
          ? Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      productProvider.getAllProducts();
                    },
                  );
                },
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section 1
                    Container(
                      height: 190,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 26),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Find the best \noutfit for you.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    height: 150 / 100,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CustomIconButtonWidget(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CartPage()));
                                          },
                                          value: productProvider.userModel!
                                                          .wishList ==
                                                      null ||
                                                  productProvider.userModel ==
                                                      null
                                              ? 0
                                              : productProvider
                                                  .userModel!.wishList!.length,
                                          icon: SvgPicture.asset(
                                            'assets/icons/Bag.svg',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CustomIconButtonWidget(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MessagePage()));
                                      },
                                      value: 0,
                                      margin: EdgeInsets.only(left: 16),
                                      icon: SvgPicture.asset(
                                        'assets/icons/Chat.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DummySearchWidget1(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Section 2 - category
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: AppColor.secondary,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Consumer<UserProvider>(
                                  builder: (context, value, child) =>
                                      TextButton(
                                    onPressed: () {
                                      value.onItemTapped(1);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'View More',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Category list
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            height: 96,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: productProvider.categoryList.length,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 16);
                              },
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  data: productProvider.categoryList[index],
                                  onTap: () {
                                    Get.to(CategoryWaysProductScreen(
                                      categoryModel:
                                          productProvider.categoryList[index],
                                    ));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section 4 - Flash Sale
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Flash Sale',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: hours[0],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: hours[1],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: minutes[0],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: minutes[1],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 2.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: seconds[0],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: FlashsaleCountdownTile(
                                        digit: seconds[1],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 310,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      productProvider
                                          .getFeatureProduct()
                                          .length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ItemCard(
                                              product: productProvider
                                                  .getFeatureProduct()[index],
                                              titleColor: AppColor.primarySoft,
                                              priceColor: AppColor.accent,
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            const LinearProgressIndicator(
                                                          minHeight: 10,
                                                          value: 0.4,
                                                          color:
                                                              AppColor.accent,
                                                          backgroundColor:
                                                              AppColor.border,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.local_fire_department,
                                                    color: AppColor.accent,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       child: Container(
                                            //         color: Colors.amber,
                                            //         height: 10,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Section 5 - product list

                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        'Today\'s recommendation...',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(
                          productProvider.allProductList.length < 6
                              ? productProvider.allProductList.length
                              : 6,
                          (index) => ItemCard(
                            product: productProvider.allProductList[index],
                          ),
                        ),
                      ),
                    ),

                    //category ways product

                    Column(
                      children: productProvider.categoryList.map((e) {
                        return _categoryWaysProduct(productProvider, e);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: SpinKitCubeGrid(
                color: AppColor.primary,
                size: 50.0,
              ),
            ),
    );
  }

  Container _categoryWaysProduct(
      ProductProvider productProvider, CategoryModel categoryModel) {
    return productProvider
            .getProductByCategory(categoryModel.categoryId!)
            .isNotEmpty
        ? Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: gradient[
                  productProvider.categoryList.indexOf(categoryModel) % 5],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        categoryModel.categoryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(
                              CategoryWaysProductScreen(
                                categoryModel: categoryModel,
                              ),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 270,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            productProvider
                                .getProductByCategory(categoryModel.categoryId!)
                                .length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ItemCard(
                                    product:
                                        productProvider.getProductByCategory(
                                            categoryModel.categoryId!)[index],
                                    titleColor: Colors.white,
                                    priceColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
