import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Forgot Password',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Email verification',
                style: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'poppins',
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Row(
                children: [
                  Text(
                    'Password Reset mail sent to your email',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: emailController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'youremail@email.com',
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
                  return isValidEmail(value) ? null : "Check your email";
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 32, bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  _forgotPassword();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Sent Mail',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _forgotPassword() {
    if (formKey.currentState!.validate()) {
      AuthService.forgotPassword(emailController.text).then((value) {
        Get.snackbar(
          "Information",
          "Mail is sent check your email!!",
          backgroundColor: AppColor.primary,
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
        );
      }).catchError((onError) {
        Get.snackbar(
          "Information",
          onError.toString(),
          backgroundColor: AppColor.primary,
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
        );
      });
    }
  }

  bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }
}
