import 'package:flutter/material.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/social/feed_list.dart';
import 'package:odyssee/services/auth.dart';
import 'package:odyssee/services/database.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';



class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamProvider<List<Post>>.value(
      value: DatabaseService(uid: user.uid).posts,
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Color(0xFF194000),
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xFFE86935),
            ),
          ),
//          appBar: AppBar(
//            backgroundColor: Styles.appBarStyle,
//            elevation: 0.0,
//            title: Text('Feed'),
//            actions: <Widget>[
//              FlatButton.icon(
//                onPressed: () async => AuthService().signOut(),
//                icon: Icon(Icons.person, color: Colors.white,),
//                label: Text(
//                  'Logout',
//                  style: TextStyle(color: Colors.white)
//                )
//              )
//            ],
//          ),

          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: FeedList()
          )
        )
      );
      
  }
}