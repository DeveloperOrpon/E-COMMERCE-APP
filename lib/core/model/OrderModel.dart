import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_mart/core/model/Cart.dart';
import 'package:green_mart/core/model/user_model.dart';

const String collectionOrder = 'orderList';
const String orderFieldItems = 'cartItems';
const String orderFieldOrderId = 'orderId';
const String orderFieldTotalCost = 'totalCost';
const String orderFieldDeliveryTime = 'deliveryTime';
const String orderFieldOrderTime = 'orderTime';
const String orderFieldUserInfo = 'userInfo';
const String orderFieldAdminStatus = 'adminStatus';
const String orderFieldUserStatus = 'userStatus';
const String orderFieldDeliveryType = 'deliveryType';

class OrderModel {
  String orderId;
  String deliveryType;
  bool adminStatus;
  bool userStatus;
  List<Cart> cartItems;
  UserModel userInfo;
  Timestamp deliveryTime;
  Timestamp orderTime;

  OrderModel(
      {required this.orderId,
      required this.cartItems,
      required this.userInfo,
      this.adminStatus = false,
      this.userStatus = false,
      required this.deliveryTime,
      required this.deliveryType,
      required this.orderTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderFieldOrderId: orderId,
      orderFieldItems: cartItems.map((item) => item.toMap()).toList(),
      orderFieldUserInfo: userInfo.toMap(),
      orderFieldDeliveryTime: deliveryTime,
      orderFieldOrderTime: orderTime,
      orderFieldAdminStatus: adminStatus,
      orderFieldUserStatus: userStatus,
      orderFieldDeliveryType: deliveryType,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        orderId: map[orderFieldOrderId],
        cartItems: (map[orderFieldItems] as List<dynamic>)
            .map((cart) => Cart.fromMap(cart))
            .toList(),
        userInfo: UserModel.fromMap(map[orderFieldUserInfo]),
        deliveryTime: map[orderFieldDeliveryTime],
        orderTime: map[orderFieldOrderTime],
        adminStatus: map[orderFieldAdminStatus],
        userStatus: map[orderFieldUserStatus],
        deliveryType: map[orderFieldDeliveryType],
      );
}
