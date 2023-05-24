import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:green_mart/auth/auth_service.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/views/screens/lancherPage.dart';
import 'package:green_mart/views/screens/register_page.dart';

import '../../constant/helper_function.dart';
import 'forgote_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sign in',
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
                .push(MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dont have an account?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                ' Sign up',
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
              margin: EdgeInsets.only(top: 20, bottom: 12),
              child: Text(
                'Welcome Back Mate ! 😁',
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
              child: Text(
                'login and explore the Green Mart World',
                style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    fontSize: 12,
                    height: 150 / 100),
              ),
            ),
            // Section 2 - Form
            // Email
            TextFormField(
              controller: emailController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'youremail@email.com',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Message.svg',
                      color: AppColor.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Input Valid Email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Password
            TextFormField(
              controller: passController,
              autofocus: false,
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                hintText: '**********',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Lock.svg',
                      color: AppColor.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
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
                  return 'Input Valid Password';
                }
                return null;
              },
            ),
            // Forgot Passowrd
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _resetPassword();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primary.withOpacity(0.1),
                ),
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColor.secondary.withOpacity(0.5),
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            // Sign In button
            ElevatedButton(
              onPressed: () {
                _loginUser();
              },
              child: Text(
                'Sign in',
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
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    if (formKey.currentState!.validate()) {
      startLoading();
      await AuthService.loginWithEmailPass(
              emailController.text, passController.text)
          .then((value) {
        EasyLoading.dismiss();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LancherPage()));
      }).catchError((onError) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "${onError.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  void _resetPassword() {
    Get.to(const ForgotPassword());
  }
}
