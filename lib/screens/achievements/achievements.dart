import 'package:flutter/material.dart';
import 'package:odyssee/models/game.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/database.dart';
import 'package:provider/provider.dart';
import 'achievements_list.dart';


class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamProvider<GameData>.value(
      value: DatabaseService(uid: user.uid).rawUserGameData,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              pinned: true,
              backgroundColor: Colors.blue,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200)
                )
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Achievements',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold
                        ),
                      )
              ),
            ),
            
            AchievementsList()

          ],
        )
        ),
    );
  }
}
