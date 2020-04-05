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
      itemBuilder: (BuildContext context, int index){

    var post = posts[index];

    final Widget imageContainer = post.imagePath == null ? SizedBox(height: 1.0,) : Container(
              constraints : BoxConstraints.tightFor(height:100),
              child : Image.network(post.imagePath ,fit: BoxFit.fitWidth)
              );

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: _itemThumbNail(post),
            title: Text(
              post.owner,
              style: TextStyle(fontWeight: FontWeight.bold)
              ),
            subtitle: Column(
              children: <Widget>[
                SizedBox(height: 2.0,),
                Text(
                  post.message,
                  style: TextStyle(
                    color: Colors.grey[600] 
                  )
                ),
                SizedBox(height: 10.0,),
                imageContainer,

              ],
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => navigationToFeedItem(context, post),
          ),

          

          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.thumb_up),
                onPressed: () { /* ... */ },
              ),
              FlatButton(
                child: Text('COMMENT'),
                onPressed: () { /* ... */ },
              ),
              FlatButton(
                child: Icon(Icons.repeat),
                onPressed: () { /* ... */ },
              ),
            ]
          )
        ],
      ),
    );
  }//_listItemViewBuilder,
      // separatorBuilder: (context, index) {
      //     return Divider();
      //   },
    );
  }

  void navigationToFeedItem(BuildContext context, Post post){
    Navigator.push(context, MaterialPageRoute(
                  builder: (context) => 
                    FeedItem(post : post))
                  );
  }

  Widget _itemThumbNail(Post post){
    return Container(
      //constraints: BoxConstraints.tightFor(width:50),
      child: CircleAvatar(
        backgroundImage: NetworkImage(post.ownerImageLink) )
    );
  }
}