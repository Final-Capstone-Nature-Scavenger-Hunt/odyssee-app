import 'dart:io';
import 'package:flutter/material.dart';
import 'package:odyssee/mocks/hunt_data.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/classification/hunt_screen.dart';
import 'package:odyssee/services/database.dart';

class ClassificationHelpers {

  
  
  void confirmClassification(BuildContext context, User user, recogntions, String predictedClass, bool findStatus, File image) {
    var predictions = recogntions.map((res) => res["label"].toLowerCase()).toList();
    findStatus = predictions.contains(predictedClass.toLowerCase());
    Map huntMapItem = HuntData.huntMap[predictedClass];
    HuntItem huntItem = HuntItem(
                                huntName: huntMapItem['HuntName'], description: huntMapItem['Description'], 
                                hint: huntMapItem['Hints']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HuntScreen(huntItem : huntItem)));
    //showAlertDialog(context, user, predictedClass, image, findStatus);
  }
  

  void showAlertDialog(BuildContext context, User user, String predictedClass, File image, bool findStatus){
    Widget postButton = FlatButton(
      child: Text("Post Update"),
      onPressed : () async {
        await DatabaseService(uid: user.uid, user: user).createPost(predictedClass, image);
        Navigator.of(context).pop();
      }
    );

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    String dialogContent = findStatus ? "Congratulations! You have found a $predictedClass" 
                                      : "Sorry this is not a $predictedClass";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Finding"),
        content: Text(dialogContent),
        actions: <Widget>[ findStatus ? postButton: null , okButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );

  }

}