import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:odyssee/wrapper.dart';

class Splash extends StatelessWidget{
  @override
  Widget build (BuildContext context) {
    return new SplashScreen(
        seconds: 8,
        navigateAfterSeconds: new Wrapper(),
        title: new Text('ODYSSEE',
          style: new TextStyle(
            fontFamily: 'Kiri',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
//            color: Color(0xEF59B547)
          ),
        ),
        image: new Image.asset('assets/icons/icon_odyssee_detailed.png'),
        backgroundColor: Color(0xFF194000),
        loadingText: new Text('Starting your Odyssee...',
          style: new TextStyle(
            color: Color(0xEF59B547)
          ),
        ),
//        styleTextUnderTheLoader: color: Color(0xEF59B547),
        photoSize: 100.0,
        loaderColor: Color(0xFFE86935)
    );
  }
}