import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// this class firebase storage is a class that is used to create folder in firebase authentication
class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Add Image to Firebase Storage
  Future<String> upLoadImagetoStorage(String childname, Uint8List? file, bool isPost) async {

    // what this is saying is that in the autentication screen in firebase, that we should create a folder if the folder isnt there
    // then inside that folder create another folder called childname, then inside that folder, create another folder using the user id
    Reference ref = _storage.ref().child(childname).child(_auth.currentUser!.uid);

    //what this is saying is that if isPOst is true, get the id for the post and then store it inside the current user id
    if(isPost == true) {
      String postid = const Uuid().v1();
      ref = ref.child(postid);
    }

    // this is to put an image file in that location
    UploadTask uploadTask =  ref.putData(file!);

    // this provides details about a storage task state
    TaskSnapshot snap = await uploadTask;

    // this is to get the download url to the file that is being uploaded, this is a future that's why we need to await it
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}