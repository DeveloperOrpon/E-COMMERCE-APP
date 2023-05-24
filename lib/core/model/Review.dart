import 'package:green_mart/core/model/user_model.dart';

const String collectionRating = 'Rating';
const String ratingFieldId = 'rId';
const String ratingFieldUserModel = 'userModel';
const String ratingFieldProductId = 'productId';
const String ratingFieldRating = 'rating';
const String ratingFieldReview = 'review';

class RatingModel {
  String rId;
  UserModel userModel;
  String productId;
  String rating;
  String review;

  RatingModel({
    required this.rId,
    required this.userModel,
    required this.productId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ratingFieldId: rId,
      ratingFieldUserModel: userModel.toMap(),
      ratingFieldProductId: productId,
      ratingFieldRating: rating,
      ratingFieldReview: review
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) => RatingModel(
      rId: map[ratingFieldId],
      userModel: UserModel.fromMap(map[ratingFieldUserModel]),
      rating: map[ratingFieldRating],
      review: map[ratingFieldReview],
      productId: map[ratingFieldProductId]);
}
