import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:green_mart/core/model/Message.dart';

import '../auth/auth_service.dart';
import '../core/model/OrderModel.dart';
import '../core/model/admin_model.dart';
import '../core/model/notification_model.dart';
import '../core/model/user_model.dart';
import '../database/dbHelper.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  AdminModel? adminModel;
  List<OrderModel> orderList = [];
  List<MessageModel> userMessage = [];
  List<NotificationModelOfUser> userNotification = [];

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if (snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  getAdmin() {
    DbHelper.getAdmin().listen((snapshot) {
      adminModel = AdminModel.formMap(snapshot.docs[0].data());
      notifyListeners();
    });
  }

  getMessageOfUser() {
    DbHelper.getUserMessageById(userModel!.userId!).listen((snapshot) {
      userMessage = List.generate(snapshot.docs.length,
              (index) => MessageModel.fromMap(snapshot.docs[index].data()))
          .toList();
      userMessage.sort(
        (a, b) => b.sentTime.compareTo(a.sentTime),
      );
      notifyListeners();
    });
  }

  Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) async {
    return await DbHelper.updateUserProfileField(uid, map);
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  getAllUserOrderList() {
    DbHelper.getOrderListByUser(AuthService.currentUser!.uid)
        .listen((snapshot) {
      orderList = List.generate(snapshot.docs.length,
          (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      orderList.sort(
        (a, b) => b.orderTime.compareTo(a.orderTime),
      );
      notifyListeners();
    });
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  getUserNotification() {
    DbHelper.getUserNotification(userModel!.userId!).listen((event) {
      userNotification = List.generate(
              event.docs.length,
              (index) =>
                  NotificationModelOfUser.fromMap(event.docs[index].data()))
          .toList();
      userNotification.sort(
        (a, b) => b.notificationTime.compareTo(a.notificationTime),
      );
      notifyListeners();
    });
  }
}
