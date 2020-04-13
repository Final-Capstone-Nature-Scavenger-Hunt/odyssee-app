import 'package:flutter/material.dart';
import 'package:odyssee/data/achievements.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsUpdater {

  Future updateFoundItem(String foundItem, User user) async{
    final prefs = await SharedPreferences.getInstance();

    List<String> achievementsList = prefs.getStringList('achievements') ?? List();
    Set<String> achievementsSet = achievementsList.toSet();
    

    achievementsSet.add(foundItem);

    prefs.setStringList('achievements', achievementsSet.toList());

    var achievementsMap = Achievements.achievementsMap;

    List<String> newAchievements = [];

    achievementsMap.values.forEach((currentAchievement){
      String achievementName = currentAchievement['AchievementName'];
      String achievementStatus = prefs.getString(achievementName) ?? '';
      if (achievementStatus == ''){
        if(achievementsSet.containsAll(currentAchievement['ItemCombo'])){
          prefs.setString(achievementName, 'Completed');
          newAchievements.add(achievementName);
          DatabaseService(uid: user.uid).updateAchievements(user.uid, achievementName);

        }
      }
    });

    return newAchievements;

  }

}