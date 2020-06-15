import 'package:flutter/material.dart';
import 'package:odyssee/data/hunt_data.dart';
import 'package:odyssee/models/game.dart';
import 'package:provider/provider.dart';
import 'collection_item.dart';

class CollectionsList extends StatefulWidget {
  @override
  _CollectionsListState createState() => _CollectionsListState();
}

class _CollectionsListState extends State<CollectionsList> {
  @override
  Widget build(BuildContext context) {
    final userGameData = Provider.of<GameData>(context);
    final collectionsList = userGameData.foundItems.map((item) => HuntData.huntMap[item]).toList();

    return SliverPadding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20),
            sliver: SliverFixedExtentList(
            itemExtent: 80.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                String itemName = collectionsList[index]['HuntName'];
                String itemDescription = collectionsList[index]['Description'];
                String huntImage = collectionsList[index]['HuntImage'];

                return CollectionItem(collectionImage: huntImage, collectionName: itemName, 
                                        collectionDescription: itemDescription,);
              },
              childCount: collectionsList.length
            ),
          ),
        );
  }
}