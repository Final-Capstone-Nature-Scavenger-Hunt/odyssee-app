import 'package:odyssee/models/post.dart';

class Followers {
  String uid;
  String lastPostTimestamp;
  List<Post> recentPosts;

  Followers({this.uid, this.lastPostTimestamp, this.recentPosts});

}