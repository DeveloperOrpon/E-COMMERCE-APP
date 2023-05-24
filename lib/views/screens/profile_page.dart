import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/all_order_details_page.dart';
import 'package:green_mart/views/screens/cart_page.dart';
import 'package:green_mart/views/screens/update_user_info.dart';
import 'package:green_mart/views/screens/wish_list_screen.dart';
import 'package:green_mart/views/widgets/main_app_bar_widget.dart';
import 'package:green_mart/views/widgets/menu_tile_widget.dart';
import 'package:provider/provider.dart';

import 'lancherPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        appBar: MainAppBar(
          cartValue: userProvider.userModel!.wishList!.length,
          chatValue: 0,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1 - Profile Picture - Username - Name
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  userProvider.userModel!.imageUrl != null
                      ? Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(
                                  userProvider.userModel!.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : TextAvatar(
                          shape: Shape.Circular,
                          size: 50,
                          text: userProvider.userModel!.email,
                        ),

                  Container(
                    margin: EdgeInsets.only(bottom: 4, top: 14),
                    child: Text(
                      userProvider.userModel!.displayName ?? "No Name Set Yet",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  // Username
                  Text(
                    userProvider.userModel!.email,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 14),
                  ),
                ],
              ),
            ),
            // Section 2 - Account Menu
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      'ACCOUNT',
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.5),
                          letterSpacing: 6 / 100,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  MenuTileWidget(
                    onTap: () {
                      Get.to(const CartPage(),
                          transition: Transition.leftToRightWithFade);
                    },
                    margin: const EdgeInsets.only(top: 10),
                    icon: SvgPicture.asset(
                      'assets/icons/Heart.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Wishlist',
                    subtitle: 'Lorem ipsum Dolor sit Amet',
                    iconBackground: Colors.pink.shade100,
                  ),
                  MenuTileWidget(
                    onTap: () {
                      Get.to(const WishListScreen(),
                          transition: Transition.leftToRightWithFade);
                    },
                    margin: const EdgeInsets.only(top: 10),
                    icon: SvgPicture.asset(
                      'assets/icons/Heart.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Favorite ',
                    subtitle: 'Your Favorite Product list',
                    iconBackground: Colors.cyan.shade100,
                  ),
                  MenuTileWidget(
                    onTap: () {
                      Get.to(const AllOrderDetails());
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/Bag.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Orders',
                    subtitle: 'Show Your Order Summery',
                    margin: EdgeInsets.zero,
                    iconBackground: Colors.orange.shade300,
                  ),
                  MenuTileWidget(
                    onTap: () {
                      Get.to(const UpdateUserInformation());
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/Location.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Addresses',
                    subtitle: 'Change Delivery Location',
                    margin: EdgeInsets.zero,
                    iconBackground: Colors.blue.shade300,
                  ),
                  MenuTileWidget(
                    onTap: () {
                      Get.to(const UpdateUserInformation());
                    },
                    icon: const Icon(Icons.person),
                    title: 'Profile Edit',
                    subtitle: 'Update User Information',
                    margin: EdgeInsets.zero,
                    iconBackground: Colors.green.shade100,
                  ),
                ],
              ),
            ),

            // Section 3 - Settings
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.5),
                          letterSpacing: 6 / 100,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  MenuTileWidget(
                    onTap: () {},
                    margin: EdgeInsets.only(top: 10),
                    icon: SvgPicture.asset(
                      'assets/icons/Filter.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Languages',
                    subtitle: 'Lorem ipsum Dolor sit Amet',
                  ),
                  MenuTileWidget(
                    onTap: () {
                      EasyLoading.show(status: "LogOut...");
                      AuthService.logout().then((value) {
                        EasyLoading.dismiss();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LancherPage()));
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/Log Out.svg',
                      color: Colors.red,
                    ),
                    iconBackground: Colors.red.shade100,
                    title: 'Log Out',
                    titleColor: Colors.red,
                    subtitle: '',
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
