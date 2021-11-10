import 'package:easyvpn/app/app_color.dart';
import 'package:easyvpn/src/screens/settings_screen.dart';
import 'package:easyvpn/src/vpn/vpn_page.dart';
import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// import 'calculator_screen.dart';
// import 'diet_screen.dart';
// import 'settings_screen.dart';
// import 'work_out_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'diet_screen.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final bodyList = [VpnPage(), DietScreen(),SettingsScreen()];

  void onTap(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.BLACK,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60,
          items: <Widget>[
            Icon(Icons.vpn_key, size: 31.sp, color: Colors.white),
            Icon(Icons.food_bank_rounded, size: 32.5.sp, color: Colors.white),
            // Icon(Icons.calculate_rounded, size: 30.sp, color: Colors.white),
            Icon(Icons.settings, size: 30.sp, color: Colors.white),
            //Icon(Icons.perm_identity, size: 30),
          ],
          color: AppColor.LIGHT_BLACK,
          buttonBackgroundColor: AppColor.LIGHT_BLACK,
          backgroundColor: AppColor.BLACK,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 500),
          // onTap: (index) {
          //   setState(() {
          //     _page = index;
          //   });
          // },
          onTap: onTap,
          //letIndexChange: (index) => true,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            // child: _getPage(_page),
            //child: _getPage(_page),
            child: IndexedStack(
              index: _page,
              children: bodyList,
            ),
          ),
        ),
      ),
    );
  }
}

_getPage(int page) {
  switch (page) {
    case 0:
      //   return VpnPage();
      // case 1:
      return VpnPage();
    case 1:
      return VpnPage();
    case 2:
      return SettingsScreen();
  }
}
