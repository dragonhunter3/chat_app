import 'package:chat_app/src/features/auth/signin.dart';
import 'package:chat_app/src/features/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SignupProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _setLoading(true);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This email is already registered"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      String userId = const Uuid().v4();
      UserModel model = UserModel(
        phoneNumber: phone,
        profilepicture: "",
        registrationDateTime: DateTime.now().toString(),
        userPassword: password,
        userEmail: email,
        userId: userId,
        userName: name,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .set(model.toMap());

      _setLoading(false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign up succeeded"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
      );
    } catch (e) {
      _setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign up failed: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
