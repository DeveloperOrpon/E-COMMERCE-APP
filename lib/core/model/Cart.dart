import 'package:green_mart/core/model/Product.dart';

const String collectionWish = 'wishList';
const String wishFieldProduct = 'product';
const String wishFieldCount = 'count';

class Cart {
  ProductModel productModel;
  int count;

  Cart({
    required this.productModel,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      wishFieldProduct: productModel.toMap(),
      wishFieldCount: count,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) => Cart(
        productModel: ProductModel.fromMap(map[wishFieldProduct]),
        count: map[wishFieldCount],
      );
}
