import 'package:odyssee/models/user.dart';

class MockUser {
  static final List<User> userList = [
    User(
      uid: '123434354634232345',
      displayName: 'Debalina Maiti',
      photoURL: "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
      actionState: 'Followed'
    ),
    User(
      uid: 'f3ht434354634232345',
      displayName: 'Gordon Jack',
      photoURL: "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
      actionState: 'Not Followed'
    ),
    User(
      uid: '54mgi903mrmgngkr',
      displayName: 'Tucker Anderson',
      photoURL: "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
      actionState: 'Not Followed'
    )

  ];
}