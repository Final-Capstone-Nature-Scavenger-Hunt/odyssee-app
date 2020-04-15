import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/data/achievements.dart';
import 'package:odyssee/screens/classification/achievements_updater.dart';
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
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            backgroundColor: Styles.appBarStyle,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(widget.huntItem.huntImage, fit: BoxFit.cover),
              title: Text(widget.huntItem.huntName),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal:10.0, vertical: 5.0),
              padding: EdgeInsets.symmetric(horizontal:10.0, vertical: 2.0),
              decoration: BoxDecoration(
                //border: Border.all(color: Styles.appBarStyle),
                boxShadow: [
                      BoxShadow(
                        color: Colors.brown,
                        blurRadius: 1.0,
                      ),
                    ]
                ),
              child: Column(
                children: _renderFacts(context, widget.huntItem, user, widget.foundImage),
              ),
            ),
          )
        ],
      ),
      );
  }

List<Widget> _renderFacts (BuildContext context, HuntItem huntItem, user, foundImage) {
  var result = List<Widget>();
  //result.add(_bannerImage(huntItem.huntImage ?? Constants.huntPlaceholderImage , 180));
  result.add(_sectionTitle('Description'));
  result.add(Divider(color: Colors.white24));
  result.add(_sectionText(huntItem.description));
  //result.add(_sectionTitle('Hint'));
  result.add(_sectionText(huntItem.hint));
  result.add(SizedBox(height: 20.0));
  result.add(_addHuntDetails(huntItem));
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
            fontSize: 18.0,
            )
          );
}

Widget _bannerImage( String imageFile, double height){
  return Container(
    constraints : BoxConstraints.tightFor(height:height),
    child : Image.asset(imageFile, fit: BoxFit.fitWidth)
  );
}

Widget _addHuntDetails(HuntItem huntItem){
  List<Widget> rowChildren = [];

  rowChildren.add(
    detailsIcon('Rarity Score', value: huntItem.rarityScore.toString())
  );

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
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rowChildren,
    ),
  );
}

Widget detailsIcon(String detailText, {String value ="Yes"}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal:1.0),
    decoration: BoxDecoration(
      color: detailColor(detailText),
      border: Border.all(
      color: detailColor(detailText),
    ),
    borderRadius: BorderRadius.all(Radius.circular(20))
  
    ),
    child: Text("$detailText: $value",
      style: TextStyle(
        //backgroundColor: detailColor(detailText),
        fontSize: 14.0,
        color: Colors.white,
        fontWeight: FontWeight.bold
        ),
    ),
  );
}

Color detailColor(String detailText){
  switch (detailText){
    case 'Carbon Hungry': return Colors.black;
    case 'Endemic': return Colors.green;
    case 'Decomposer': return Colors.brown;
    case 'Predator': return Colors.red[400];
    case 'Scavenger': return Colors.grey;
    case 'Rarity Score': return Colors.yellow[800];
    default: return Colors.blue;
  }
}

Widget _postItemButton( String huntName, image, user) {

  return FlatButton.icon(
    color: Styles.buttonColor,
    icon: Icon(Icons.share, color: Colors.white,),
    label: Text('Share Finding',
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