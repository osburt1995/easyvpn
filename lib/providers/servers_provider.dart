import 'dart:convert';

import 'package:dart_ping/dart_ping.dart';
import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/utils/server_service.dart';
import 'package:easyvpn/utils/storage.dart';
import 'package:flutter/cupertino.dart';

class ServerProvider extends ChangeNotifier {
  List<Server> servers = [];
  Server server;
  int selectedIndex = 0;
  bool canChangServer = false; //是否能切换server
  //bool isLoading = true;
  String pingResult = '暂无ping结果';

  // static const String webUrl = 'https://www.jinrikanpian.net/';
  // var dio = ServerProvider.createDio();

//  ServerProvider() {
//    servers2List();
//  }

  // static Dio createDio() {
  //   var options = BaseOptions(
  //     baseUrl: webUrl,
  //     connectTimeout: 10000,
  //     receiveTimeout: 100000,
  //   );
  //   return Dio(options);
  // }

  Future<void> servers2List() async {
    await getServers().then((value) {
      //var serversTmp = json.decode(value);
      //print(value[0]);
      //server = Server.fromJson(value[0]);
      servers = [];
      value.forEach((v) {
        servers.add(Server.fromJson(v));
      });
      //canChangServer = true;
      //isLoading = false;
      notifyListeners();
    });
  }

  ///通过api获取可用的服务器列表
  // Future<dynamic> getServersJosn() async {
  //   Response response;
  //   try {
  //     response = await dio.get('appapi.php/api/getservers');
  //   } catch (e) {
  //     return null;
  //   }
  //   return response.data;
  // }
  ///获取用户保存的vpn配置
  Future<dynamic> getServers() {
    return ServerSercice.getList('servers');
  }

  selectServer(int i) {
    //print(i);
    //print('第几个');
    server = servers[i];
    //print(server.name);
    selectedIndex = i;
    notifyListeners();
  }

  removeServer(index) async {
    servers.removeAt(index);
    print(servers);
    await Storage.setString('servers', json.encode(servers));
    notifyListeners();
  }

  buildPingResult(int index) async {
    final ping = Ping(servers[index].address, count: 5);
    // Begin ping process and listen for output
    ping.stream.listen((event) {
      if (event.response != null) {
        pingResult = event.response.time.inMilliseconds.toString() + 'ms';
      }
    });
  }
}
