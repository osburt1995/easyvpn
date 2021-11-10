import 'package:easyvpn/app/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '/animations/transitions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'daydietplan/gmdiet_screen.dart';
import 'intermittent_fasting/intermittent_fasting_screen.dart';
import 'keto/ketodiet_screen.dart';

class DietScreen extends StatefulWidget {
  // const DietScreen({Key? key}) : super(key: key);

  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '教程',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      '说明',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xfff5af19),
                          letterSpacing: 3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.w,
                    ),
                    child: Text(
                      'Easy Vpn 支持所有IKEv2协议',
                      style: GoogleFonts.lato(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      '以下教程有助于您更好使用',
                      style: GoogleFonts.lato(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: InkWell(
                      onTap: () {
                        customLaunch(
                            'https://www.strongswans.net/index.php/store/vpn');
                        // Navigator.push(
                        //   context,
                        //   SlideLeftTransition(KetoDietScreen()),
                        // );
                      },
                      child: Container(
                        height: 150.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xfff12711),
                              Color(0xfff5af19),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '获取Free Plan计划',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            Text(
                              '立即获取免费计划',
                              style: GoogleFonts.teko(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: InkWell(
                      onTap: () {
                        customLaunch(
                            'https://www.strongswans.net/index.php/knowledgebase/7/%E5%90%84%E7%A7%8D%E5%AE%A2%E6%88%B7%E7%AB%AF%E9%85%8D%E7%BD%AE%E6%AD%A5%E9%AA%A4.html');
                        // Navigator.push(
                        //   context,
                        //   SlideLeftTransition(IntermittentScreen()),
                        // );
                      },
                      child: Container(
                        height: 150.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              //orange.........
                              Color(0xfff12711),
                              Color(0xfff5af19),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '各操作系统配置教程',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            Text(
                              '立即查看配置教程',
                              style: GoogleFonts.teko(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: InkWell(
                      onTap: () {
                        customLaunch(
                            'https://t.me/joinchat/wUEBZOU1KHVjYmE1');
                        // Navigator.push(
                        //   context,
                        //   SlideLeftTransition(DayScreen()),
                        // );
                      },
                      child: Container(
                        height: 150.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              //orange.........
                              Color(0xfff12711),
                              Color(0xfff5af19),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '加入电报',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            Text(
                              '请连接上VPN后点击加入Telegram',
                              style: GoogleFonts.teko(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
