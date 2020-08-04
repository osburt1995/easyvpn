import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easyping/easyping.dart';
import 'package:easyvpn/model/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServerProvider extends ChangeNotifier {
  List<Server> servers = [];
  Server server;
  int selectedIndex = 0;
  bool canChangServer = false; //是否能切换server
  bool isLoading = true;
  List<String> pingValue = [];

  static const String webUrl = 'https://www.jinrikanpian.net/';
  var dio = ServerProvider.createDio();

//  ServerProvider() {
//    servers2List();
//  }

  static Dio createDio() {
    var options = BaseOptions(
      baseUrl: webUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
    );
    return Dio(options);
  }

  Future<void> servers2List() async {
    await getServersJosn().then((value) {
      var serversTmp = json.decode(value);
      server = Server.fromJson(serversTmp[0]);
      serversTmp.forEach((v) async {
        servers.add(Server.fromJson(v));
        await ping(v['address'], times: 1).then((value) {
          pingValue.add(value.toString());
        });
      });
    }).whenComplete(() {
      canChangServer = true;
      isLoading = false;
      notifyListeners();
    });
  }

  ///通过api获取可用的服务器列表
  Future<dynamic> getServersJosn() async {
    Response response;
    try {
      response = await dio.get('appapi.php/api/getservers');
    } catch (e) {
      return null;
    }
    return response.data;
  }

  selectServer(int i) {
    server = servers[i];
    selectedIndex = i;
    notifyListeners();
  }
}
