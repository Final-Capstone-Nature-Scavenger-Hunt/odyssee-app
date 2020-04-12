import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/database.dart';
import 'package:odyssee/shared/constants.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';


class HuntScreen extends StatefulWidget {

  final HuntItem huntItem;
  final File foundImage;


  HuntScreen({this.huntItem, this.foundImage});

  @override
  _HuntScreenState createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> {

  bool posted = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.huntItem.huntName),
        backgroundColor: Styles.appBarStyle,
        ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Constants.defaultBackgroudColor,
          border: Border.all(
            color: Colors.teal[400],
            width: 2.0
            ),
          ),
        child: Column(
          children: _renderFacts(context, widget.huntItem, user, widget.foundImage),
          ),
        ),
    );
  }

List<Widget> _renderFacts (BuildContext context, HuntItem huntItem, user, foundImage) {
  var result = List<Widget>();
  result.add(_bannerImage(huntItem.huntImage ?? Constants.huntPlaceholderImage , 180));
  result.add(_sectionTitle('Description'));
  result.add(_sectionText(huntItem.description));
  //result.add(_sectionTitle('Hint'));
  result.add(_sectionText(huntItem.hint));
  result.add(SizedBox(height: 10.0));

  if (!posted){
    result.add(_postItemButton(huntItem.huntName, foundImage, user));
  }else {
    result.add(_postedConfirmationText());
  }

  return result;
}

  Widget _sectionTitle(String text){
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
      child: Text(text,
      textAlign : TextAlign.left,
      style : TextStyle(
        color: Colors.white,
        fontSize: 25.0,
        fontFamily: 'Muli',
        fontWeight: FontWeight.bold
        )
    )
    );
  }

Widget _sectionText(String text){
  return Text(text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
            )
          );
}

Widget _bannerImage( String imageFile, double height){
  return Container(
    constraints : BoxConstraints.tightFor(height:height),
    child : Image.asset(imageFile, fit: BoxFit.fitWidth)
  );
}

Widget _postItemButton( String huntName, image, user) {

  return FlatButton(
    color: Colors.teal[400],
    child: Text('Post Finding',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20),
    ),
    onPressed: () async { 
      await DatabaseService(uid: user.uid, user: user).createPost(huntName, image);
      setState(() {
        posted = true;
      });
      }
  );
}

Widget _postedConfirmationText() {
  return FlatButton.icon(
    onPressed: (){},
    icon: Icon(Icons.check, color: Colors.white),
    label: Text(
      'Posted',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20)
      ),
    shape: new RoundedRectangleBorder(
      side: BorderSide(
            color: Colors.blue,
            width: 1,
            style: BorderStyle.solid
          ), 
      borderRadius: new BorderRadius.circular(30.0)),
  );
}
}