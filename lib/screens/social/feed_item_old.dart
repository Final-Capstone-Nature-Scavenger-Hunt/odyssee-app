import 'package:flutter/material.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/shared/styles.dart';

class FeedItem extends StatelessWidget {

  Post post;

  FeedItem({this.post});
  
  @override
  Widget build(BuildContext context) {
  
  final Widget imageContainer = post.imagePath == null ? SizedBox(height: 1.0,) : Container(
  constraints : BoxConstraints.tightFor(height:100),
  child : Image.network(post.imagePath ,fit: BoxFit.fitWidth)
  );

  return Scaffold(
    appBar: AppBar(
      title: Text('Post'),
      backgroundColor: Styles.appBarStyle,
      ),
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child:Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: _itemThumbNail(post),
              title: Text(
                post.owner,
                style: TextStyle(fontWeight: FontWeight.bold)
                ),
              subtitle: Text(
                post.message,
                style: TextStyle(
                  color: Colors.grey[600] 
                )
              ),
            ),

            imageContainer,

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
                  child: Text('REPOST'),
                  onPressed: () { /* ... */ },
                ),
              ]
            ),

            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('${post.numLikes} Likes'),
                  onPressed: (){ /* ... */ },
                  ),
                FlatButton(
                  child: Text('${post.numComments} Coments'),
                  onPressed: (){ /* ... */ },
                  )
              ],
            )
          ],
        ),
      )
    ),
  );
  }

  Widget _itemThumbNail(Post post){
    return Container(
      child: CircleAvatar(
        backgroundImage: NetworkImage(post.ownerImageLink) )
    );
  }

}