import 'package:flutter/material.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/auth.dart';
import 'package:odyssee/screens/splash/splash.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
          value: AuthService().user,
          child: MaterialApp(
        home: Splash()
        ),
    );
  }
}
