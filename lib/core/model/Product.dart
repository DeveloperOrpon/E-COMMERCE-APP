import 'package:cloud_firestore/cloud_firestore.dart';

import 'Brand_model.dart';
import 'ColorWay.dart';
import 'ProductSize.dart';
import 'Review.dart';
import 'category_model.dart';

const String collectionProduct = 'Products';
const String productFieldId = 'productId';
const String productFieldName = 'productName';
const String productFieldCategory = 'category';
const String productFieldShortDescription = 'shortDescription';
const String productFieldLongDescription = 'LongDescription';
const String productFieldSalePrice = 'salePrice';
const String productFieldStock = 'stock';
const String productFieldAvgRating = 'avgRating';
const String productFieldDiscount = 'discount';
const String productFieldThumbnail = 'thumbnail';
const String productFieldImages = 'images';
const String productFieldAvailable = 'available';
const String productFieldFeatured = 'featured';
const String productFieldColors = 'colors';
const String productFieldSizes = 'sizes';
const String productFieldBrandModel = 'brandModel';
const String productFieldProductPostTime = 'productPostTime';

class ProductModel {
  String? productId;
  String productName;
  CategoryModel category;
  BrandModel brandModel;
  String? shortDescription;
  String? longDescription;
  num salePrice;
  num stock;
  num productDiscount;
  String thumbnailImageUrl;
  List<String> additionalImages;
  List<RatingModel>? ratings;
  List<ColorWay> colors;
  List<ProductSize> sizes;
  bool available;
  bool featured;
  Timestamp productPostTime;

  ProductModel(
      {this.productId,
      required this.productName,
      required this.category,
      this.shortDescription,
      this.longDescription,
      required this.salePrice,
      required this.stock,
      this.productDiscount = 0,
      required this.thumbnailImageUrl,
      required this.productPostTime,
      required this.additionalImages,
      required this.colors,
      required this.sizes,
      required this.brandModel,
      this.ratings,
      this.available = true,
      this.featured = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      productFieldId: productId,
      productFieldName: productName,
      productFieldCategory: category.toMap(),
      productFieldBrandModel: brandModel.toMap(),
      productFieldShortDescription: shortDescription,
      productFieldLongDescription: longDescription,
      productFieldDiscount: productDiscount,
      productFieldSalePrice: salePrice,
      productFieldStock: stock,
      productFieldThumbnail: thumbnailImageUrl,
      productFieldImages: additionalImages,
      productFieldAvailable: available,
      productFieldProductPostTime: productPostTime,
      productFieldFeatured: featured,
      productFieldAvgRating: ratings?.map((rating) => rating.toMap()).toList(),
      productFieldColors: colors.map((color) => color.toMap()).toList(),
      productFieldSizes: sizes.map((size) => size.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
      productId: map[productFieldId],
      productName: map[productFieldName],
      category: CategoryModel.fromMap(map[productFieldCategory]),
      brandModel: BrandModel.fromMap(map[productFieldBrandModel]),
      shortDescription: map[productFieldShortDescription],
      longDescription: map[productFieldLongDescription],
      productPostTime: map[productFieldProductPostTime],
      salePrice: map[productFieldSalePrice],
      stock: map[productFieldStock],
      productDiscount: map[productFieldDiscount],
      thumbnailImageUrl: map[productFieldThumbnail],
      additionalImages: List<String>.from(map[productFieldImages] ?? []),
      ratings: map[productFieldAvgRating] == null
          ? []
          : (map[productFieldAvgRating] as List<dynamic>?)
              ?.map((rating) => RatingModel.fromMap(rating))
              .toList(),
      colors: (map[productFieldColors] as List<dynamic>)
          .map((color) => ColorWay.fromJson(color))
          .toList(),
      sizes: (map[productFieldSizes] as List<dynamic>)
          .map((size) => ProductSize.fromJson(size))
          .toList(),
      available: map['available'],
      featured: map['featured']);
}
