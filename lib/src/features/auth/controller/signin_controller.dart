import 'package:chat_app/src/features/models/static_Data.dart';
import 'package:chat_app/src/features/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SigninController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userEmail', isEqualTo: email)
          .where('userPassword', isEqualTo: password)
          .get();

      if (snapshot.docs.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        UserModel model =
            UserModel.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);
        StaticData.model = model;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Signin error: $e");
      return false;
    }
  }
}
