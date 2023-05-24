import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:green_mart/core/services/ExploreService.dart';
import 'package:green_mart/views/widgets/main_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../constant/app_color.dart';
import '../../provider/product_provider.dart';
import '../widgets/category_card.dart';
import 'brand_ways_product_screen.dart';
import 'category_ways_product_screen.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  late TabController tabController;
  List listExploreItem = ExploreService.listExploreItem;
  List listExploreUpdateItem = ExploreService.listExploreUpdateItem;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => Scaffold(
        backgroundColor: AppColor.primary.withOpacity(.4),
        appBar: MainAppBar(
          cartValue: productProvider.userModel!.wishList!.length,
          chatValue: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: AppColor.secondary,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    tabController.index = index;
                  });
                },
                controller: tabController,
                indicatorColor: AppColor.accent,
                indicatorWeight: 5,
                unselectedLabelColor: Colors.white.withOpacity(0.5),
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500, fontFamily: 'poppins'),
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400, fontFamily: 'poppins'),
                tabs: const [
                  Tab(
                    text: 'Category',
                  ),
                  Tab(
                    text: 'Brand',
                  ),
                ],
              ),
            ),
            // Section 2 - Tab View
            IndexedStack(
              index: tabController.index,
              children: [
                // Tab 1 - Update
                AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(productProvider.categoryList.length,
                        (index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 3,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: CategoryCard(
                                data: productProvider.categoryList[index],
                                onTap: () {
                                  Get.to(CategoryWaysProductScreen(
                                    categoryModel:
                                        productProvider.categoryList[index],
                                  ));
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Tab 2 - Explore
                AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(productProvider.brandList.length,
                        (index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: InkWell(
                              onTap: () {
                                Get.to(BrandWaysProductScreen(
                                  brandModel: productProvider.brandList[index],
                                ));
                              },
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.15),
                                      width: 1),
                                  color: (true)
                                      ? Colors.white.withOpacity(0.10)
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: productProvider
                                            .brandList[index].brandImage,
                                        height: 110,
                                        width: Get.width * .5,
                                        fit: BoxFit.cover,
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
                                    Container(
                                      width: Get.width * .5,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.primary.withOpacity(.6),
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        productProvider
                                            .brandList[index].brandName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
