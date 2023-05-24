import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/string.dart';
import 'package:green_mart/core/model/Product.dart';
import 'package:green_mart/database/dbHelper.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/all_order_details_page.dart';
import 'package:green_mart/views/screens/product_detail.dart';
import 'package:green_mart/views/widgets/main_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../constant/helper_function.dart';
import '../../provider/product_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late ProductProvider provider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<ProductProvider>(context, listen: false);
    Provider.of<UserProvider>(context, listen: false).getUserNotification();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) => Scaffold(
              appBar: MainAppBar(
                cartValue: userProvider.userModel!.wishList!.length,
                chatValue: 0,
              ),
              body: userProvider.userNotification.isNotEmpty
                  ? ListView.builder(
                      itemCount: userProvider.userNotification.length,
                      itemBuilder: (context, index) {
                        final notification =
                            userProvider.userNotification[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            tileColor: notification.isShowUser
                                ? Colors.grey
                                : notification.type == "Parking-Booking"
                                    ? Colors.green
                                    : Colors.orange,
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                  color: notification.isShowUser
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.0),
                            ),
                            subtitle: Text(
                              notification.type,
                              style: TextStyle(
                                  color: notification.isShowUser
                                      ? Colors.black
                                      : Colors.white.withOpacity(.5),
                                  fontSize: 10,
                                  letterSpacing: 1.0),
                            ),
                            leading: notification.type == "Parking-Booking"
                                ? const Icon(Icons.garage, color: Colors.white)
                                : const Icon(Icons.rate_review,
                                    color: Colors.white),
                            trailing: Text(
                              timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      notification.notificationTime
                                          .millisecondsSinceEpoch)),
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () async {
                              startLoading();
                              await DbHelper.updateNotification(notification.id,
                                      AuthService.currentUser!.uid)
                                  .then((value) async {
                                EasyLoading.dismiss();
                                if (NotificationType.orderAccept ==
                                    notification.type) {
                                  Get.to(const AllOrderDetails(),
                                      transition:
                                          Transition.leftToRightWithFade);
                                }
                                if (NotificationType.newProductAdded ==
                                    notification.type) {
                                  final map = await DbHelper.getProductByPId(
                                      notification.otherId);
                                  final productModel =
                                      ProductModel.fromMap(map.data()!);
                                  Get.to(ProductDetail(product: productModel),
                                      transition:
                                          Transition.leftToRightWithFade);
                                }
                              }).catchError((onError) {
                                EasyLoading.dismiss();
                              });
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No Notification Here!!',
                        style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.5),
                            letterSpacing: 6 / 100,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
            ));
  }
}
