import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/providers/servers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';
import 'vpn_bottom_sheet.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VpnServerDropDown extends StatefulWidget {
  @override
  _VpnServerDropDownState createState() => _VpnServerDropDownState();
}

class _VpnServerDropDownState extends State<VpnServerDropDown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServerProvider>(
      builder:
          (BuildContext context, ServerProvider serverProvider, Widget child) {
        if (serverProvider.isLoading) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 1.0, offset: Offset(1.0, 1.0))],
            ),
            padding: EdgeInsets.all(18.0),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Provider.of<ServerProvider>(context,listen: false).servers2List();
              },
              child: Center(
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.update),
//                  CircleAvatar(
//                    radius: 12.0,
//                    backgroundImage: AssetImage(serverProvider.server.icon),
//                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Upgrade Servers',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18.0),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ]),
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 1.0, offset: Offset(1.0, 1.0))],
            ),
            padding: EdgeInsets.all(18.0),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (Provider.of<ServerProvider>(context, listen: false)
                        .canChangServer ==
                    false) {
                  Fluttertoast.showToast(
                      msg: 'The server cannot be switched in connection',
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_LONG);
                } else {
                  showBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        return VpnBottomSheet();
                      });
                }
              },
              child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(
                    radius: 12.0,
                    backgroundImage: AssetImage(serverProvider.server.icon),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      serverProvider.server.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18.0),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ]),
              ),
            ),
          );
        }
      },
    );
  }
}
