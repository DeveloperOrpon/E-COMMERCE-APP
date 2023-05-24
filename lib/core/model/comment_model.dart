import 'user_model.dart';

const String collectionComment = 'Comment';
const String commentFieldUser = 'user';
const String commentFieldCid = 'cId';
const String commentFieldProductId = 'productId';
const String commentFieldComment = 'comment';
const String commentFieldApproved = 'approved';

class CommentModel {
  String cId;
  UserModel user;
  String productId;
  String comment;
  bool approved;

  CommentModel({
    required this.cId,
    required this.user,
    required this.productId,
    required this.comment,
    this.approved = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      commentFieldCid: cId,
      commentFieldUser: user.toMap(),
      commentFieldProductId: productId,
      commentFieldComment: comment,
      commentFieldApproved: approved
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
      cId: map[commentFieldCid],
      user: UserModel.fromMap(map[commentFieldUser]),
      productId: map[commentFieldProductId],
      comment: map[commentFieldComment],
      approved: map[commentFieldApproved]);
}
