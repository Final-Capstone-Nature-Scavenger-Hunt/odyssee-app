import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odyssee/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odyssee/services/database.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user object based on FirebaseUser
  User _userFromFirebase(FirebaseUser user){
    return user != null ? User(uid: user.uid, displayName: user.displayName, photoURL: user.photoUrl) : null;
  }

  // auth change user stream

  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebase(user));
    .map(_userFromFirebase);
  }

  // sign in anon
  Future signInAnon() async {

    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String displayName) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      const about = "We are all humans at the end of it all";

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = displayName;

      await user.updateProfile(updateInfo);

      User customUser = _userFromFirebase(user);

      // create a new document for the user with the uid
      DatabaseService dbservice =  DatabaseService( uid : user.uid, user : customUser);

      // create a followers document
      await dbservice.createfollowersDocument(displayName);

      // create a profile document
      //await dbservice.createProfileDocument(about);
      
      //await DatabaseService(uid : user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebase(user);
    } catch(e){
      //print(e.toString());
      print(e.message);
      return null;
    }
  }

  Future addProfileData () async {

  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}