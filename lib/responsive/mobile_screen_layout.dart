import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_dimension.dart';

// this is the layout that will be given to the mobilescreen
class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // late keyword is a way of telling the dart compiler that the variable will be initialized later on
  late PageController pageController;
  int _page = 0;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void iconTapped (int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    // // this is what is called in either the webscreen or the mobile screen to use the provider
    // Users user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      // user. username is where the value of the current user is stored
      body: PageView(
        // the children are the buttom navigation bar item that is followed as it is arranged in index form
        // this stops the page from moving left to right just by swiping the screen
        physics: NeverScrollableScrollPhysics(),

        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      // we could also use bottom navigation bar widgets. cupertino is used for iphone
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          // the buttom navigation bar item is used to imput icons on the buttom navigation bar
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _page == 0? primaryColor : secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _page == 1? primaryColor : secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: _page == 2? primaryColor : secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _page == 3? primaryColor : secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _page == 4? primaryColor : secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
        ],
        onTap: iconTapped,
      ),
    );
  }
}
