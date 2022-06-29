// what this class does is that it stores the data of the user in this class so as tho make the code in authmethods simple to understand.
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String photourl;

  Users({
    required this.username, required this.uid,
    required this.email, required this.followers,
    required this.following, required this.bio,
    required this.photourl,
  });

  // what this does is that it converts the username to objects that stores in the firebasedatabase
  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "bio": bio,
    "followers": followers,
    "following": following,
    "photourl": photourl,
  };

  static fromSnap(DocumentSnapshot snap) {
    // this is getting the data that is stored in the FirebaseFirestore
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      // storing the data as the name indicated
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      bio: snapshot["bio"],
      photourl: snapshot["photourl"],
    );
  }

}