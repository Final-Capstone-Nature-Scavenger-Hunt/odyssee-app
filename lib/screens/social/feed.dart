import 'package:flutter/material.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/social/feed_list.dart';
import 'package:odyssee/services/database.dart';
import 'package:odyssee/shared/header_nav.dart';
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
          appBar: BaseAppBar(
            title: Text('Social Feed'),
            appBar: AppBar(),
          ),
          drawer: BaseDrawer(),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: FeedList()
          )
        )
      );
      
  }
}