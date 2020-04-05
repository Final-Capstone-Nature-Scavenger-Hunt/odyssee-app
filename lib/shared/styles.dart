import 'package:flutter/material.dart';

class Styles {

  static const textInputDecoration =  InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)
                    ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0)
                    ),  
                );

  static final dynamic authBackgroundDecoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/nature.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.green[400].withOpacity(0.8), BlendMode.srcOver)
          )
      );


  static final dynamic homeBackgroundDecoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/nature.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.srcOver)
          )
      );

  static dynamic appBarStyle = Colors.green[700];
}