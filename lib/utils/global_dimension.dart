import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(), // index  0
  Center(child: Text("Search")), // index  1
  AddPost(), // index  2
  Center(child: Text("Info")),// index  3
  Center(child: Text("Profile")), // index  4
];