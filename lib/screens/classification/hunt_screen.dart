import 'package:flutter/material.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/shared/constants.dart';
import 'package:odyssee/shared/styles.dart';


class HuntScreen extends StatelessWidget {

  final HuntItem huntItem;


  HuntScreen({this.huntItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(huntItem.huntName),
        backgroundColor: Styles.appBarStyle,
        ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.teal[400],
            width: 2.0
            ),
          ),
        child: Column(
          children: _renderFacts(context, huntItem),
          ),
        ),
    );
  }

List<Widget> _renderFacts (BuildContext context, HuntItem huntItem) {
  var result = List<Widget>();
  result.add(_bannerImage(huntItem.huntImage ?? Constants.huntPlaceholderImage , 150));
  result.add(_sectionTitle('Description'));
  result.add(_sectionText(huntItem.description));
  result.add(_sectionTitle('Hint'));
  result.add(_sectionText(huntItem.hint));

  return result;
}

  Widget _sectionTitle(String text){
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
      child: Text(text,
      textAlign : TextAlign.left,
      style : TextStyle(
        color: Colors.grey[600],
        fontSize: 25.0,
        fontFamily: 'Muli',
        fontWeight: FontWeight.bold
        )
    )
    );
  }

Widget _sectionText(String text){
  return Text(text);
}


Widget _bannerImage( String url, double height){
  return Container(
    constraints : BoxConstraints.tightFor(height:height),
    child : Image.network(url, fit: BoxFit.fitWidth)
  );
}

}