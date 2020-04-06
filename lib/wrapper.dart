import 'package:flutter/material.dart';
import 'package:odyssee/screens/authenticate/authenticate.dart';
import 'package:odyssee/screens/start/start_menu.dart';
import 'package:provider/provider.dart';
import 'package:odyssee/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user != null){
      return StartMenu();
    } else {
      return Authenticate();
    }
  }
}