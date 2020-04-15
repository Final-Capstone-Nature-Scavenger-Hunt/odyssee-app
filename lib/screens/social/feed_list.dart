import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:odyssee/data/user_images.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/screens/social/feed_item.dart';
import 'package:odyssee/shared/loading.dart';
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
                _imageContainer(post),

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
    String postImage;
    String postName = post.owner;

    if (postName.toLowerCase().contains('brian')){
      postImage = UserImages.imageLinks['brian'];
    }
    else if (postName.toLowerCase().contains('tucker')){
      postImage = UserImages.imageLinks['tucker'];
    }
    else if (postName.toLowerCase().contains('gordon')){
      postImage = UserImages.imageLinks['gordon'];
    }
    else if (postName.toLowerCase().contains('deb')){
      postImage = UserImages.imageLinks['debalina'];
    }
    else if (postName.toLowerCase().contains('tree')){
      postImage = UserImages.imageLinks['tree'];
    }
    else {
      postImage = UserImages.imageLinks['default'];
    }
    return Container(
      //constraints: BoxConstraints.tightFor(width:50),
      child: CircleAvatar(
        backgroundImage: NetworkImage(postImage) )
    );
  }

  Future _getFirebaseImageURL (String storagePath) async {
    final ref = FirebaseStorage.instance.ref().child(storagePath);
    return await ref.getDownloadURL();
  }

  Widget _imageContainer (Post post){
    return FutureBuilder(
      future: _getFirebaseImageURL(post.imagePath),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
          return Loading();
        } else if (snapshot.hasError){
          return Text('Error Loading data');
        }else if (snapshot.hasData){
          return Container(
              constraints : BoxConstraints.tightFor(height:150),
              child : Image.network(snapshot.data ,fit: BoxFit.fitWidth)
              );
        } else if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData == null){
          return Loading();
        }
        else return Container();
      }
      );
  }
}