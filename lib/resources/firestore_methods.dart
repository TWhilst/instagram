import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/posts.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadImage (
      String description,
      String uid,
      String username,
      Uint8List file,
      String profilepic

  ) async {
    String res = "Some error occured";
    try {
      String posturl = await StorageMethods().upLoadImagetoStorage("Posts", file, true);

      // Uuid is a flutter package that is used to generate unique identification no for the post
      String postid = const Uuid().v1();

      // this is where the info of the post will be stored and it will move to the storage of firebase
      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postid: postid,
        datePublished: DateTime.now().toString(),
        posturl: posturl,
        profilepic: profilepic,
        likes: [],
      );

      // set is used to store the post details to the firebase firestore
      //save to firebasefirestore
      _firebaseFirestore.collection("Posts").doc(postid).set(post.toJson());

      res = "success";
    }

    catch (err) {
      res = err.toString();
    }

    return res;

  }

  Future<void> likePost(String uid, List likes, String postid) async {

    try {
      if(likes.contains(uid)) {
        await _firebaseFirestore.collection("Posts").doc(postid).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection("Posts").doc(postid).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }

    }

    catch (e) {
      print(e.toString(),);
    }
  }

}