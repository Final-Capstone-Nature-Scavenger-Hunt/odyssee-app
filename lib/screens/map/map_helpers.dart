import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odyssee/models/game.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/database.dart';

class MapHelpers {
  

  static void showAlertDialog(BuildContext context, String selectedSpecies, String dropDownSelection){
    Widget confirmButton = FlatButton(
      child: Text("CONFIRM"),
      onPressed : ()  {
        selectedSpecies = dropDownSelection;
      }
    );

    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () => Navigator.of(context).pop(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Your Selection"),
        content: Text("DO you want to find the $dropDownSelection?"),
        actions: <Widget>[ confirmButton , cancelButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );

  }

  String currentZone(double elevation){
    if(elevation < 1800) return 'Unknown';
    else if (elevation >= 1800 && elevation<3000){
      return 'Foothills';
    }
    else if (elevation < 6000){
      return 'Lower Montane';
    }
    else if (elevation < 8000){
      return 'Upper Montane';
    }
    else if (elevation < 9500){
      return 'Sup-Alpine';
    }
    else if (elevation <= 13200){
      return 'Alpine';
    }
    else return 'Unknown';
  }

  Color zoneColors (String zoneName){
    switch(zoneName){
      case 'Foothills': return  Colors.green[400];

      case 'Lower Montane': return Colors.green[200];

      case 'Upper Montane': return Colors.blue[100];

      case 'Sub-Alpine': return Colors.blue[300];

      case 'Alpine': return Colors.blue[500];

      default: return Colors.blueGrey[100];
    }
  }

  Widget zoneWidget (double elevation){
    String zoneName = currentZone(elevation);
    return Positioned(
      child: InkWell(
        child: Text("Eco Zone: $zoneName",
          style: TextStyle(
            color: zoneColors(zoneName),
            backgroundColor : Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      left: 15,
      top: 30,
      height: 60,
      width: 200,
    );
  }

  Widget getCurrentScore(User user){
    //print(user.uid);
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: user.uid).userGameData,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        String score;
        //print(snapshot.data);
          if (snapshot.hasData) {
            score = snapshot.data['Score'].toString();
          }
          else {
            score = 'Loading....';
          }
          return  Positioned(
                    child: InkWell(
                      child: Text("My Score: $score",
                        style: TextStyle(
                          color: Colors.yellow[800],
                          backgroundColor : Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    left: 15,
                    top: 60,
                    height: 60,
                    width: 100,
                  );
      });
  }

  static void showNoClassSelectAlertDialog(BuildContext context){

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Species Selected!"),
        content: Text("Please selected a trail and species using the buttons below before proceeding"),
        actions: <Widget>[ okButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );

  }
  

}