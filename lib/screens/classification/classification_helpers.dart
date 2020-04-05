import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/database.dart';

class ClassificationHelpers {

  
  
  void confirmClassification(BuildContext context, User user, recogntions, String predictedClass, bool findStatus, File image) {
    var predictions = recogntions.map((res) => res["label"]).toList();
    findStatus = predictions.contains(predictedClass);
    showAlertDialog(context, user, predictedClass, image, findStatus);
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