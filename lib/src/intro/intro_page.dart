import 'package:easyvpn/src/vpn/vpn_page.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';
import 'carousel.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Map<String, dynamic>> items = Constants.slides;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Carousel(items: items),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: MaterialButton(
              minWidth: 180.0,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => VpnPage()))
              },
              child: Text('GET STARTED'),
            ),
          )
        ],
      ),
    );
  }
}
