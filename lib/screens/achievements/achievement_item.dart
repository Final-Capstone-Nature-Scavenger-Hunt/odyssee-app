import 'package:flutter/material.dart';

class AchievementItem extends StatefulWidget {

  final String achievementImage;
  final String achievementName;
  final String achievementDescription;

  AchievementItem({this.achievementImage, this.achievementName, this.achievementDescription});

  @override
  _AchievementItemState createState() => _AchievementItemState();
}

class _AchievementItemState extends State<AchievementItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage("${widget.achievementImage}"),
              ),
            ),
            title: Text(
              widget.achievementName,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
            subtitle: Text(
              widget.achievementDescription ?? 'No Description',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 15.0,
                color: Colors.grey[400]
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}