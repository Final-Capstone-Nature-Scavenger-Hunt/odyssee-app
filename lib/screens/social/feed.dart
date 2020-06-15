import 'package:flutter/material.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/social/feed_list.dart';
import 'package:odyssee/services/database.dart';
import 'package:provider/provider.dart';
import 'package:odyssee/shared/header_nav.dart';

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
        drawer: BaseDrawer(),
        backgroundColor: Colors.brown[100],
        body: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(top:15.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text('The Herd',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold
                    )
                  )
                ]
              )
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:15.0, horizontal:20.0),
                child: FeedList()
              ),
            )

          ],
        ),
      )
    );
        
  }
}