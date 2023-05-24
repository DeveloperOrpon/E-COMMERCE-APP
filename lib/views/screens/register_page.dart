import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/constant/string.dart';
import 'package:green_mart/core/model/user_model.dart';
import 'package:green_mart/database/dbHelper.dart';
import 'package:green_mart/views/screens/lancherPage.dart';
import 'package:green_mart/views/screens/login_page.dart';

import '../../constant/helper_function.dart';

class RegisterPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool passwordVisible2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sign up',
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                ' Sign in',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24),
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 12),
              child: const Text(
                'Welcome to $appName  👋',
                style: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'poppins',
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: Text(
                'Input Proper Information to Register a Account  ',
                style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    fontSize: 12,
                    height: 150 / 100),
              ),
            ),
            // Section 2  - Form
            // Full Name
            TextFormField(
              autofocus: false,
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Profile.svg',
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
                if (value!.length < 2) {
                  return "Input Valid Name";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Username
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Username',
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: const Text('@',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary)),
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
                if (value!.length < 2) {
                  return "Input Valid Name";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Email
            TextFormField(
              autofocus: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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
                if (!value!.contains('@')) {
                  return "Input Valid Email";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Password
            TextFormField(
              autofocus: false,
              controller: passwordController,
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Lock.svg',
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
                //
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.length < 6) {
                  return "Input Valid Password";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Repeat Password
            TextFormField(
              autofocus: false,
              obscureText: !passwordVisible2,
              controller: repeatPassController,
              decoration: InputDecoration(
                hintText: 'Repeat Password',
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Lock.svg',
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
                //
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      passwordVisible2 = !passwordVisible2;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.length < 6) {
                  return "Input Valid Password";
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                _emailSignUp();
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins'),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'or continue with',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            // SIgn in With Google
            ElevatedButton(
              onPressed: () {
                _googleLogin();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.primary,
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                backgroundColor: AppColor.primarySoft,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/Google.svg',
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: AppColor.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _googleLogin() async {
    log("_googleLogin");
    UserCredential credential = await AuthService.signInWithGoogle();
    startLoading();
    final user = UserModel(
      email: credential.user!.email!,
      displayName: credential.user!.displayName!,
      userId: credential.user!.uid,
      phone: credential.user!.phoneNumber,
      userCreationTime: Timestamp.now(),
      imageUrl: credential.user!.photoURL,
      wishList: [],
      address: '',
      age: '',
      favoriteList: [],
      gender: '',
    );
    if (!await DbHelper.doesUserExist(credential.user!.uid)) {
      startLoading();
      await DbHelper.addUser(user).then((value) {
        EasyLoading.dismiss();
        //navigate
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LancherPage()));
      }).catchError((onError) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Error : ${onError.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } else {
      //navigate
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LancherPage()));
    }
  }

  _emailSignUp() async {
    if (formKey.currentState!.validate() &&
        passwordController.text != repeatPassController.text) {
      Fluttertoast.showToast(
          msg: "Password does not Match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (formKey.currentState!.validate()) {
      startLoading();

      try {
        UserCredential userCredential = await AuthService.auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        final user = UserModel(
          email: emailController.text,
          displayName: nameController.text,
          userId: userCredential.user!.uid,
          imageUrl: userCredential.user!.photoURL,
          wishList: [],
          address: '',
          age: '',
          favoriteList: [],
          gender: '',
          phone: userCredential.user!.phoneNumber,
          userCreationTime: Timestamp.now(),
        );

        DbHelper.addUser(user).then((value) {
          EasyLoading.dismiss();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LancherPage()));
        });
      } on FirebaseException catch (error) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Error : ${error.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return error.message!;
      }
    }
  }
}
