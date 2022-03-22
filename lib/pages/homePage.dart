import 'dart:math';

import 'package:easyvpn/model/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../model/UserPreference.dart';
import '../model/flags.dart';
import '../model/themeCollection.dart';
import '../utils/customlaunch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // Server currentServer = Server();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      Provider.of<UserPreference>(context, listen: false).getServersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    int currentLocIndex = 0;
    var countDown = Provider.of<UserPreference>(context);
    Widget netSpeed(IconData icon, Color color) => Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            Builder(builder: (context) {
              return RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme ? Colors.white : Colors.black),
                      text:
                          Provider.of<UserPreference>(context).isCountDownStart
                              ? Random().nextInt(500).toString() + ' '
                              : '___',
                      children: const [
                    TextSpan(text: 'KB/S', style: TextStyle(fontSize: 12))
                  ]));
            })
          ],
        );
    return ListView(physics: const NeverScrollableScrollPhysics(), children: [
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Card(
      //     elevation: 6,
      //     color:
      //         isDarkTheme ? const Color(0xff181227) : const Color(0xffF5F5F6),
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //     child: Builder(builder: (context) {
      //       currentLocIndex =
      //           Provider.of<UserPreference>(context).locationIndex;
      //       return ListTile(
      //         // leading: SvgPicture.asset(
      //         //   'assets/flags/${Flags.list[currentLocIndex]['imagePath']}',
      //         //   width: 42,
      //         //   alignment: Alignment.center,
      //         // ),
      //         trailing: SizedBox(
      //           width: 80,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             children: [
      //               const Icon(
      //                 Icons.signal_cellular_alt_rounded,
      //                 color: Colors.white,
      //               ),
      //               IconButton(
      //                   icon: Icon(
      //                     Icons.navigate_next_outlined,
      //                     color: Theme.of(context).iconTheme.color,
      //                   ),
      //                   onPressed: () => Navigator.of(context).push(
      //                       MaterialPageRoute(
      //                           builder: (builder) =>
      //                               const ChooseLocationRoute())) as int),
      //             ],
      //           ),
      //         ),
      //         title: Text(
      //           Flags.list[currentLocIndex]['name'] as String,
      //           overflow: TextOverflow.ellipsis,
      //           maxLines: 1,
      //           style: Theme.of(context).primaryTextTheme.headline6,
      //         ),
      //         subtitle: Text('IP: 79.110.53.95',
      //             style: Theme.of(context).primaryTextTheme.caption),
      //       );
      //     }),
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       netSpeed(
      //         Icons.south_rounded,
      //         Theme.of(context).primaryColor,
      //       ),
      //       netSpeed(
      //         Icons.north_rounded,
      //         Theme.of(context).primaryColor,
      //       ),
      //     ],
      //   ),
      // ),
      Card(
        elevation: 6,
        color: isDarkTheme ? const Color(0xff181227) : const Color(0xffF5F5F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading:
              Text('状态:', style: Theme.of(context).primaryTextTheme.headline6),
          title: Builder(builder: (build) {
            if (countDown.state == FlutterVpnState.connecting) {
              return LinearProgressIndicator(
                value: null,
                backgroundColor: Colors.grey.withAlpha(33),
                valueColor: const AlwaysStoppedAnimation(Colors.orange),
              );
            }

            if (countDown.state == FlutterVpnState.connected) {
              return Text(
                '已经连接',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              );
            }
            if (countDown.state == FlutterVpnState.genericError) {
              return Text(
                '连接出错，请检查服务是否可用',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              );
            }
            if (countDown.state == FlutterVpnState.disconnecting) {
              return LinearProgressIndicator(
                value: null,
                backgroundColor: Colors.grey.withAlpha(33),
                valueColor: const AlwaysStoppedAnimation(Colors.orange),
              );
            }

            return Text(
              '无活跃连接',
              style: Theme.of(context).primaryTextTheme.subtitle1,
            );
          }),
          trailing: Builder(
            builder: (build) {
              if (countDown.state == FlutterVpnState.connected) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<UserPreference>(context, listen: false)
                        .onConnect(countDown.current);
                  },
                  child: Text('断开',
                      style: Theme.of(context).primaryTextTheme.headline6),
                );
              }
              return const SizedBox();
            },
          ),
          subtitle: countDown.isconnected
              ? Text(
                  countDown.current.name != null
                      ? (countDown.current.name as String)
                      : countDown.current.address as String,
                  style: Theme.of(context).primaryTextTheme.caption)
              : Text('请点击节点连接',
                  style: Theme.of(context).primaryTextTheme.caption),
        ),
      ),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: SvgPicture.asset(
              'assets/map.svg',
              width: MediaQuery.of(context).size.width,
              color: isDarkTheme
                  ? const Color(0xff38323F)
                  : const Color(0xffC7B4E3),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 500.h,
            child: countDown.serversList!.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Card(
                        elevation: 6,
                        color: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Builder(builder: (context) {
                          // currentLocIndex =
                          //     Provider.of<UserPreference>(context).locationIndex;
                          return ListTile(
                            selectedColor: isDarkTheme
                                ? const Color(0xff38323F)
                                : const Color(0xffC7B4E3),
                            onTap: () {
                              customLaunch(
                                  'https://github.com/shipinbaoku/ikev2-vpn-setup-bash');
                              // Navigator.of(context).pop();
                            },
                            onLongPress: () {},
                            // leading: SvgPicture.asset(
                            //   'assets/flags/${Flags.list[index]['imagePath']}',
                            //   width: 42,
                            // ),
                            title: Text(
                              '还没有专属的ikev2服务?',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            trailing: Icon(
                              Icons.navigate_next_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            subtitle: Text('一键在自己的服务器上建立属于自己的ikev2服务',
                                style:
                                    Theme.of(context).primaryTextTheme.caption),
                          );
                        }),
                      ),
                      Card(
                        elevation: 6,
                        color: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Builder(builder: (context) {
                          // currentLocIndex =
                          //     Provider.of<UserPreference>(context).locationIndex;
                          return ListTile(
                            selectedColor: isDarkTheme
                                ? const Color(0xff38323F)
                                : const Color(0xffC7B4E3),
                            onTap: () {
                              customLaunch(
                                  'https://t.me/easyvpnchannel');
                              // Navigator.of(context).pop();
                            },
                            onLongPress: () {},
                            // leading: SvgPicture.asset(
                            //   'assets/flags/${Flags.list[index]['imagePath']}',
                            //   width: 42,
                            // ),
                            title: Text(
                              '关注我们的频道',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            trailing: Icon(
                              Icons.navigate_next_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            subtitle: Text('收听我们的频道获取更多教程和使用帮助',
                                style:
                                    Theme.of(context).primaryTextTheme.caption),
                          );
                        }),
                      ),
                      Card(
                        elevation: 6,
                        color: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Builder(builder: (context) {
                          // currentLocIndex =
                          //     Provider.of<UserPreference>(context).locationIndex;
                          return ListTile(
                            selectedColor: isDarkTheme
                                ? const Color(0xff38323F)
                                : const Color(0xffC7B4E3),
                            onTap: () {
                              // Navigator.of(context).pop();
                            },
                            onLongPress: () {},
                            // leading: SvgPicture.asset(
                            //   'assets/flags/${Flags.list[index]['imagePath']}',
                            //   width: 42,
                            // ),
                            title: Text(
                              'EasyVpn宗旨:',
                              style:
                              Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            trailing: Icon(
                              Icons.navigate_next_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            subtitle: Text('让您在不安全的网络更加安全、自由的使用互联网!我们不会收集您的个人信息。系统仅会在以下情况下发送技术信息:您提交了反馈;应用出错或者崩溃',
                                style:
                                Theme.of(context).primaryTextTheme.caption),
                          );
                        }),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    // itemCount: Flags.list.length,
                    itemCount: countDown.serversList!.length,
                    itemBuilder: (builder, index) => Card(
                      elevation: 6,
                      color: isDarkTheme
                          ? const Color(0xff181227)
                          : const Color(0xffF5F5F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Builder(builder: (context) {
                        // currentLocIndex =
                        //     Provider.of<UserPreference>(context).locationIndex;
                        return ListTile(
                          selectedColor: isDarkTheme
                              ? const Color(0xff38323F)
                              : const Color(0xffC7B4E3),
                          onTap: () {
                            Provider.of<UserPreference>(context, listen: false)
                                .onConnect(countDown.serversList![index]);
                            // Navigator.of(context).pop();
                          },
                          onLongPress: () {
                            Alert(
                              context: context,
                              //type: AlertType.success,
                              //title: S.of(context).rewardedAd_tips,
                              desc: '确定删除当前节点?',
                              closeFunction: () {
                                Navigator.of(context).pop();
                              },
                              buttons: [
                                DialogButton(
                                  color: Colors.grey,
                                  child: const Text(
                                    '取消',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    //FlutterVpn.simpleConnect(address!, username!, password!);
                                    // showBottomSheet(
                                    //     backgroundColor: Colors.black,
                                    //     context: context,
                                    //     builder: (context) {
                                    //       //return BuyPremium();
                                    //       return !Platform.isAndroid
                                    //           ? BuyPremiumIos()
                                    //           : BuyPremiumNew();
                                    //     });
                                    Navigator.of(context).pop();
                                  },
                                  width: 60,
                                ),
                                DialogButton(
                                  color: Colors.black,
                                  child: const Text(
                                    '删除',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    countDown.removeServer(
                                        countDown.serversList![index]);
                                    Navigator.of(context).pop();
                                  },
                                  width: 60,
                                )
                              ],
                            ).show();
                          },
                          // leading: SvgPicture.asset(
                          //   'assets/flags/${Flags.list[index]['imagePath']}',
                          //   width: 42,
                          // ),
                          title: Text(
                            // Flags.list[index]['name'] as String,
                            countDown.serversList![index].name != null
                                ? (countDown.serversList![index].name as String)
                                : countDown.serversList![index].address
                                    as String,
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          trailing: Icon(
                            Icons.navigate_next_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          subtitle: Text(
                              // 'IP: 79.110.53.95',
                              countDown.serversList![index].address as String,
                              style:
                                  Theme.of(context).primaryTextTheme.caption),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),

      // Builder(builder: (_context) {
      //   return Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: SizedBox(
      //       width: 250.w,
      //       child: ProgressButton(
      //         height: 50.h,
      //         padding: const EdgeInsets.all(10),
      //         stateWidgets: {
      //           ButtonState.idle: Text(
      //             "Click to Connect",
      //             style: GoogleFonts.bebasNeue(
      //                 fontSize: 20.sp,
      //                 fontWeight: FontWeight.w500,
      //                 color: Colors.white,
      //                 letterSpacing: 1),
      //           ),
      //           ButtonState.loading: Text(
      //             "Loading...",
      //             style: GoogleFonts.bebasNeue(
      //                 fontSize: 20.sp,
      //                 fontWeight: FontWeight.w500,
      //                 color: Colors.white,
      //                 letterSpacing: 1),
      //           ),
      //           ButtonState.fail: Text(
      //             "Fail",
      //             style: GoogleFonts.bebasNeue(
      //                 fontSize: 20.sp,
      //                 fontWeight: FontWeight.w500,
      //                 color: Colors.white,
      //                 letterSpacing: 1),
      //           ),
      //           ButtonState.success: Text(
      //             "Connected Success",
      //             style: GoogleFonts.bebasNeue(
      //                 fontSize: 20.sp,
      //                 fontWeight: FontWeight.w500,
      //                 color: Colors.white,
      //                 letterSpacing: 1),
      //           )
      //         },
      //         stateColors: {
      //           ButtonState.idle: Colors.grey.shade400,
      //           ButtonState.loading: Colors.blue.shade300,
      //           ButtonState.fail: Colors.red.shade300,
      //           ButtonState.success: Colors.green.shade400,
      //         },
      //         onPressed: () {
      //           // Provider.of<UserPreference>(context, listen: false).onConnect();
      //         },
      //         state: countDown.buttonState,
      //       ),
      //     ),
      //   );
      //
      //   // return GestureDetector(
      //   //   // onTap: () => Provider.of<UserPreference>(context, listen: false)
      //   //   //     .countDownSwitch,
      //   //   onTap: () =>
      //   //       Provider.of<UserPreference>(context, listen: false).onConnect(),
      //   //   child: Card(
      //   //     elevation: 6,
      //   //     color:
      //   //         isDarkTheme ? const Color(0xff181227) : const Color(0xffF5F5F6),
      //   //     shape: RoundedRectangleBorder(
      //   //         borderRadius: BorderRadius.circular(100)),
      //   //     child: SizedBox.square(
      //   //       dimension: 75 * 2,
      //   //       child: Column(
      //   //           crossAxisAlignment: CrossAxisAlignment.center,
      //   //           mainAxisAlignment: MainAxisAlignment.center,
      //   //           children: [
      //   //             SvgPicture.asset(
      //   //               countDown.isCountDownStart
      //   //                   ? 'assets/stop.svg'
      //   //                   : 'assets/powOn.svg',
      //   //               width: countDown.isCountDownStart ? 35 : 50,
      //   //               color: countDown.isCountDownStart
      //   //                   ? Colors.redAccent.shade200
      //   //                   : Theme.of(context).accentColor,
      //   //             ),
      //   //             Padding(
      //   //               padding: const EdgeInsets.only(top: 8.0),
      //   //               child: Text(
      //   //                 countDown.isCountDownStart
      //   //                     ? '${countDown.duration.inHours} : ${countDown.duration.inMinutes % 60} : ${countDown.duration.inSeconds % 60}'
      //   //                     : 'Start',
      //   //                 style: TextStyle(
      //   //                   fontSize: 14,
      //   //                   color: Theme.of(context).accentColor,
      //   //                 ),
      //   //               ),
      //   //             )
      //   //           ]),
      //   //     ),
      //   //   ),
      //   // );
      // })
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
