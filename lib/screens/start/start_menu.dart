import 'package:flutter/material.dart';
import 'package:odyssee/shared/header_nav.dart';
import 'package:odyssee/screens/map/map.dart';

class StartMenu extends StatelessWidget {                     //modified
  @override                                                        //new
  Widget build (BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/main_background.jpg"), fit: BoxFit.fitHeight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: BaseAppBar(
            title: Text('ODYSSEE'),
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
                    opacity: 0.85,
                    child: Image.asset(
                      "assets/icons/icon_odyssee_detailed.png",
                      scale: 1.55,
                    ),
                  ),
//                  Text('ODYSSEE',
//                    style: new TextStyle(
//                        color: Color(0xEF59B547)
//                    ),
//                  ),
                  MaterialButton(
                    height: 75,
                    minWidth: 300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameMap()),
                      );
                    },
                    color: Color(0xEF194000),
                    textColor: Color(0xFFE5D9A5),
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
