// splash_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_app/src/features/auth/signin.dart';

class SplashProvider with ChangeNotifier {
  void startSplashTimer(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      ),
    );
  }
}
