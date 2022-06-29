import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// this is the layout that will be given to the webscreen

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  String username = "";

  @override
  void initState() {
    super.initState();
    // this function is called in the init state so that we can get the username of the current which is stored in the firebasefirestore
    getUsername();
  }
  // this is the function to get the username
  void getUsername() async {
    // this line of code is to get the details of the current user in the firebasefirestore
    // the collection is the collection in the firebasefirestore and the () takes in the name of the collection and the firebasefirestore.instance is is where the collection
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      // this is to store the username in the firebasefirestore as username
      username = (snap.data() as Map<String, dynamic>) ["username"];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("${username}"),),
    );
  }
}
