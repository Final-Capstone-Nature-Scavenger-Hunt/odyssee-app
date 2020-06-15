import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odyssee/models/game.dart';
import 'package:odyssee/models/hunt_item.dart';
import 'package:odyssee/models/post.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/services/storage.dart';
import 'package:path/path.dart' as p;

class DatabaseService {

  final String uid;
  final User user;

  DatabaseService({this.uid, this.user});

  Future createfollowersDocument(String displayName) async {
    final CollectionReference followersCollection = Firestore.instance.collection('followers');
    var now = DateTime.now().toString();

    return await followersCollection.document(uid).setData({
      'user': {
        'uid' : user.uid,
        'displayName' : displayName,
      },
      'last_post_timestamp': now,
      'recent_posts':[],
      'users': []
    });

  }

  Future createProfileDocument(String about) async {
    
    final CollectionReference profileCollection = Firestore.instance.collection('profiles');

    return await profileCollection.document(uid).setData({
      'about' : about
    });
    
    }

  Future createPost(String item, File image) async {

    final CollectionReference postCollection = Firestore.instance.collection('posts');
    var now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var day = now.day;
    var second = now.second;
    var hour = now.hour;
    var minute = now.minute;
    String docName = "$uid$year$month$day$hour$minute$second";
    dynamic fileName = p.basename(image.path);
    var imagePath = '$uid/images/identified/$fileName';

    Storage store = Storage(fileObject: image, uid:uid);
    await store.uploadImage();

   return await postCollection.document(docName).setData({
      'uid' : uid,
      'displayName' : user.displayName,
      'message' : "${user.displayName} has found $item",
      "item" : item,
      'timeStamp' : FieldValue.serverTimestamp(),
      'imagePath' : imagePath ?? null,
      'likers': [],
      'numLikes': 0,
      'comments': [],
      'numComments': 0
    });

  }



  List<Post> _postListFromSnapshot( QuerySnapshot snapshot){

    List<Post> postsList =[];    

    for (var d = 0; d < snapshot.documents.length; d++ ){
      DocumentSnapshot doc = snapshot.documents[d];
      var recentPosts = doc.data['recent_posts'];
      for (var p = 0; p < recentPosts.length; p++){
        dynamic recentPost = recentPosts[p];
        Post post = Post(
          owner : recentPost['displayName'] ?? "Someone",
          ownerImageLink : recentPost['imageLink'] ?? "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
          message:  recentPost['message'],
          imagePath : recentPost['imagePath'] ?? "https://react.semantic-ui.com/images/avatar/small/jenny.jpg",
          numLikes : recentPost['numLikes'] ?? 0,
          numComments : recentPost['numComments'] ?? 0
          );
        
        postsList.add(post);
      }
    }

    print('PostsList: $postsList');

    return postsList;
  }

  Stream<List<Post>> get posts {

    final CollectionReference followersCollection = Firestore.instance.collection('followers');

    return followersCollection.where('users', arrayContains: uid).snapshots()
                              .map(_postListFromSnapshot);

  }

  // get the users to Follow
    List<User> _getUserFromFollowerDoc(QuerySnapshot snapshot){

      List<User> usersList = [];
      for (var d = 0; d < snapshot.documents.length; d++){
        DocumentSnapshot doc = snapshot.documents[d];
        
        if (doc.data['user']['uid'] != uid){
            var userModel = User(
              uid: doc.data['user']['uid'],
              displayName: doc.data['user']['displayName'] ?? "Not Set",
              photoURL: doc.data['user']['photoURL'] ?? "https://react.semantic-ui.com/images/avatar/small/helen.jpg",
              actionState: doc.data['users'].contains(uid) ? 'Followed' : 'Not Followed'
            );

            usersList.add(userModel);
        }
      }

      return usersList;
  }

  Stream<List<User>> get usersList {
    final CollectionReference followers = Firestore.instance.collection('followers');
    
    return followers.snapshots().map(_getUserFromFollowerDoc);
  }

  Future updateAchievements(String uid, String achievementName){
     final CollectionReference achievementsCollection = Firestore.instance.collection('userGameData');
     return achievementsCollection.document(uid).updateData({
       'Achievements': FieldValue.arrayUnion([achievementName])
     });
  }

  Future updateGameFindings(String foundItem, double score){
    final CollectionReference achievementsCollection = Firestore.instance.collection('userGameData');
    return achievementsCollection.document(uid).updateData({
      'FoundItems': FieldValue.arrayUnion([foundItem]),
      'Score': FieldValue.increment(score)
    });
  }

  GameData _gameDataFromFirebase(DocumentSnapshot snapshot){
    
    return GameData(
      achievements: snapshot.data['Achievements'],
      score: snapshot.data['Score'],
      foundItems: snapshot.data['FoundItems'] );
  }

  // Stream<GameData> get userGameData {
  //   final DocumentReference achievementsCollection = Firestore.instance.collection('userGameData').document(uid);
  //   return achievementsCollection.snapshots().map(_gameDataFromFirebase);
  // }

  Stream<DocumentSnapshot> get userGameData {
    final DocumentReference achievementsCollection = Firestore.instance.collection('userGameData').document(uid);
    return achievementsCollection.snapshots();
  }

  Stream<GameData> get rawUserGameData {
    final DocumentReference achievementsCollection = Firestore.instance.collection('userGameData').document(uid);
    return achievementsCollection.snapshots().map(_gameDataFromFirebase);
  }
  

}