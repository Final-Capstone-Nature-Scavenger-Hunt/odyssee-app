import 'package:flutter/material.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/social/users_list.dart';
import 'package:odyssee/services/database.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';



class FollowUsers extends StatelessWidget {
  @override


  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return  StreamProvider<List<User>>.value(
          value: DatabaseService(uid: user.uid).usersList,
          child: Scaffold(
            appBar: AppBar(
              title:Text('Who To Follow'),
              backgroundColor: Styles.appBarStyle
              ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: UsersList(),
          ),
      )
    );
  }
}