// what this class does is that it stores the data of the user in this class so as tho make the code in authmethods simple to understand.
import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String uid;
  final String username;
  final String postid;
  final String datePublished;
  final String profilepic;
  final String posturl;
  final likes;

  Posts({
    required this.description, required this.uid,
    required this.username, required this.postid,
    required this.datePublished, required this.posturl,
    required this.profilepic, required this.likes
  });

  // what this does is that it converts the username to objects that stores in the firebasedatabase
  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postid": postid,
    "datePublished": datePublished,
    "posturl": posturl,
    "profilepic": profilepic,
    "likes" : likes,
  };

  static fromSnap(DocumentSnapshot snap) {
    // this is getting the data that is stored in the FirebaseFirestore
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      // storing the data as the name indicated
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postid: snapshot["postid"],
      datePublished: snapshot["datePublished"],
      posturl: snapshot["posturl"],
      profilepic: snapshot["profilepic"],
      likes: snapshot["likes"]
    );
  }

}