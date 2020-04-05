import 'package:flutter/material.dart';
import 'package:odyssee/screens/home/home_list.dart';
import 'package:odyssee/services/auth.dart';
import 'package:odyssee/shared/styles.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarStyle,
        elevation : 0.0,
        title: Text('Home'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async => AuthService().signOut(), 
            icon: Icon(Icons.person, color: Colors.white,), 
            label: Text(
              'Logout',
              style: TextStyle(color: Colors.white)
            )
          )
        ],
      ),

      body: HomeView()
    
    );
    
  }
}