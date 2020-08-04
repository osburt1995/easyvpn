import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easyping/easyping.dart';
import 'package:easyvpn/model/server.dart';
import 'package:flutter/cupertino.dart';

class ServerProvider extends ChangeNotifier {
  List<Server> servers = [];
  Server server;
  int selectedIndex = 0;
  bool canChangServer = false; //是否能切换server
  bool isLoading = true;

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
      });
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

  Future<Widget> builPingWidget(int index) async {
    var pingResult = await ping(servers[index].address, times: 2);
    if (pingResult == 0.0) {
      return Text('So slow');
    } else {
      return Text(
        pingResult.toString() + 'ms',
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      );
    }
  }
}
