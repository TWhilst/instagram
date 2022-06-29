import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/utils/global_dimension.dart';
import 'package:provider/provider.dart';
// this is a responsive layout screen that changes the layout of the screen to a web screen layout whenever the screen size of the browser extends a certain width
// if it doesn't then it should display a mobile screen layout
// to confirm if this is working first go to command prompt and run cd..(this is used to go back to the previous directory)
// after that, then type in cd instagram_clone(this is used to change directory and the name after cd is the name of the directory that we are moving to)
//next thing is to type in flutter run -d chrome(this is used to run the app on the web)
class ResponsiveLayout extends StatefulWidget {
  // the responsive layout requires a webscreenlayout and a mobilescreenlayout
  // mobile screen works on android while webscreen works on the web
  // this variable stored in the class is the instruction that will be given when its in webscreen or mobile screen
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({Key? key, required this.webScreenLayout, required this.mobileScreenLayout}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    // this is used to get the data
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshUser();

  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      //in the constraints, we are only referring to the maxwidth
      // if the width is greater than the webscreensize(a value has been stored and named as webscreensize) and saved in dimension directory
      // this was done so that it would be easier to change the value because the value is going to be used in multiple places in the code
      //if constraint.maxwidth is greater than webscreensize return webscreen layout else return mobilescreen layout
      //webscreen and mobilescreen layout will be given instructions and a layout
      if(constraints.maxWidth >webScreenSize) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}




