import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionMessages = 'Messages';
const String messageFieldMId = 'mId';
const String messageFieldSenderId = 'senderId';
const String messageFieldAdminId = 'adminId';
const String messageFieldMessage = 'message';
const String messageFieldSentTime = 'sentTime';
const String messageFieldRevivedTime = 'revivedTime';
const String messageFieldImage = 'image';

class MessageModel {
  String mId;
  String senderId;
  String adminId;
  String message;
  String? image;
  Timestamp sentTime;
  Timestamp? revivedTime;

  MessageModel(
      {required this.mId,
      required this.senderId,
      required this.adminId,
      required this.message,
      this.image,
      required this.sentTime,
      this.revivedTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      messageFieldMId: mId,
      messageFieldSenderId: senderId,
      messageFieldAdminId: adminId,
      messageFieldMessage: message,
      messageFieldSentTime: sentTime,
      messageFieldRevivedTime: revivedTime,
      messageFieldImage: image,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        mId: map[messageFieldMId],
        senderId: map[messageFieldSenderId],
        adminId: map[messageFieldAdminId],
        message: map[messageFieldMessage],
        sentTime: map[messageFieldSentTime],
        revivedTime: map[messageFieldRevivedTime],
        image: map[messageFieldImage],
      );
}
