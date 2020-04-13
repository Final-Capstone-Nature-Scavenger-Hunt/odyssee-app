import 'package:flutter/material.dart';
import 'package:odyssee/shared/header_nav.dart';

class Achievements extends StatelessWidget {
  static var achievementsMap;

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: BaseAppBar(
        title: Text('Achievements'),
        appBar: AppBar(),
      ),
      drawer: BaseDrawer(),
      body: new Text("Achievements Page"),
    );
  }
}