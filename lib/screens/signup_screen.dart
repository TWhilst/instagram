import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/c-text.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  // this state is just like init state that runs once just that the message stored in the email and password field will be removed when a user starts typing in their details
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _biocontroller.dispose();
    _usernamecontroller.dispose();
  }

  void selectImage() async {
    Uint8List _im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _im;
    });
  }

  void signUpUser() async{
    // isLoading will be true if the button is clicked on
    setState(() {
      _isLoading = true;
    });
    String result  = await AuthMethods().signUpUser(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
      username: _usernamecontroller.text,
      bio: _biocontroller.text,
      file: _image,
    );

    // if result is not equal to success, it would show a snackbar and it would also isLoading would be false
    if(result != "success") {
      showSnackBar(result, context);
    }else {
      // this navigates to either the webscreen or the mobilescreen when the result is success
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
          webScreenLayout: const WebScreenLayout(),
          mobileScreenLayout: const MobileScreenLayout(),
        ),
      ),);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    // this navigates to the loginscreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                // this is column so cross is the opposite and anything happening will work only in the row axis
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // this flexible widget makes the other widget start from the bottom and keep coming up
                  // Flexible(child: Container(), flex: 2,),

                  // this is where the login details will be, and they are

                  //(you would also need to install flutter_svg package for svg image)
                  /// SVG image
                  SvgPicture.asset(
                    "assets/instagramimage.svg",
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 64,),

                  // Circular field where image will be imputed
                  Stack(
                    children: [
                      // this is a tenary operation which is checking if an image has been selected and if it has been it will show that image
                      _image != null?
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                      : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage("https://www.bing.com/th?id=OIP.VORoQXOzfnrc1yOV4anzxQHaHa&w=98&h=100&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2"),
                      ),
                      // this positioned widget carries a child property that collects any widget
                      // this also positions whatever widget it carries
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24,),

                  // text field imput for username
                  CTextField(
                    textEditingController: _usernamecontroller,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 24,),

                  /// Text Field imput for email
                  CTextField(
                    textEditingController: _emailcontroller,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24,),

                  /// Text Field imput for password
                  CTextField(
                    textEditingController: _passwordcontroller,
                    hintText: "Enter your password",
                    textInputType: TextInputType.text,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24,),

                  // text field imput for username
                  CTextField(
                    textEditingController: _biocontroller,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 24,),

                  /// Sign Up Button
                  InkWell(
                    // signUpUser is a void function that signs up the user
                    onTap: signUpUser,
                    child: Container(
                      child: _isLoading? const Center(
                        // this is to show a loading screen on the inkwell button if the button is clicked on,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),) :
                      const Text("Sign Up"),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration:  ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: Colors.blue
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  // Flexible(child: Container(), flex: 2,),

                  //(a question like did you forget your password)
                  /// Transitioning to Sign-Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        // navigateToLogin is a void function that navigates to login
                        onTap: navigateToLogin,
                        child: Container(
                          child: const Text("Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
