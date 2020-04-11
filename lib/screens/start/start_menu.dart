import 'package:flutter/material.dart';
import 'package:odyssee/shared/header_nav.dart';
import 'package:odyssee/screens/map/map.dart';
import 'package:odyssee/shared/styles.dart';

class StartMenu extends StatelessWidget {                     //modified
  @override                                                        //new
  Widget build (BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: Styles.authBackgroundDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: BaseAppBar(
            title: Text('Main Menu'),
            appBar: AppBar(),
          ),
          drawer: BaseDrawer(),
          body: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Opacity(
                    opacity: 1,
                    child: Image.asset(
                      "assets/icons/icon_odyssee_detailed.png",
                      scale: 1.7,
                    ),
                  ),
//                  Text('ODYSSEE',
//                    style: new TextStyle(
//                        color: Color(0xEF59B547)
//                    ),
//                  ),
                  Container(
//                    padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
                    child: Text('ODYSSEE',
                      style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'BOTW',
  //            fontWeight: FontWeight.bold,
                        fontSize: 45.0,
  //            color: Color(0xEF59B547)
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xFFE86935),
                    indent: 30,
                    endIndent: 30,
                    thickness: 2,
                  ),
                  MaterialButton(
                    height: 75,
                    minWidth: 300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameMap()),
                      );
                    },
                    color: Color(0xFF59B547),
                    textColor: Colors.white,
                    child: new Text('PLAY!',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                  MaterialButton(
                    height: 50,
                    minWidth: 250,
                    onPressed: () {},
                    color: Color(0xEF615F5F),
                    textColor: Color(0xFFE5D9A5),
                    child: Text('How to Play'),
                  ),
                  MaterialButton(
                    height: 50,
                    minWidth: 250,
                    onPressed: () {},
                    color: Color(0xEF615F5F),
                    textColor: Color(0xFFE5D9A5),
                    child: Text('News and Updates'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
