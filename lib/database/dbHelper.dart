import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_mart/core/model/Message.dart';

import '../core/model/Brand_model.dart';
import '../core/model/OrderModel.dart';
import '../core/model/Product.dart';
import '../core/model/category_model.dart';
import '../core/model/notification_model.dart';
import '../core/model/order_constant_model.dart';
import '../core/model/purchase_model.dart';
import '../core/model/user_model.dart';

class DbHelper {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection('Admins').doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = doc.id;
    return doc.set(categoryModel.toMap());
  }

  static Future<void> addBrand(BrandModel brandModel) {
    final doc = _db.collection(collectionBrand).doc();
    brandModel.brandId = doc.id;
    return doc.set(brandModel.toMap());
  }

  static Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final wb = _db.batch();
    final productDoc = _db.collection(collectionProduct).doc();
    final purchaseDoc = _db.collection(collectionPurchase).doc();
    final categoryDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    productModel.productId = productDoc.id;
    purchaseModel.productId = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    wb.set(productDoc, productModel.toMap());
    wb.set(purchaseDoc, purchaseModel.toMap());
    wb.update(categoryDoc, {
      categoryFieldProductCount:
          (productModel.category.productCount + purchaseModel.purchaseQuantity)
    });
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBrands() =>
      _db.collection(collectionBrand).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getProductByPId(
          String pId) =>
      _db.collection(collectionProduct).doc(pId).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          CategoryModel categoryModel) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldId',
              isEqualTo: categoryModel.categoryId)
          .snapshots();

  static Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) async {
    final wb = _db.batch();
    final purDoc = _db.collection(collectionPurchase).doc();
    purchaseModel.purchaseId = purDoc.id;
    wb.set(purDoc, purchaseModel.toMap());
    final proDoc =
        _db.collection(collectionProduct).doc(productModel.productId);
    wb.update(proDoc, {
      productFieldStock: (productModel.stock + purchaseModel.purchaseQuantity)
    });
    final snapshot = await _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId)
        .get();
    final prevCount = snapshot.data()![categoryFieldProductCount];
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {
      categoryFieldProductCount: (prevCount + purchaseModel.purchaseQuantity)
    });
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchases() =>
      _db.collection(collectionPurchase).snapshots();

  static Future<void> updateProductField(
      String productId, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(productId).update(map);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db
          .collection(collectionOrderConstant)
          .doc(documentsOrderConstant)
          .snapshots();

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db
        .collection(collectionOrderConstant)
        .doc(documentsOrderConstant)
        .update(model.toMap());
  }

  static Future<void> addOrder(OrderModel orderModel) {
    final wb = _db.batch();
    final adminDoc = _db.collection(collectionOrder).doc(orderModel.orderId);
    final userDoc = _db
        .collection(collectionUser)
        .doc(orderModel.userInfo.userId)
        .collection(collectionOrder)
        .doc(orderModel.orderId);
    wb.set(adminDoc, orderModel.toMap());
    wb.set(userDoc, orderModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrderListByUser(
          String uId) =>
      _db
          .collection(collectionUser)
          .doc(uId)
          .collection(collectionOrder)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAdmin() {
    return _db.collection("Admins").snapshots();
  }

  static Future<void> sentMessage(MessageModel messageModel) {
    final wb = _db.batch();
    final userDoc = _db
        .collection(collectionUser)
        .doc(messageModel.senderId)
        .collection(collectionMessages)
        .doc(messageModel.mId);
    final adminDoc = _db
        .collection("Admins")
        .doc(messageModel.adminId)
        .collection(collectionMessages)
        .doc(messageModel.mId);
    wb.set(adminDoc, messageModel.toMap());
    wb.set(userDoc, messageModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserMessageById(
          String uId) =>
      _db
          .collection(collectionUser)
          .doc(uId)
          .collection(collectionMessages)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotification(
          String uId) =>
      _db
          .collection(collectionUser)
          .doc(uId)
          .collection(collectionNotification)
          .snapshots();

  static Future<void> updateNotification(String nId, String uId) {
    return _db
        .collection(collectionUser)
        .doc(uId)
        .collection(collectionNotification)
        .doc(nId)
        .update({
      notificationFieldIsShowUser: true,
    });
  }
}
