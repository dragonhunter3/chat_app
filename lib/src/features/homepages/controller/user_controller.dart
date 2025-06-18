import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/src/features/models/usermodel.dart';
import 'package:chat_app/src/features/models/static_Data.dart';
import 'package:chat_app/src/features/models/requestmodel.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _userList = [];
  List<UserModel> get userList => _userList;

  Future<void> fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isNotEqualTo: StaticData.model!.userId)
          .get();

      _userList = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> sendRequest(UserModel receiver) async {
    final uuid = Uuid();
    final requestId = uuid.v4();
    final model = RequestModel(
      reciverName: receiver.userName,
      reciverId: receiver.userId,
      senderName: StaticData.model!.userName,
      senderId: StaticData.model!.userId,
      requestId: requestId,
    );

    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(requestId)
        .set(model.toMap());
  }
}
