import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

// this provider is a state management solution used instead of setState which is used to get the details from the FirebaseFirestore and use them on both the webscreen and mobilescreen
// we could also use extends
class UserProvider with ChangeNotifier {
  Users? _users;
  final AuthMethods _authMethods = AuthMethods();

  Users get getUser => _users!;

  Future<void> refreshUser() async {
    Users user = await _authMethods.getUserDetails();
    _users = user;
    // this will notify all the listeners to the user providers that the data _users value of Users has changed
    notifyListeners();
  }

}