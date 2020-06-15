import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:odyssee/data/user_images.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/shared/loading.dart';
import 'package:odyssee/shared/styles.dart';


class FeedItem extends StatefulWidget {

  final post;

  FeedItem({this.post});
  
  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              child: CircleAvatar(
                backgroundImage: _itemThumbNail(widget.post)
              )
            ),
            title: Text(
              widget.post.postName,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
          ),
          Center(
            child: _imageContainer(widget.post),
          ),
          displayButtons()
        ]
      ),
      );
  }

  // OverlayEntry createPictureOverlay(){
  //   return OverlayEntry(
  //     builder: (BuildContext context){
  //       return Container(
  //         height: 300,
  //         //width: 150
  //         margin: EdgeInsets.only( bottom: 20.0),
  //         decoration: BoxDecoration(
  //         ),
  //         child: Image.network('assets/rep_images/${widget.post.postImage}', 
  //         fit: BoxFit.fitHeight,
  //               )
  //       );
  //     }
  //   );
  // }

  Widget displayButtons(){
    return ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.thumb_up),
              onPressed: () { /* ... */ },
            ),
            FlatButton(
              child: Text('COMMENT',
                style: Styles.defaultTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
                )
              ),
              onPressed: () { /* ... */ },
            ),
            FlatButton(
              child: Text('REPOST',
                style: Styles.defaultTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
                )
              ),
              onPressed: () { /* ... */ },
            ),
          ]
        );
  }

  ImageProvider _itemThumbNail(Post post){
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
    return NetworkImage(postImage);
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
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.only( bottom:20.0),
                  decoration: BoxDecoration(
                  ),
                  child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Image.network('${post.imagePath}', 
                          fit: BoxFit.fitHeight,
                        ),
                  )
                );
        } else if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData == null){
          return Loading();
        }
        else return Container();
      }
      );
  } 
}