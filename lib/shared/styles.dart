import 'package:flutter/material.dart';

class Styles {

  static final Color _textColorStrong = _hexToColor('000000');
  static final Color _textColorDefault = _hexToColor('666666');
  static final String _fontNameDefault = 'Muli';

  
  static Color _hexToColor( String code ) {
    return Color(int.parse(code.substring(0, 6), radix : 16) );
  }

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


  static final headerLarge = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: 25.0,
    color: _textColorStrong,
  );
}