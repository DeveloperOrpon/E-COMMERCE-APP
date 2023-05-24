import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../core/model/Cart.dart';
import '../core/model/Review.dart';
import 'app_color.dart';

String calculateTotalCost(List<Cart> cartList) {
  num sum = 0;
  for (Cart cart in cartList) {
    sum += ((cart.productModel.salePrice *
                (100 - cart.productModel.productDiscount)) /
            100) *
        cart.count;
  }
  return sum.toString();
}

double calculateRating(List<RatingModel> ratings) {
  double rating = 0.0;
  for (RatingModel ratingModel in ratings) {
    rating += num.parse(ratingModel.rating).toDouble();
  }
  return num.parse((rating / (ratings.length)).toStringAsFixed(1)).toDouble();
}

num calculateOverallDiscount(String total, num discount) {
  num i = num.parse(total);
  return ((i * discount) / 100);
}

num calculateOverallTotal(String total, num totalDiscount, num shipping) {
  num i = num.parse(total);
  return i - totalDiscount;
}

showSnackBar(String title, String body) {
  Get.snackbar(
    title,
    body,
    backgroundColor: AppColor.primary,
    snackPosition: SnackPosition.TOP,
    colorText: Colors.white,
    snackStyle: SnackStyle.FLOATING,
    barBlur: .5,
    forwardAnimationCurve: Curves.linearToEaseOut,
    backgroundGradient: const LinearGradient(colors: [
      Color(0xFFff00cc),
      Color(0xFF333399),
    ]),
  );
}

startLoading() async {
  await EasyLoading.show(
    dismissOnTap: false,
    status: "Loading",
    indicator: Image.asset(
      'assets/images/search/loading.gif',
      color: Colors.white,
      width: 100,
      height: 130,
    ),
  );
}
