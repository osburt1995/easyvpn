import 'dart:convert';

import 'package:dart_ping/dart_ping.dart';
import 'package:easyvpn/app/app_color.dart';
import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/providers/servers_provider.dart';
import 'package:easyvpn/src/vpn/vpn_bottom_sheet_add.dart';
import 'package:easyvpn/utils/server_service.dart';
import 'package:easyvpn/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//class VpnBottomSheet extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final List servers =
//        Provider.of<ServerProvider>(context, listen: false).servers;
//    return Container(
//      decoration: BoxDecoration(
//        color: Colors.white,
//        boxShadow: [BoxShadow(blurRadius: 1.0, offset: Offset(1.0, 1.0))],
//        borderRadius: const BorderRadius.only(
//            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
//      ),
//      padding: const EdgeInsets.all(12.0),
//      height: MediaQuery.of(context).size.height * 0.5,
//      child: Column(
//        children: <Widget>[
//          Container(
//            padding: const EdgeInsets.all(10.0),
//            child: Text(
//              'Pick Your Server',
//              style: TextStyle(fontSize: 18.0),
//            ),
//          ),
//          Expanded(
//            child: ListView.builder(
//              itemCount: servers.length,
//              itemBuilder: (BuildContext context, int index) => ListTile(
//                //onTap: () => onServerTap(index),
//                onTap: () {
//                  Provider.of<ServerProvider>(context, listen: false)
//                      .selectServer(index);
//                  Navigator.of(context).pop();
//                },
//                dense: true,
//                title: Text(
//                  servers[index].name,
//                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
//                ),
//                leading: CircleAvatar(
//                  radius: 15.0,
//                  backgroundImage: AssetImage(servers[index].icon),
//                ),
//                trailing: Icon(
//                  Provider.of<ServerProvider>(context).selectedIndex == index
//                      ? Icons.check_circle
//                      : Icons.panorama_fish_eye,
//                  color: Provider.of<ServerProvider>(context, listen: false)
//                              .selectedIndex ==
//                          index
//                      ? Theme.of(context).primaryColor
//                      : Colors.grey,
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}

class VpnBottomSheet extends StatefulWidget {
  @override
  _VpnBottomSheetState createState() => _VpnBottomSheetState();
}

class _VpnBottomSheetState extends State<VpnBottomSheet> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('cant launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Server> servers =
        Provider.of<ServerProvider>(context, listen: false).servers;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 1.0, offset: Offset(1.0, 1.0))],
//        borderRadius: const BorderRadius.only(
//            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      padding: const EdgeInsets.all(12.0),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '请选择节点',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            child: (servers == null || servers.length == 0)
                ? Padding(
                    padding: EdgeInsets.all(30.w),
                    //EdgeInsets.only(left: 5.w, right: 5.w),
                    child: InkWell(
                      onTap: () {
                        customLaunch(
                            'https://www.strongswans.net/index.php/store/vpn');
                        // Navigator.push(
                        //   context,
                        //   SlideLeftTransition(IntermittentScreen()),
                        // );
                      },
                      child: Container(
                        //height: 10.h,
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
                              '基于安全，本应用需要自行添加可用资源，还请各位自己动手!',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            Text(
                              '立即获取免费账号',
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
                  )
                : ListView.builder(
                    itemCount: servers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = index.toString();
                      final name = servers[index].name;
                      return Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify Widgets.
                        key: new Key(item),
                        // We also need to provide a function that will tell our app
                        // what to do after an item has been swiped away.
                        confirmDismiss: (direction) async {
                          if (Provider.of<ServerProvider>(context,
                                      listen: false)
                                  .selectedIndex ==
                              index) {
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(content: new Text("选中状态的节点无法删除")));
                            return false;
                          } else {
                            servers.removeAt(index);

                            ///删除本地储存
                            List<Server> tempList = [];
                            tempList.addAll(servers);
                            await Storage.setString(
                                'servers', json.encode(tempList));
                            setState(() {
                              servers = tempList;
                            });
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(content: new Text("$name 已经删除")));
                            return true;
                          }
                        },
                        onDismissed: (direction) async {},
                        // Show a red background as the item is swiped away
                        background: Container(color: Colors.yellow),
                        child: ListTile(
                          onLongPress: () {
                            print("长按了");
                          },
                          //onTap: () => onServerTap(index),
                          onTap: () {
                            Provider.of<ServerProvider>(context, listen: false)
                                .selectServer(index);
                            Navigator.of(context).pop();
                          },
                          dense: true,
                          title: Text(
                            servers[index].name,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          //subtitle: ,
                          leading: CircleAvatar(
                            radius: 15.0,
                            backgroundImage:
                                AssetImage('assets/icons/automatic.png'),
                          ),
                          trailing: Icon(
                            Provider.of<ServerProvider>(context)
                                        .selectedIndex ==
                                    index
                                ? Icons.check_circle
                                : Icons.panorama_fish_eye,
                            color: Provider.of<ServerProvider>(context,
                                            listen: false)
                                        .selectedIndex ==
                                    index
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VpnBottomSheetAdd()));
              },
              child: Text('添加VPN配置'))
        ],
      ),
    );
  }
}
