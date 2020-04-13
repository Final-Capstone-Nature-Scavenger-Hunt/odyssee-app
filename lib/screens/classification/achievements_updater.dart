import 'package:flutter/material.dart';
import 'package:odyssee/data/achievements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsUpdater {

  Future updateFoundItem(String foundItem) async{
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
        }
      }
    });

    return newAchievements;

  }

}