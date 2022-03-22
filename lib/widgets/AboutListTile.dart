import 'package:flutter/material.dart';

class AboutListTileDemo extends StatelessWidget {
  const AboutListTileDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AboutListTile(
      icon: Icon(Icons.info),
      applicationIcon: FlutterLogo(),
      applicationName: 'Flutter Unit',
      applicationVersion: 'v0.0.1',
      applicationLegalese: 'Copyright© 2018-2020 张风捷特烈',
      aboutBoxChildren: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            '      FlutterUnit是【张风捷特烈】的开源项目，'
            '收录Flutter的200+组件，并附加详细介绍以及操作交互，'
            '希望帮助广大编程爱好者入门Flutter。'
            '更多知识可以关注掘金账号、公众号【编程之王】。',
            style: TextStyle(color: Color(0xff999999), fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
