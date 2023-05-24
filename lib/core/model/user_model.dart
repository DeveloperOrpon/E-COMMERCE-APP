import 'package:cloud_firestore/cloud_firestore.dart';

import 'Cart.dart';

const String collectionUser = 'Users';

const String userFieldId = 'userId';
const String userFieldDisplayName = 'displayName';
const String userFieldAddressModel = 'addressModel';
const String userFieldCreationTime = 'CreationTime';
const String userFieldGender = 'gender';
const String userFieldAge = 'age';
const String userFieldPhone = 'phone';
const String userFieldEmail = 'email';
const String userFieldImageUrl = 'imageUrl';
const String userFieldAddress = 'address';
const String userFieldWishList = 'wishList';
const String userFieldFavoriteList = 'favoriteList';

class UserModel {
  String? userId;
  String? displayName;
  Timestamp? userCreationTime;
  String? gender;
  String? imageUrl;
  String? age;
  String? phone;
  String email;
  String? address;
  List<Cart>? wishList;
  List<String>? favoriteList;

  UserModel(
      {this.userId,
      this.displayName,
      this.userCreationTime,
      this.gender,
      this.age,
      this.phone,
      this.imageUrl,
      this.address,
      this.wishList,
      this.favoriteList,
      required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldId: userId,
      userFieldDisplayName: displayName,
      userFieldCreationTime: userCreationTime,
      userFieldGender: gender,
      userFieldAge: age,
      userFieldPhone: phone,
      userFieldEmail: email,
      userFieldImageUrl: imageUrl,
      userFieldAddress: address,
      userFieldWishList: wishList!.map((rating) => rating.toMap()).toList(),
      userFieldFavoriteList: favoriteList,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map[userFieldId],
        displayName: map[userFieldDisplayName],
        userCreationTime: map[userFieldCreationTime],
        gender: map[userFieldGender],
        age: map[userFieldAge],
        phone: map[userFieldPhone],
        email: map[userFieldEmail],
        imageUrl: map[userFieldImageUrl],
        address: map[userFieldAddress],
        favoriteList: List<String>.from(map[userFieldFavoriteList] ?? []),
        wishList: (map[userFieldWishList] as List<dynamic>)
            .map((size) => Cart.fromMap(size))
            .toList(),
      );
}
