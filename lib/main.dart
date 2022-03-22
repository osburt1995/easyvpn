import 'dart:io';

import 'package:easyvpn/pages/addServerPage.dart';
import 'package:easyvpn/routes/settingsRoute.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vpn/flutter_vpn.dart';

import 'model/UserPreference.dart';
import '/routes/proRoute.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/accountPage.dart';
import 'pages/homePage.dart';
import '/model/themeCollection.dart';
import 'pages/proPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.getInstance();
// Set device orientation in potrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(

// For demonstration purpose I didn't store information on device or server
// so, info. destroy when you restart an application
          MultiProvider(providers: [
        ChangeNotifierProvider<ThemeCollection>.value(value: ThemeCollection()),
        ChangeNotifierProvider<UserPreference>.value(value: UserPreference())
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        //... other code
        builder: (context, widget) {
          //add this line
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        theme: Provider.of<ThemeCollection>(context).getActiveTheme,
        home: const MyHomePage(),
      ),
    );

    return MaterialApp(
      title: 'Dream VPN',
      theme: Provider.of<ThemeCollection>(context).getActiveTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  final List<Map<String, dynamic>> _itemsList = const [
    {'name': '首页', 'iconPath': 'assets/home.svg', 'route': HomePage()},
    // {'name': 'Pro', 'iconPath': 'assets/logo.svg', 'route': ProPage()},
    {
      'name': '设置',
      'iconPath': 'assets/settings.svg',
      'route': SettingsRoute()
    }
  ];

  @override
  void initState() {
    super.initState();
    FlutterVpn.prepare();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (builder) => const AddServerPage()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: currentPage == 1
              ? const Text('设置')
              : SvgPicture.asset(
                  'assets/text.svg',
                  height: 18,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
          // actions: currentPage == 0
          //     ? [
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: GestureDetector(
          //             onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (builder) => const ProRoute())),
          //             child: SvgPicture.asset(
          //               'assets/gopro.svg',
          //               height: 18,
          //             ),
          //           ),
          //         ),
          //       ]
          //     : null,
        ),

/*Here Bottom Navigation Bar with some padding, margin,
 little bit color & border decoration*/
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
          padding: const EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
              color:
                  const Color(0xff353351).withOpacity(isDarkTheme ? 0.3 : 0.05),
              borderRadius: BorderRadius.circular(20)),
          child: BottomNavigationBar(
              enableFeedback: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedLabelStyle:
                  TextStyle(color: Theme.of(context).primaryColor),
              selectedItemColor: Theme.of(context).primaryColor,
              currentIndex: currentPage,
              onTap: (value) => setState(() {
                    currentPage = value;
                  }),
              items: List.generate(
                  _itemsList.length,
                  (index) => BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                            _itemsList[index]['iconPath'] as String,
                            height: index != currentPage ? 20 : 24,
                            color: index != currentPage
                                ? const Color(0xffB5AEBE)
                                : Theme.of(context).primaryColor),
                        label: _itemsList[index]['name'] as String,
                      ))),
        ),
        body: _itemsList[currentPage]['route'] as Widget);
  }
}
