import 'package:chat_app/src/features/auth/controller/signin_controller.dart';
import 'package:chat_app/src/features/auth/signup.dart';
import 'package:chat_app/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  var height, width;

  signin() async {
    final provider = Provider.of<SigninController>(context, listen: false);
    bool success = await provider.signIn(
      emailcontroller.text.trim(),
      passwordcontroller.text.trim(),
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final istrue = Provider.of<SigninController>(context).isLoading;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.1, left: width * 0.4),
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: height * 0.15,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.3, left: width * 0.15),
              child: Text(
                "Signin",
                style: TextStyle(
                    color: Color.fromARGB(255, 151, 71, 255),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              margin: EdgeInsets.only(top: height * 0.4, left: width * 0.15),
              height: height * 0.07,
              width: width * 0.7,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailcontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outline,
                    size: 36,
                    color: Color.fromARGB(255, 151, 71, 255),
                  ),
                  hintText: "Email or user name",
                  contentPadding: EdgeInsets.all(8),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 151, 71, 255),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 151, 71, 255)),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.5, left: width * 0.15),
              height: height * 0.06,
              width: width * 0.7,
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 36,
                    color: Color.fromARGB(255, 151, 71, 255),
                  ),
                  hintText: "Enter your password",
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: Icon(Icons.visibility_outlined),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 151, 71, 255),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 151, 71, 255)),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.55, left: width * 0.5),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forget password ?",
                  style: TextStyle(
                      color: Color.fromARGB(255, 151, 71, 255),
                      fontSize: height * 0.02),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.65, left: width * 0.15),
              height: height * 0.06,
              width: width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 187, 132, 232),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color.fromARGB(255, 151, 71, 255)),
                  ),
                ),
                onPressed: istrue ? null : signin,
                child: Text(
                  "Log in",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.74, left: width * 0.2),
              child: Text(
                "Or sign in with",
                style: TextStyle(
                    color: Color.fromARGB(255, 151, 71, 255), fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.72, left: width * 0.5),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                  );
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      color: Color.fromARGB(255, 151, 71, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.79, left: width * 0.45),
              height: height * 0.07,
              width: width * 0.16,
              child: Card(
                elevation: 10,
                color: Colors.white,
                child: Image(
                  image: AssetImage("assets/images/google1.png"),
                  height: height * 0.05,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.79, left: width * 0.25),
              height: height * 0.07,
              width: width * 0.16,
              child: Card(
                elevation: 10,
                color: Colors.white,
                child: Image(
                  image: AssetImage("assets/images/fb2.png"),
                  height: height * 0.05,
                ),
              ),
            ),
            if (istrue)
              Container(
                color: Colors.black54,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
