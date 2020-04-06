import 'package:flutter/material.dart';
import 'package:odyssee/screens/achievements/achievements.dart';
import 'package:odyssee/screens/authenticate/authenticate.dart';
import 'package:odyssee/screens/social/feed.dart';
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
          appBar: new AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xFFE86935),
            ),
          ),
          drawer: Drawer(
            elevation: 15.0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("Placeholder name",
                    style: TextStyle(
                      color: Color(0xFFE5D9A5),
                      fontSize: 25,
                    ),
                  ),
                  accountEmail: Text("Placeholder email.com"),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/drawer_background.jpg"), fit: BoxFit.cover)
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color(0xFFE5D9A5),
//                    child: Text(
//                      'Account Placeholder',
//                      style: TextStyle(
//                        color: Color(0xFFE5D9A5),
//                        fontSize: 30,
//                      ),
//                    ),
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Account',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.group,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Social',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Feed()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.flag,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Achievements',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Achievements()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Back to Main Menu',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartMenu()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/icon_odyssee_orange.png"),
                      ),
                    ),
                  ),
                  MaterialButton(
                    height: 75,
                    minWidth: 300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Map()),
                      );
                    },
                    color: Color(0xEF194000),
                    textColor: Color(0xFFE5D9A5),
                    child: Text('PLAY!'),
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
