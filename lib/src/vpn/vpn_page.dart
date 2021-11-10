import 'package:easyvpn/app/app_color.dart';
import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/providers/servers_provider.dart';
import 'package:easyvpn/src/vpn/vpn_bottom_sheet.dart';
import 'package:easyvpn/utils/admob_instance.dart';
import 'package:easyvpn/utils/server_service.dart';
import 'package:easyvpn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_assets.dart';
import 'vpn_server_dropdown.dart';
import 'vpn_status_widget.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:animator/animator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VpnPage extends StatefulWidget {
  @override
  _VpnPageState createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> with AutomaticKeepAliveClientMixin {
  bool isConnected = false;
  String buttonText = 'Connect Now';
  String statusLabel = 'Disconnected';
  Color statusColor = Colors.grey;
  var state = FlutterVpnState.disconnected;

  final bgColorDisconnected = [Color(0xFF000000), Color(0xFFDD473D)];
  final bgColorConnected = [Color(0xFF000000), Color(0xFF37AC53)];
  final bgColorConnecting = [Color(0xFF000000), Color(0xFFCCAD00)];

  onConnect() {
    String address =
        Provider.of<ServerProvider>(context, listen: false).server.address;
    String username =
        Provider.of<ServerProvider>(context, listen: false).server.username;
    String password =
        Provider.of<ServerProvider>(context, listen: false).server.password;
    if (state == FlutterVpnState.connected) {
      FlutterVpn.disconnect();
      setState(() {
        isConnected = false;
      });
    } else {
      FlutterVpn.simpleConnect(address, username, password);
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    //ServerSercice.removeList('servers');
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) {
      if (s == FlutterVpnState.connected) {
        buttonText = 'Disconnect';
        statusLabel = 'Connected';
        statusColor = Colors.green;
        Provider.of<ServerProvider>(context, listen: false).canChangServer =
            false;
        AdmobInstance.instance;
        Future.delayed(Duration(seconds: 5)).then((value) {
          AdmobInstance.instance.showRewardedVideoAd();
          //AdmobInstance.instance.showInterstitialAd();
          //AdmobInstance.instance.showBannerlAd();
        });

        // Device Connected
      }
      if (s == FlutterVpnState.connecting) {
        Provider.of<ServerProvider>(context, listen: false).canChangServer =
            false;
        // Device Connected
      }
      if (s == FlutterVpnState.disconnected) {
        AdmobInstance.instance.showInterstitialAd();
        buttonText = 'Connect Now';
        statusLabel = 'Disconnected';
        statusColor = Colors.grey;
        Provider.of<ServerProvider>(context, listen: false).canChangServer =
            true;
        // Device Disconnected
      }
      if (s == FlutterVpnState.genericError) {
        Provider.of<ServerProvider>(context, listen: false).canChangServer =
            true;
        Fluttertoast.showToast(
            msg:
                'Connection failed. Please check the network or switch VPN server',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        FlutterVpn.disconnect();
      }
      setState(() {
        state = s;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ServerProvider>(context, listen: false).servers2List();
    return Container(
      color: AppColor.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.BLACK,
          //body: buildBody(context),
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
                      'Easy',
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
                      'Vpn',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff8E2DE2),
                          letterSpacing: 3),
                    ),
                  ],
                ),
              ),
              Expanded(child: buildBody(context),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    if (state == FlutterVpnState.connected) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/map-pattern.png"),
              fit: BoxFit.contain,
            ),
            gradient: LinearGradient(
                colors: bgColorConnected,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: VpnStatus(
                        label: 'Connected', statusColor: Colors.green),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Image.asset(AppAssets.online),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    minWidth: 200.0,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: isConnected
                            ? BorderSide(color: Colors.black)
                            : BorderSide(color: Colors.transparent)),
                    color: isConnected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    textColor: isConnected ? Colors.black : Colors.white,
                    onPressed: () => {onConnect()},
                    child: Text('Disconnect'.toUpperCase()),
                  ),
                ],
              ),
            ),
            VpnServerDropDown(),
          ],
        ),
      );
    } else if (state == FlutterVpnState.connecting) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/map-pattern.png"),
              fit: BoxFit.contain,
            ),
            gradient: LinearGradient(
                colors: bgColorDisconnected,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Animator(
                    duration: Duration(seconds: 2),
                    repeats: 0,
                    builder: (anim) => FadeTransition(
                      opacity: anim,
                      child: Text(
                        "CONNECTING",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat-SemiBold",
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SpinKitRipple(
                    color: Colors.white,
                    size: 190.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            VpnServerDropDown(),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/map-pattern.png"),
              fit: BoxFit.contain,
            ),
            gradient: LinearGradient(
                colors: bgColorDisconnected,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: VpnStatus(
                        label: 'Disconnected', statusColor: Colors.grey),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Image.asset(AppAssets.offline),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    minWidth: 200.0,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: isConnected
                            ? BorderSide(color: Colors.black)
                            : BorderSide(color: Colors.transparent)),
                    color: isConnected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    textColor: isConnected ? Colors.black : Colors.white,
                    onPressed: () {
                      if (Provider.of<ServerProvider>(context, listen: false)
                              .server ==
                          null) {
                        Fluttertoast.showToast(
                            msg: '请选择或添加节点',
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG);
                      } else {
                        onConnect();
                      }
                    },
                    child: Text('Connect Now'.toUpperCase()),
                  ),
                ],
              ),
            ),
            VpnServerDropDown(),
          ],
        ),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
