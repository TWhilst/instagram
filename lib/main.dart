import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// this code is used to initialize the firebase app
// check pubspec.yaml for more details
Future main() async {
  // this makes sure that the flutter widgets has been initialised
  WidgetsFlutterBinding.ensureInitialized();
  // if property is needed because we want to use web and at the same time use android
  // by web i mean for it to work on website and also on android
  if(kIsWeb){
    await Firebase.initializeApp(
      // this property is needed to imput what is needed for the web app
      // this const property is needed so that when loading the app, the app won't bother loading because the value won't change
      options: const FirebaseOptions(
          apiKey: "AIzaSyCvTR0GcKEZFLkyjJizqFbC4pq9fYYrlF0",
          appId: "1:65070687010:web:8d3f52f783169ac66f7b7b",
          messagingSenderId: "65070687010",
          projectId: "instagram-clone-24cee",
          // we want to use firebase storage so this property helps us to do that
          storageBucket: "instagram-clone-24cee.appspot.com"
      ),
    );
  }else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // this is also where you add listeners
    // this multiprovider is used because this app will take on a lot of providers
    return MultiProvider(
      providers: [
        // this provides a way that you can instantiate the class that extends change notifier
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        // the red banner will not show up using this code
        debugShowCheckedModeBanner: false,
          //this copyWith is used to change the current background color
          // ThemeData.dark is the background color saved in flutter
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // StreamBuilder is a firebase widget that checks the condition necessary for a successful login
        // like if the user data is in firebase or if it has an error or if the connection is loading
        home: StreamBuilder(
          // stream: FirebaseAuth.instance.idTokenChanges(),
          // stream: FirebaseAuth.instance.userChanges(),
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.active) {
              // snapshot.hasData means that the user has been autenticated
              if(snapshot.hasData) {
                return  ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              }else if(snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor
                ),
              );
            }

            return const LoginScreen();
          }
        ),
      ),
    );
  }
}

