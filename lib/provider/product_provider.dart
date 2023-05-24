import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/core/model/order_constant_model.dart';
import 'package:green_mart/core/model/user_model.dart';

import '../constant/helper_function.dart';
import '../core/model/Brand_model.dart';
import '../core/model/Cart.dart';
import '../core/model/Product.dart';
import '../core/model/category_model.dart';
import '../core/model/purchase_model.dart';
import '../database/dbHelper.dart';

class ProductProvider extends ChangeNotifier {
  int totalFileSize = 0;
  int progressFileSize = 0;
  List<CategoryModel> categoryList = [];
  List<BrandModel> brandList = [];
  List<ProductModel> allProductList = [];
  List<PurchaseModel> purchaseList = [];
  UserModel? userModel;
  OrderConstantModel? orderConstantModel;

  Future<void> addNewBrand(String brandName, String image) async {
    String url = await uploadImage(image);
    final brandModel = BrandModel(brandName: brandName, brandImage: url);
    return DbHelper.addBrand(brandModel);
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList.sort(
        (a, b) => a.categoryName.compareTo(b.categoryName),
      );
      notifyListeners();
    });
  }

  getAllBrands() {
    DbHelper.getAllBrands().listen((snapshot) {
      brandList = List.generate(snapshot.docs.length,
          (index) => BrandModel.fromMap(snapshot.docs[index].data()));
      brandList.sort(
        (a, b) => a.brandName.compareTo(b.brandName),
      );
      notifyListeners();
    });
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      List<ProductModel> list = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      list.sort(
        (a, b) => b.productPostTime.compareTo(a.productPostTime),
      );
      allProductList = list.where((element) => element.available).toList();
      notifyListeners();
    });
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child("ProductImages/${DateTime.now().microsecondsSinceEpoch}");
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() {
      //show msg
    });
    uploadTask.snapshotEvents.listen((event) {
      totalFileSize = snapshot.totalBytes;
      progressFileSize = snapshot.bytesTransferred;
      log('Task state: ${snapshot.state}');
      log('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    });
    return snapshot.ref.getDownloadURL();
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<void> deleteImage(String downlodloadUrl) {
    return FirebaseStorage.instance.refFromURL(downlodloadUrl).delete();
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  getAllPurchase() {
    DbHelper.getAllPurchases().listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length,
          (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> updateProductField(
      String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field: value});
  }

  List<PurchaseModel> getPurchaseByProductId(String productId) {
    List<PurchaseModel> list = [];
    list = purchaseList.where((model) => model.productId == productId).toList();
    return list;
  }

  addProductInCart(ProductModel productModel, int count) async {
    startLoading();
    final cartModel = Cart(productModel: productModel, count: count);
    userModel!.wishList!.add(cartModel);
    await DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldWishList:
          userModel!.wishList!.map((cart) => cart.toMap()).toList(),
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      log(onError.toString());
      EasyLoading.dismiss();
    });
  }

  updateProductInCart(int index, int count) async {
    userModel!.wishList![index].count = count;
    await DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldWishList:
          userModel!.wishList!.map((cart) => cart.toMap()).toList(),
    });
  }

  Future<void> removeProductInCart(int index) async {
    userModel!.wishList!.removeAt(index);
    await DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldWishList:
          userModel!.wishList!.map((cart) => cart.toMap()).toList(),
    });
  }

  Future<void> deleteAllCartItem() async {
    startLoading();
    userModel!.wishList!.removeRange(0, userModel!.wishList!.length);
    await DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldWishList:
          userModel!.wishList!.map((cart) => cart.toMap()).toList(),
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
    });
  }

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if (snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  List<ProductModel> getProductByCategory(String catId) {
    List<ProductModel> list = [];
    for (ProductModel productModel in allProductList) {
      if (productModel.category.categoryId == catId) {
        list.add(productModel);
      }
    }
    return list;
  }

  List<ProductModel> getProductByBrand(String bid) {
    List<ProductModel> list = [];
    for (ProductModel productModel in allProductList) {
      if (productModel.brandModel.brandId == bid) {
        list.add(productModel);
      }
    }
    return list;
  }

  List<ProductModel> getNewProduct() {
    List<ProductModel> list = [];
    for (ProductModel productModel in allProductList) {
      if (productModel.productPostTime
          .toDate()
          .isBefore(DateTime.now().subtract(const Duration(days: 3)))) {
        list.add(productModel);
      }
    }
    return list;
  }

  getOrderConstrain() {
    DbHelper.getOrderConstants().listen((event) {
      orderConstantModel = OrderConstantModel.fromMap(event.data()!);
      notifyListeners();
    });
  }

  List<ProductModel> getFeatureProduct() {
    List<ProductModel> list = [];
    for (ProductModel productModel in allProductList) {
      if (productModel.featured) {
        list.add(productModel);
      }
    }
    return list;
  }
}
