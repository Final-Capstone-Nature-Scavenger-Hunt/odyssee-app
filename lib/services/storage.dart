import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class Storage{

  String uid;
  File fileObject;

  Storage({this.fileObject, this.uid});
  
  

  FirebaseStorage _store = FirebaseStorage();

  // upload image

  Future<void> uploadImage() async {
    
    dynamic fileName = p.basename(fileObject.path);
    dynamic storageReference = _store.ref().child("$uid/images/identified/$fileName");
    final StorageUploadTask uploadTask = storageReference.putFile(fileObject);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    print("The URL is $url");
  }




}