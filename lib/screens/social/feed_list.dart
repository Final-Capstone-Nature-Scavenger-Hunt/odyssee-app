import 'package:flutter/material.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/screens/social/feed_item.dart';
import 'package:provider/provider.dart';


class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index){
          Post post = posts[index];

          return FeedItem(post: post);
          }
    );
  }

}

