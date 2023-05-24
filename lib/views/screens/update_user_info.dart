import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/user_model.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constant/helper_function.dart';

class UpdateUserInformation extends StatefulWidget {
  const UpdateUserInformation({Key? key}) : super(key: key);

  @override
  State<UpdateUserInformation> createState() => _UpdateUserInformationState();
}

class _UpdateUserInformationState extends State<UpdateUserInformation> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  String? thumbnailImageLocalPath;
  String? downUrl;
  bool isButton = true;

  @override
  void didChangeDependencies() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    nameController.text = provider.userModel!.displayName!;
    phoneController.text = provider.userModel!.phone ?? "";
    addressController.text = provider.userModel!.address ?? "";
    emailController.text = provider.userModel!.email;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile Information"),
          backgroundColor: AppColor.primary,
        ),
        body: ListView(
          children: [
            SizedBox(height: 20),
            InkWell(
                onTap: () {
                  _pickImage(provider);
                },
                child: provider.userModel!.imageUrl == null &&
                        thumbnailImageLocalPath == null
                    ? const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColor.primary,
                        child: Icon(Icons.add),
                      )
                    : provider.userModel!.imageUrl != null
                        ? Image.network(
                            provider.userModel!.imageUrl!,
                            height: 80,
                            width: 80,
                          )
                        : Center(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: AppColor.primary,
                                  )),
                                  child: Image.file(
                                    File(thumbnailImageLocalPath!),
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          thumbnailImageLocalPath = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 32,
                                      )),
                                )
                              ],
                            ),
                          )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: nameController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'display name ',
                  prefixIcon: const Icon(Icons.person),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input Valid name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                enabled: false,
                autofocus: false,
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Message.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input Valid name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Phone Number ',
                  prefixIcon: const Icon(Icons.phone),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input Valid phone';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: addressController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Address',
                  prefixIcon: const Icon(Icons.location_on),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input Valid address';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isButton
                    ? () {
                        _update(provider);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(UserProvider provider) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedImage != null) {
      setState(() {
        thumbnailImageLocalPath = pickedImage.path;
      });
    }
  }

  void _update(UserProvider provider) async {
    setState(() {
      isButton = false;
    });
    startLoading();
    if (thumbnailImageLocalPath != null) {
      downUrl = await provider
          .uploadImage(thumbnailImageLocalPath!)
          .catchError((onError) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Information",
          "Image Upload Unsuccessfully",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
        );
      });
      await provider.updateUserProfileField(AuthService.currentUser!.uid, {
        userFieldImageUrl: downUrl,
      }).catchError((onError) {
        EasyLoading.dismiss();
      });
    }
    await provider.updateUserProfileField(AuthService.currentUser!.uid, {
      userFieldDisplayName: nameController.text,
      userFieldPhone: phoneController.text,
      userFieldAddress: addressController.text,
    }).then((value) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Information",
        "Profile Update Successfully",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
      );
      setState(() {
        isButton = true;
      });
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Information",
        "Profile Update Unsuccessfully",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
      );
      setState(() {
        isButton = true;
      });
    });
  }
}
