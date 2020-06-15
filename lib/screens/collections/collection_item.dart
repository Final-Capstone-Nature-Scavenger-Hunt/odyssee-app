import 'package:flutter/material.dart';

class CollectionItem extends StatefulWidget {

  final String collectionImage;
  final String collectionName;
  final String collectionDescription;

  CollectionItem({this.collectionImage, this.collectionName, this.collectionDescription});

  @override
  _CollectionItemState createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage("${widget.collectionImage}"),
              ),
            ),
            title: Text(
              widget.collectionName,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
            subtitle: Text(
              widget.collectionDescription ?? 'No Description',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 15.0,
                color: Colors.grey[400]
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}