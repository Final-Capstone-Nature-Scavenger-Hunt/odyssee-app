import 'package:odyssee/models/post.dart';

class MockPost {
  static final List<Post> items = [
    Post(
      owner: "Brian Musisi",
      ownerImageLink: "https://react.semantic-ui.com/images/avatar/small/helen.jpg",
      message: "I just found an antelope in Queen Elizabeth NP",
      imagePath: null,
      postTime: "2019-03-16",
      numLikes: 4,
      numComments: 6
    ),
    Post(
      owner: "Debalina Maiti",
      ownerImageLink: "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
      message: "Yosemite is a really great place",
      imagePath: "https://resize.hswstatic.com/w_907/gif/lion.jpg",
      postTime: "2019-03-16",
      numLikes: 10,
      numComments: 3
    ),
    Post(
      owner: "Tucker Anderson",
      ownerImageLink: "https://react.semantic-ui.com/images/avatar/small/justen.jpg",
      message: "What an amaing app and a great experience",
      imagePath: null,
      postTime: "2019-03-16",
      numLikes: 6,
      numComments: 40
    ),
    Post(
      owner: "Gordon Jack",
      ownerImageLink: "https://react.semantic-ui.com/images/avatar/small/justen.jpg",
      message: "OdySee is such a great app",
      imagePath: null,
      postTime: "2019-03-16",
      numLikes: 14,
      numComments: 5,
    )
  ];
}