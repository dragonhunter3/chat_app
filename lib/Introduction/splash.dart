import 'dart:async';
import 'package:chat_app/Introduction/signin.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getDataFromSF();
    super.initState();
  }

  getDataFromSF() async {
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SigninScreen(),
            )));
  }

  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.3,
                width: width,
                child: AnimatedContainer(
                  height: height * 0.2,
                  width: width * 0.5,
                  curve: Curves.bounceIn,
                  duration: Duration(seconds: 30),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            color: Colors.black,
                            offset: Offset(1, 1),
                            spreadRadius: 1),
                        BoxShadow(
                            blurRadius: 1,
                            color: Colors.black,
                            offset: Offset(-1, -1),
                            spreadRadius: 1)
                      ],
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.contain)),
                ),
              )
            ],
          )),
    );
  }
}
