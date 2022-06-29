import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

// this class is to make sure that whenever a user clicks on the sign up button, it would create/store the users details in firebase authentication tab and also on the firebase database.
class AuthMethods {
  // FirebaseAuth is a class that is provided by firebase_auth, the package that we added in our directory
  // _auth is where the data is stored _ is to make sure that auth can only be accessed in this page
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseFirestore is a class that is provided by cloud_firestore, the package that we added in our directory
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // this is where the user details is collected
  ///User Details
  Future<Users> getUserDetails () async {
    User currentusers = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection("users").doc(currentusers.uid).get();
    return Users.fromSnap(snap);
  }

  /// Sign up User
  // this is a function that takes in the user information and stores them in the firebase database
  Future<String> signUpUser({
    // this are the users information stored in parameters and is going to be saved in the firebase
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String? res = "Some error occured";
    // this try function is used to check if there is an error in the function signUpUser
    try{
      // this if statement is to check if the parameters above are not null or empty
      // what this is trying to say is that if all this parameters are not empty or equal to null, register the user
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty ){
        /// Register the User
        // this is used just to store the user's email and password in the firebase autentication tab
        // the createUserWithEmailAndPassword is of a type UserCrediential and that's it is being used as a variable for
        // the class UserCredential saves the data that is being awaited from _auth.createUserWithEmailAndPassword and then stores it in cred
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        // this uid is the user identifation no that is used to identify a particular user
        // print(cred.user!.uid);

        /// Stored Image Link
        String photourl = await StorageMethods().upLoadImagetoStorage("ProfilePics", file, false);

        Users user = Users(
          username: username,
          uid: cred.user!.uid,
          email: email,
          followers: [],
          following: [],
          bio: bio,
          photourl: photourl,
        );

        /// Add User to the Firebase Database
        // what this literally does is that in the firestore it creates a collection named user if it doesn't already exists and it creates a document (cred.user!.uid) if it's not already there
        // if the data is already then, it would then override the existing data and store the new data
        // this method is preferred than the one below because in this method, the uid from the authentication in the firebase will be set as the uid of the firebase firecloud
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());

        // this method isn't preferred than the one below because in this method, the uid from the authentication in the firebase won't be set as the uid of the firebase firecloud which means that there will be two different link
        // await _firestore.collection("users").add({
        //   "username": username,
        //   "email": email,
        //   "bio": bio,
        //   "followers": [],
        //   "following": [],
        // });

        // this is to confirm that the code went smoothly
        res = "success";
      }
    }
    // // FirebaseAuthException is the class that has the error displayed when the imput details on the signup or login page isn't correct
    // on FirebaseAuthException catch(err) {
    //   // the invalid email is the error code, with this you can change the error code that is being displayed
    //   if (err.code == "invalid-email") {
    //     res = "The email address is badly formatted.";
    //   } else if (err.code == "weak-password") {
    //     res = "Password should be at least 6 characters.";
    //   }
    // }
    //this catch function works hand in hand with the try function, any error caught in the try function would be saved in the variable named e
    // the string variable res then collect the error and stores it in the variable string
    // this is to say that the code didn't go as planned
     catch (e) {
       res =e.toString();
     }
    // result has to be returned
    return res;
  }

  /// logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try{
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }

    catch (e) {
      res = e.toString();
    }
    return res;
  }


}