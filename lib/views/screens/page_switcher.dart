import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/provider/user_provider.dart';
import 'package:green_mart/views/screens/feeds_page.dart';
import 'package:green_mart/views/screens/notification_page.dart';
import 'package:green_mart/views/screens/profile_page.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) => Scaffold(
          body: [
            const HomePage(),
            const FeedsPage(),
            const NotificationPage(),
            const ProfilePage(),
          ][userProvider.selectedIndex],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColor.primarySoft, width: 2))),
            child: BottomNavigationBar(
              onTap: userProvider.onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                (userProvider.selectedIndex == 0)
                    ? BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icons/Home-active.svg'),
                        label: '')
                    : BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icons/Home.svg'),
                        label: ''),
                (userProvider.selectedIndex == 1)
                    ? BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                            'assets/icons/Category-active.svg'),
                        label: '')
                    : BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icons/Category.svg'),
                        label: ''),
                (userProvider.selectedIndex == 2)
                    ? BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                            'assets/icons/Notification-active.svg'),
                        label: '')
                    : BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icons/Notification.svg'),
                        label: ''),
                (userProvider.selectedIndex == 3)
                    ? BottomNavigationBarItem(
                        icon:
                            SvgPicture.asset('assets/icons/Profile-active.svg'),
                        label: '')
                    : BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icons/Profile.svg'),
                        label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Please confirm',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Do you want to exit the app?',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.green.shade400,
          ),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.redAccent.shade400,
          ),
          child: const Text(
            'Yes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
