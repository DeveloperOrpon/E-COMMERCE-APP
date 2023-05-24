import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:green_mart/core/model/Message.dart';
import 'package:green_mart/database/dbHelper.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../auth/auth_service.dart';
import '../../constant/app_color.dart';
import 'fullScreenImage.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final formKey = GlobalKey<FormState>();
  var focusNode = FocusNode();
  final messageController = TextEditingController();
  String? imageLocalPath;
  bool isImageSent = false;
  bool sentBtnActive = true;
  @override
  void didChangeDependencies() {
    Provider.of<UserProvider>(context, listen: false).getMessageOfUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) => userProvider.adminModel !=
                null
            ? Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.border,
                          image: DecorationImage(
                            image:
                                NetworkImage(userProvider.adminModel!.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(userProvider.adminModel!.name.capitalizeFirst!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColor.primarySoft,
                    ),
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                body: Column(
                  children: [
                    // Section 1 - Chat
                    Expanded(
                      child: userProvider.userMessage.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: ListView.builder(
                                itemCount: userProvider.userMessage.length,
                                itemBuilder: (context, index) {
                                  var message = userProvider.userMessage[index];
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: message.senderId ==
                                            AuthService.currentUser!.uid
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: message.senderId ==
                                                  AuthService.currentUser!.uid
                                              ? Colors.blue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (message.image != null)
                                              InkWell(
                                                onTap: () {
                                                  Get.to(FullScreenPage(
                                                    imageUrl: message.image!,
                                                  ));
                                                },
                                                child: Hero(
                                                  tag: message.image!,
                                                  child: CachedNetworkImage(
                                                    imageUrl: message.image!,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        const SpinKitPianoWave(
                                                      color: AppColor.primary,
                                                      size: 50.0,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            SelectableText(
                                              message.message,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: message.senderId !=
                                                        AuthService
                                                            .currentUser!.uid
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              timeago.format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      message.sentTime
                                                          .millisecondsSinceEpoch)),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 6,
                                                fontWeight: FontWeight.w300,
                                                color: message.senderId !=
                                                        AuthService
                                                            .currentUser!.uid
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Text("No Message at yet"),
                            ),
                    ),
                    // Section 2 - Chat Bar
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: AppColor.border, width: 1)),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (imageLocalPath != null)
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    height: 100,
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.file(File(imageLocalPath!),
                                            height: 80),
                                        if (isImageSent)
                                          const SpinKitFadingCircle(
                                            color: AppColor.primary,
                                            size: 50.0,
                                          )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imageLocalPath = null;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        )),
                                  )
                                ],
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // TextField
                                Expanded(
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: messageController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _sentImage();
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      hintText: 'Type a message here...',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColor.border, width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColor.border, width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Type Message";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Send Button
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  width: 42,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: sentBtnActive
                                        ? () {
                                            _sentMessage(userProvider);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Icon(Icons.send_rounded,
                                        color: Colors.white, size: 18),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).viewInsets.bottom,
                      color: Colors.transparent,
                    ),
                  ],
                ))
            : const Scaffold(
                body: Center(
                  child: Text("No Admin Found"),
                ),
              ));
  }

  Future<void> _sentMessage(UserProvider userProvider) async {
    String? finalUrl;
    setState(() {
      isImageSent = true;
      sentBtnActive = false;
    });
    if (imageLocalPath != null) {
      finalUrl = await userProvider.uploadImage(imageLocalPath!);
    }
    if (formKey.currentState!.validate()) {
      String msg = messageController.text;
      focusNode.unfocus();
      messageController.text = '';
      final messageModel = MessageModel(
          mId: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: userProvider.userModel!.userId!,
          adminId: userProvider.adminModel!.id,
          message: msg,
          image: finalUrl,
          sentTime: Timestamp.now());
      await DbHelper.sentMessage(messageModel).then((value) {
        setState(() {
          isImageSent = false;
          imageLocalPath = null;
          sentBtnActive = true;
        });
      }).catchError((onError) {
        setState(() {
          isImageSent = false;
          imageLocalPath = null;
          sentBtnActive = true;
        });
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _sentImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedImage != null) {
      setState(() {
        imageLocalPath = pickedImage.path;
      });
    }
  }
}
