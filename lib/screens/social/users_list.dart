import 'package:flutter/material.dart';
import 'package:odyssee/data/user_images.dart';
import 'package:odyssee/mocks/mock_users.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/functions.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {

  //final users = MockUser.userList;

  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context) ?? [];

    return  ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index){

            var user = users[index];

            dynamic followButton = user.actionState == "Followed" ?  FlatButton(
                        child: Text(
                          user.actionState == "Followed" ? 'Following': 'Follow',
                          style: TextStyle(color: user.actionState == "Followed" ? Colors.white : Colors.green[400]),
                        ),
                        onPressed: () => FunctionService().followUser('unfollow', user.uid),
                        color: user.actionState == "Followed" ? Colors.green[400]: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      ) 
                      : OutlineButton(
                        child: Text(
                          user.actionState == "Followed" ? 'Following': 'Follow',
                          style: TextStyle(color: user.actionState == "Followed" ? Colors.white : Colors.green[400]),
                        ),
                        onPressed: () => FunctionService().followUser('follow', user.uid),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.green[400]),
                      );


            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: _itemThumbNail(user),
                    title: Text(
                      user.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    subtitle: Text(
                          "I love to go to the Park",
                          style: TextStyle(
                            color: Colors.grey[600] 
                          )
                        ),
                  ),


                  ButtonBar(
                    children: <Widget>[
                      followButton,

                    ]
                  )
                ],
              ),
            );
          }
            );
  }

  void followUser(User user){
    print("Following: User {$user.displayName}");
  }

  Widget _itemThumbNail(User user){
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
    return Container(
      //constraints: BoxConstraints.tightFor(width:50),
      child: CircleAvatar(
        backgroundImage: NetworkImage(userImage) )
    );
  }

}