//ignore_for_file: file_names

import 'dart:async';

import 'package:easyvpn/model/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vpn/flutter_vpn.dart';

import '../app/global_data.dart';
import '../utils/storage.dart';

class UserPreference extends ChangeNotifier {
  var state = FlutterVpnState.disconnected;
  bool isconnected = false;

// Initally Location index is 0
  int locationIndex = 0;
  late Server current;
  List<Server>? serversList = [];

// Change current location by call setlocationIndex method(function)
  void setlocationIndex(int index) {
    locationIndex = index;
    notifyListeners();
  }

//获取全部服务器列表
  getServersList() {
    serversList = [];
    Storage.getObjectList(GlobalData.SERVERS_LIST)?.forEach((element) {
      serversList?.add(Server.fromJson(element));
    });
    notifyListeners();
  }

//增加一个服务器
  addServer(server) {
    //print(server.toString());
    serversList?.add(server);
    Storage.putObjectList(GlobalData.SERVERS_LIST, serversList!);
    notifyListeners();
  }

//删除一个服务器
  removeServer(server) {
    print(serversList);
    serversList?.remove(server);
    print(serversList);
    Storage.putObjectList(GlobalData.SERVERS_LIST, serversList!);
    notifyListeners();
  }

// Setup for coundown service
  Duration duration = Duration.zero;
  bool isCountDownStart = false;
  final Stream _stream = Stream.periodic(const Duration(seconds: 1));

  UserPreference() {
    _stream.listen((event) {
      if (isCountDownStart) {
        duration += const Duration(seconds: 1);
        notifyListeners();
      }
    });
    // FlutterVpn.onStateChanged.listen((s) {
    //   if (s == FlutterVpnState.connected) {
    //     isCountDownStart = true;
    //     duration += const Duration(seconds: 1);
    //   }
    //   if (s == FlutterVpnState.connecting) {}
    //   if (s == FlutterVpnState.disconnected) {
    //     isCountDownStart = false;
    //   }
    //   if (s == FlutterVpnState.genericError) {}
    //   state = s;
    //   notifyListeners();
    // });
  }

  void get countDownSwitch {
    isCountDownStart = !isCountDownStart;
    notifyListeners();
  }

  // onStatusChangedListen() {
  //   FlutterVpn.onStateChanged.listen((s) {
  //     if (s == FlutterVpnState.connected) {}
  //     if (s == FlutterVpnState.connecting) {}
  //     if (s == FlutterVpnState.disconnected) {}
  //     if (s == FlutterVpnState.genericError) {}
  //     state = s;
  //     notifyListeners();
  //   });
  // }

  onConnect(Server server) {
    current=server;
    FlutterVpn.onStateChanged.listen((s) {
      if (s == FlutterVpnState.connected) {
        isconnected = true;
        isCountDownStart = true;
        duration += const Duration(seconds: 1);
      }
      if (s == FlutterVpnState.connecting) {}
      if (s == FlutterVpnState.disconnected) {
        isconnected = false;
        isCountDownStart = false;
      }
      if (s == FlutterVpnState.genericError) {
        isconnected = false;
      }
      if (s == FlutterVpnState.disconnecting) {
        isconnected = false;
      }
      state = s;
      notifyListeners();
    });

    if (state == FlutterVpnState.connected) {
      FlutterVpn.disconnect();
    } else if (state == FlutterVpnState.connecting) {
    } else if (state == FlutterVpnState.disconnected) {
      FlutterVpn.simpleConnect(
          server.address!, server.username!, server.password!);
      // FlutterVpn.simpleConnect('asia-singapore.strongswans.net', 'wwk', 'wwk');
    } else if (state == FlutterVpnState.disconnecting) {
    } else if (state == FlutterVpnState.genericError) {
      FlutterVpn.disconnect();
    }
  }
}
