import 'package:flutter/material.dart';
import 'package:odyssee/shared/header_nav.dart';

class Collection extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: BaseAppBar(
        title: Text('Collection'),
        appBar: AppBar(),
      ),
      drawer: BaseDrawer(),
      body: new Text("Collections Page"),
    );
  }
}