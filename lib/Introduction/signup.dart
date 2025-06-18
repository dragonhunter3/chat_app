import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/Introduction/signin.dart';
import 'package:chat_app/homepages/bottomnavigation.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  bool istrue = false;
  // final Color =  Color.fromARGB(255, 71, 26, 160);
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Icon(
              Icons.chevron_left,
              size: 30,
              color: Color.fromARGB(255, 71, 26, 160),
            ),
            Text(
              "Back",
              style: TextStyle(
                  color: Color.fromARGB(255, 71, 26, 160),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.24, left: width * 0.15),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Color.fromARGB(255, 151, 71, 255),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.3, left: width * 0.15),
              height: height * 0.07,
              width: width * 0.7,
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: namecontroller,
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
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255))))),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.4, left: width * 0.15),
              height: height * 0.07,
              width: width * 0.7,
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 36,
                        color: Color.fromARGB(255, 151, 71, 255),
                      ),
                      hintText: "Email or user name",
                      contentPadding: EdgeInsets.all(8),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255),
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255))))),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.5, left: width * 0.15),
              height: height * 0.06,
              width: width * 0.7,
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
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
                      suffixIcon: Icon(
                        Icons.visibility_outlined,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255),
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255))))),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.6, left: width * 0.15),
              height: height * 0.06,
              width: width * 0.7,
              child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phonecontroller,
                  decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      contentPadding: EdgeInsets.all(8),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255),
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255))))),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.7, left: width * 0.15),
              height: height * 0.06,
              width: width * 0.7,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 187, 132, 232),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Color.fromARGB(255, 151, 71, 255)))),
                  onPressed: () async {
                    // Input validation to ensure no fields are empty
                    if (namecontroller.text.isEmpty ||
                        emailcontroller.text.isEmpty ||
                        passwordcontroller.text.isEmpty ||
                        phonecontroller.text.isEmpty) {
                      Flushbar(
                        message: "Please fill all fields",
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        messageColor: Colors.white,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        margin: EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                      ).show(context);
                      return;
                    }

                    String email = emailcontroller.text.trim();
                    String userId = '';

                    try {
                      // Check if the user already exists in Firestore
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection("users")
                          .where("userEmail", isEqualTo: email)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        // User already exists, show a Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("This email is already registered"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // User does not exist, proceed with signup
                        var uid = Uuid();
                        userId = uid.v4();

                        UserModel model = UserModel(
                          phoneNumber: phonecontroller.text,
                          profilepicture: "",
                          registrationDateTime: DateTime.now().toString(),
                          userPassword: passwordcontroller.text,
                          userEmail: email,
                          userId: userId,
                          userName: namecontroller.text,
                        );

                        // Save the user data to Firestore
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .set(model.toMap());

                        setState(() {
                          istrue = true;
                        });

                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            istrue = false;
                          });
                        });

                        // Show success Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Sign up succeeded"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigation(),
                            ));
                      }
                    } catch (e) {
                      // Log the error to the console
                      print("Error during sign-up: $e");

                      // Show detailed error in a Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Sign up failed: ${e.toString()}"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.78, left: width * 0.15),
              child: Text(
                "Already have an account",
                style: TextStyle(
                    color: Color.fromARGB(255, 151, 71, 255), fontSize: 14),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.765, left: width * 0.55),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninScreen(),
                        ));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        color: Color.fromARGB(255, 151, 71, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            if (istrue)
              Container(
                color: Colors.black54, // Semi-transparent overlay
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
