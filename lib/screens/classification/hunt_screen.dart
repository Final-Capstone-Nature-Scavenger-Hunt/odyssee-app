import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/data/achievements.dart';
import 'package:odyssee/screens/classification/achievements_updater.dart';
import 'package:odyssee/services/database.dart';
import 'package:odyssee/shared/constants.dart';
import 'package:odyssee/shared/loading.dart';
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
  bool postingIO = false;
  List<String> newAchievements;
  OverlayEntry _overlayEntry;


  void initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => displayOverlay(context));
  }

  Future getAchievements(User user) async {
    print ('got achievements');
    List<String> achievementsList = await AchievementsUpdater().updateFoundItem(widget.huntItem.huntName, user);

    setState(() {
      newAchievements = achievementsList;
      // newAchievements = ['Miwok Home Maker'];
      _overlayEntry = newAchievements.isNotEmpty ? createOverlay(newAchievements[0]) : null;
    });
  }


  Widget _pictureIcon(String assetPath, {height, width}){
    return Image.asset(assetPath, height: height,);
  }

  void displayOverlay(BuildContext context) async {
    final user = Provider.of<User>(context);
    await getAchievements(user);
    print(_overlayEntry != null);
    if (_overlayEntry != null){
      print('overlaying content');
      Overlay.of(context).insert(_overlayEntry);
    }
  }
  
  OverlayEntry createOverlay(achievementName){ 
    print("running...");
    Map achievement = Achievements.achievementsMap[achievementName];
    return OverlayEntry(
    builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Material(
              type: MaterialType.transparency,
              child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.appBarStyle,
                  border: Border.all(color: Colors.brown, width: 3.0)),
                margin: EdgeInsets.symmetric(horizontal:30.0, vertical: 100),
                padding: EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Text("Achievement Unlocked!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                    Divider(color: Colors.white24,),
                    Container(
                      margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Text("${achievement['AchievementName']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                    _pictureIcon(achievement['Image'], height: 150.0),
                    SizedBox(height: 10.0),
                    SizedBox(height: 10.0),
                    Divider(color: Colors.white24, indent:10.0, endIndent: 10.0,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(achievement['AchievementText'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                      ),
                      ),
                    )
                  ],
                ),
                ),
              ),
            ),
            onTap: () => _overlayEntry?.remove(),
          )
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

return Scaffold(
      backgroundColor: Colors.brown[100], //Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:15.0, left: 10.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(widget.huntItem.huntName,
                  style: Styles.defaultPageTitle
                )
              ]
            )
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.huntItem.huntImage)
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:15.0, left:20.0, right: 20.0),
            child: Container(
              height: 150,
              padding: EdgeInsets.only(top:10.0),
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0
                  )
                ]
              ),
              child: ListView(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: createDescription(widget.huntItem.description)
                    ),
                    SizedBox(height: 5.0),
                  ],
                  )
                ],
              )
            )
          ),
          SizedBox(height: 5.0),
          Divider( 
            color: Colors.grey, 
            thickness: 1.0, 
            indent: 10.0,
            endIndent: 10.0,),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _addHuntDetails(widget.huntItem),
          ),
          SizedBox(height: 10.0),
          Center(
            child: _postItemButton(widget.huntItem.huntName, widget.foundImage, user),
          )
        ]
      )
    );
  }


List<Widget> _addHuntDetails(HuntItem huntItem){
  List<Widget> rowChildren = [];

  // rowChildren.add(
  //   detailsIcon('Rarity Score', value: huntItem.rarityScore.toString())
  // );

  if (huntItem.carbonHungry==1.0){
    rowChildren.add(detailsIcon("Carbon Hungry"));
  }
  if (huntItem.endemic==1.0){
    rowChildren.add(detailsIcon("Endemic"));
  }
  if (huntItem.decomposer==1.0){
    rowChildren.add(detailsIcon("Decomposer"));
  }
  if (huntItem.predator==1.0){
    rowChildren.add(detailsIcon("Predator"));
  }
  if (huntItem.scavenger==1.0){
    rowChildren.add(detailsIcon("Scavenger"));
  }
  return rowChildren;
}

  Widget detailsIcon(String detailText){
    return createPropertyBanner( detailText, Icons.battery_alert);
  }

  Widget _postItemButton( String huntName, image, user) {

    Widget buttonText;

    if (posted) {
      buttonText = Text('Posted',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                    )
                  );
    }
    else if (!posted && !postingIO){
      buttonText = Text('Share Finding',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                    )
                  );
    }
    else buttonText = BareLoading();

    return RaisedButton(
                color: Colors.teal,
                onPressed: () async { 
                  setState(() {
                    postingIO = true;
                  });
                  var postResult = await DatabaseService(uid: user.uid, user: user).createPost(huntName, image);
                  setState(() {
                    posted = true;
                  });
                  },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: buttonText,
              );
  }


  Widget createDescription(String description){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical:10.0),
          child: Icon(Icons.info_outline, size: 40.0),
        ),
        Expanded(
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:10.0),
            child: Text(description,
              style: Styles.defaultTextStyle.copyWith(
                fontSize: 16.0
              ),
            )
          ),
        )
      ]
    );
  }

  Widget createPropertyBanner(String property, icon){
    return Container(
      height: 80.0,
      width: 80.0,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
          style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 40.0),
          Text(property.toUpperCase(),
            style: Styles.defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

}