import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/c-text.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;

  // this state is just like init state that runs once just that the message stored in the email and password field will be removed when a user starts typing in their details
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().loginUser(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
    );
    if (result != "success") {
      showSnackBar(result, context);
    }else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>  ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ),);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigatetoSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          // this is the full width of this device
          // this means that anything in this container will take up the maximum possible width
          width: double.infinity,
          child: Column(
            // this is column so cross is the opposite and anything happening will work only in the row axis
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // this flexible widget makes the other widget start from the bottom and keep coming up
              Flexible(child: Container(), flex: 2,),
              // this is where the login details will be, and they are

              //(you would also need to install flutter_svg package for svg image)
              /// SVG image
              SvgPicture.asset(
                "assets/instagramimage.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64,),

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
              /// Login Button
              InkWell(
                onTap: login,
                child: Container(
                  child: _isLoading? const Center(
                    child: CircularProgressIndicator(
                      color : primaryColor,
                    ),
                  ) :
                  const Text("Login"),
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
              Flexible(child: Container(), flex: 2,),

              //(a question like did you forget your password)
              /// Transitioning to Sign-Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigatetoSignUp,
                    child: Container(
                      child: const Text("Sign up",
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
        )
      ),
    );
  }
}
