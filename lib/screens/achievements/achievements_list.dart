import 'package:flutter/material.dart';
import 'package:odyssee/data/achievements.dart';
import 'package:odyssee/models/game.dart';
import 'package:provider/provider.dart';
import 'achievement_item.dart';

class AchievementsList extends StatefulWidget {
  @override
  _AchievementsListState createState() => _AchievementsListState();
}

class _AchievementsListState extends State<AchievementsList> {
  @override
  Widget build(BuildContext context) {
    final userGameData = Provider.of<GameData>(context);
    final achievementsList = userGameData.achievements.map((item) => Achievements.achievementsMap[item]).toList();

    return SliverPadding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20),
            sliver: SliverFixedExtentList(
            itemExtent: 80.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                String achivementName = achievementsList[index]['AchievementName'];
                String achievementDescription = achievementsList[index]['achievementDescription'];
                String achievementImage = achievementsList[index]['achievementImage'];
                return AchievementItem(achievementImage: achievementImage, achievementName: achivementName, 
                                        achievementDescription: achievementDescription,);
              },
              childCount: achievementsList.length
            ),
          ),
        );
  }
}