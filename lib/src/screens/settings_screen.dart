import 'package:easyvpn/app/app_color.dart';

import '/animations/transitions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  // const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('cant launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.BLACK,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25.h,
                ),
                child: Text(
                  'SETTINGS',
                  style: GoogleFonts.bebasNeue(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3),
                ),
              ),
              // SizedBox(height: 50.h),
              Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 28.0.w, right: 28.w),
                    child: Container(
                      padding: EdgeInsets.all(18.h),
                      height: 500.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                        color: AppColor.LIGHT_BLACK,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '支持我们',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 31.h),
                            child: ListTile(
                              // tileColor: AppColors.BLACK,
                              title: Text(
                                '去投票',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              leading: Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                              onTap: () {
                                customLaunch(
                                    'https://play.google.com/store/apps/details?id=app.easyvpn');
                              }, //........................................
                            ),
                          ),
                          ListTile(
                            // tileColor: AppColors.BLACK,
                            title: Text(
                              '给star',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            leading: Icon(
                              Icons.gite,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                            onTap: () {
                              customLaunch(
                                  'https://github.com/shipinbaoku/easyvpn');
                            }, //........................................
                          ),
                          ListTile(
                            // tileColor: AppColors.BLACK,
                            title: Text(
                              '使用教程',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            leading: Icon(
                              Icons.golf_course,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                            onTap: () {
                              customLaunch(
                                  'https://www.strongswans.net/index.php/knowledgebase/7/%E5%90%84%E7%A7%8D%E5%AE%A2%E6%88%B7%E7%AB%AF%E9%85%8D%E7%BD%AE%E6%AD%A5%E9%AA%A4.html');
                            },
                          ),
                          ListTile(
                            // tileColor: AppColors.BLACK,
                            title: Text(
                              '获取免费计划',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            leading: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: FaIcon(
                                FontAwesomeIcons.freebsd,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                            ),
                            onTap: () {
                              customLaunch(
                                  'https://www.strongswans.net/index.php/store/vpn');
                            }, //........................................
                          ),
                          ListTile(
                            // tileColor: AppColors.BLACK,
                            title: Text(
                              'Privacy & Conditions',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            leading: Icon(
                              Icons.privacy_tip_rounded,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                            onTap: () {
                              customLaunch(
                                  'https://www.strongswans.net/index.php/knowledgebase/1/privacy-policy.html');
                              // Navigator.push(
                              //   context,
                              //   SlideLeftTransition(TermsScreen()),
                              // );
                            }, //........................................
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '感谢支持! 我们将加倍努力',
                    style: GoogleFonts.bebasNeue(
                        textStyle:
                            TextStyle(color: Colors.white60, fontSize: 17.sp)),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Icon(
                    Icons.favorite,
                    size: 20.sp,
                    color: Colors.deepPurpleAccent,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
