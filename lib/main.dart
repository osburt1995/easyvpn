import 'package:easyvpn/providers/servers_provider.dart';
import 'package:easyvpn/src/screens/home_screen.dart';
import 'package:easyvpn/src/vpn/vpn_page.dart';
import 'package:easyvpn/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'app/app_color.dart';
import 'src/intro/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColor.LIGHT_BLACK,
    ),
  );
  await Storage.getInstance();
//  runApp(VpnApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerProvider()),
      ],
      child: VpnApp(),
    ),
  );
}

class VpnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'EASYVPN',
    //   color: Colors.white,
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //       scaffoldBackgroundColor: Colors.white,
    //       appBarTheme: AppBarTheme(elevation: 0.0, color: Colors.white)),
    //   //home: IntroPage(),
    //   //home:VpnPage(),
    //   home:HomeScreen(),
    // );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      //designSize: Size(392.72727272727275, 807.2727272727273),
      builder: () => MaterialApp(
        theme: ThemeData(
          accentColor: AppColor.LIGHT_BLACK,
        ),
        debugShowCheckedModeBanner: false,
        // title: 'Flutter Demo',
        home: HomeScreen(),
      ),
    );
  }
}



