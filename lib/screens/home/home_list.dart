import 'package:flutter/material.dart';
import 'package:odyssee/screens/classification/classification.dart';
import 'package:odyssee/screens/social/feed.dart';
import 'package:odyssee/screens/social/users_to_follow.dart';
import 'package:odyssee/shared/styles.dart';



class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dynamic _height = (size.height/4);
    dynamic _width = (size.width/2.6);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: Styles.homeBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[

            //first row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                    child: Container(
                      child: Text( "Play",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0),
                      ),
                      height: _height,
                      width: _width,
                      color: Colors.teal[400],
                      alignment: Alignment.center,

                     ),
                    onTap: () =>  print("Clicked on Play"),
                    
                ),
                InkWell(
                    child: Container(
                      child: Text("My Feed",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0),
                        ),
                      height: _height,
                      width: _width,
                      color: Colors.teal[400],
                      alignment: Alignment.center,
                     ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Feed()))
                )
              ],
            ),

            // second row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                    child: Container(
                      child: Text("Classify Image",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0),                        
                        ),
                      height: _height,
                      width: _width,
                      alignment: Alignment.center,
                      color: Colors.teal[400],
                     ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClassifyImage()))
                ),
                InkWell(
                    child: Container(
                      child: Text("Search",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0),                      
                      ),
                      height: _height,
                      width: _width,
                      alignment: Alignment.center,
                      color: Colors.teal[400],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FollowUsers()))
                )
              ],
            )
          ],
          ),
      ),
    );
  }



}