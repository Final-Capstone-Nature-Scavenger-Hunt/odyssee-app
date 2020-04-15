import 'package:flutter/material.dart';
import 'package:odyssee/data/user_images.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/achievements/achievements.dart';
import 'package:odyssee/screens/collection/collection.dart';
import 'package:odyssee/screens/authenticate/authenticate.dart';
import 'package:odyssee/screens/social/feed.dart';
import 'package:odyssee/screens/social/users_to_follow.dart';
import 'package:odyssee/screens/start/start_menu.dart';
import 'package:odyssee/services/auth.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Text title;
  final AppBar appBar;

  const BaseAppBar({Key key, this.title, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () { Scaffold.of(context).openDrawer(); },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: title,
      centerTitle: true,
      backgroundColor: Color(0xFF194000),
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Color(0xFFE86935),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class BaseDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    String userImage;
    String postName = user.displayName;

    if (postName.toLowerCase().contains('brian')){
      userImage = UserImages.imageLinks['brian'];
    }
    else if (postName.toLowerCase().contains('tucker')){
      userImage = UserImages.imageLinks['tucker'];
    }
    else if (postName.toLowerCase().contains('gordon')){
      userImage = UserImages.imageLinks['gordon'];
    }
    else if (postName.toLowerCase().contains('deb')){
      userImage = UserImages.imageLinks['debalina'];
    }
    else if (postName.toLowerCase().contains('tree')){
      userImage = UserImages.imageLinks['tree'];
    }
    else {
      userImage = UserImages.imageLinks['default'];
    }
    
    return Drawer(
      elevation: 15.0,
      child: Container(color: Color(0xDD194000),
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName,
              style: TextStyle(
                color: Color(0xFFE5D9A5),
                fontSize: 25,
              ),
            ),
            accountEmail: Text(""),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/drawer_background.jpg"), fit: BoxFit.cover)
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userImage)
              //backgroundColor: Color(0xFFE5D9A5),
//                    child: Text(
//                      'Account Placeholder',
//                      style: TextStyle(
//                        color: Color(0xFFE5D9A5),
//                        fontSize: 30,
//                      ),
//                    ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.library_books,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('My Feed',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Feed()),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.group,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('Follow',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FollowUsers()),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.collections,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('Captured Species',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Collection()),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.flag,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('Achievements',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Achievements()),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('Back to Main Menu',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartMenu()),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
//                top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE86935)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.account_circle,
                  size: 32,
                  color: Color(0xFFE5D9A5)
              ),
              title: Text('Sign Out',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE5D9A5)
                ),
              ),
              onTap: () async => AuthService().signOut(),
            ),
          ),
          ],
        ),
      ),
    );
  }
}