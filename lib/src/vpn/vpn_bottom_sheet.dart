import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/providers/servers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final List<Server> servers =
        Provider.of<ServerProvider>(context, listen: false).servers;
    if (Provider.of<ServerProvider>(context).isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
                'Pick Your Server',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: servers.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  //onTap: () => onServerTap(index),
                  onTap: () {
                    Provider.of<ServerProvider>(context, listen: false)
                        .selectServer(index);
                    Navigator.of(context).pop();
                  },
                  dense: true,
                  title: Text(
                    servers[index].name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  subtitle: FutureBuilder(
                      future: Provider.of<ServerProvider>(context)
                          .builPingWidget(index),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.hasData) return snapshot.data;

                        return Text('Waiting for ping result...');
                      }),
                  leading: CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage(servers[index].icon),
                  ),
                  trailing: Icon(
                    Provider.of<ServerProvider>(context).selectedIndex == index
                        ? Icons.check_circle
                        : Icons.panorama_fish_eye,
                    color: Provider.of<ServerProvider>(context, listen: false)
                                .selectedIndex ==
                            index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
